extends Node2D
class_name Player

# Declaración de constantes

# Aceleración y desaceleración
const ACCEL = 2
const DECEL = 1

# Velocidades máxima en reversa y hacia adelante
const BACKWARD_SPEED = 3
const FORWARD_SPEED = -5

# Velocidad de rotación del vehículo
const ROTATION_SPEED = 1.25

# Velocidad de rotación de la torreta
const TURRET_ROTATION_SPEED = 2.25

# Tiempo de recarga del APFSDS
const RELOAD_TIME_AP = 3

# Tiempo de recarga del HEAT-FS
const RELOAD_TIME_HE = 1.5

# Declaración de variables

# Velocidad actual del vehículo
var speed = 0

# Salud del jugador
var health

# Interfaz del jugador
var ui

# Mira que destaca la posición del ratón
var sight

# Tiempo restante de recarga
var reload

# La palabra clave "export" permite cambiar
# el valor de la variable desde el editor.
# La variable aparece como un campo en
# el inspector. El tipo hay que indicarlo
# entre paréntesis con el nombre de la clase.

# Escena empaquetada que contiene la interfaz del jugador
export (PackedScene) var UIScene

# Escena empaquetada que representa un proyectil
export (PackedScene) var ProjectileScene

# Declaración de señales

# Muerte del jugador
signal player_died

# Disparo con el
# tiempo de recarga
# como parámetro.
signal shot(time)

# La función ready se ejecuta cuando
# se crea una instancia del jugador.
func _ready():
	# Ponemos el tiempo de recarga a 0 para poder disparar
	reload = 0
	# Ponemos la salud del jugador a su valor inicial
	health = 10
	# Creamos una instancia de la escena 
	ui = UIScene.instance()
	ui.set_health(health)
	self.connect("shot", ui, "shot")
	self.add_child(ui)
	sight = ui.get_sight()

# Esta función es llamada una vez por fotograma.
# El parámetro delta es el tiempo transcurrido entre el fotograma actual y el anterior.
# Delta tiene la función de suavizar el movimiento, ya que si no lo usásemos al cambiar
# los FPS del juego, cambiaría la velocidad a la que, en este caso, se mueve el tanque.
func _process(delta):
	
	# Llamamos a la función que rota la torreta y le pasamos el parámetro delta.
	rotate_turret(delta)
	
	# Usamos la función rotate(...), vamos a rotar a velocidad ROTATION_SPEED
	# en la dirección que resulte del eje izquierda-derecha.
	# Es decir, si hay que girar hacia la derecha, giramos a velocidad
	# ROTATION_SPEED * delta (para hacer que el movimiento no dependa de los FPS);
	# y si es hacia la izquierda, Input.get_axis(...) devolverá -1 y girará en sentido
	# contrario a la misma velocidad. Si no pulsas ninguna de las dos,
	# Input.get_axis(...) devuelve 0, de forma que no rota.
	rotate(Input.get_axis("ui_left", "ui_right") * delta * ROTATION_SPEED)
	
	# Obtenemos, como antes, el valor del eje arriba-abajo. En este caso
	# lo vamos a usar para la aceleración. Lo guardamos en una variable.
	# En este caso usamos arriba como valor negativo, ya que en Godot,
	# el eje Y está invertido.
	var accel_axis = Input.get_axis("ui_up", "ui_down")
	
	# Comprobamos si se NO se está pulsando ninguno de los botones.
	if accel_axis == 0:
		# En caso afirmativo, deceleramos lentamente. La función lerp(...)
		# sirve para hacer algo llamado interpolación. Básicamente, permite
		# cambiar desde un valor a otro progresivamente. Como nota, usar
		# este método hace que cuánto más cercano esté a detenerse, más
		# le costará detenerse completamente.
		speed = lerp(speed, 0, DECEL * delta)
	
	# Incrementamos la velocidad con el valor del eje arriba-abajo,
	# a ritmo de ACCEL * delta, usando delta para que sea independiente
	# de los FPS
	speed += accel_axis * delta * ACCEL
	
	# Nos aseguramos de que la velocidad no supere la máxima si
	# va hacia delante o la mínima si va hacia atrás
	speed = clamp(speed, FORWARD_SPEED, BACKWARD_SPEED)
	
	# Aplicamos el cambio en la posición del tanque.
	# Para ello, obtenemos primero un vector con los componentes
	# de la rotación del vehículo. Esto nos sirve para que el vehículo
	# se mueva en la dirección que queramos.
	# Después, normalizamos el vector obtenido. Es decir, hacemos que su
	# longitud sea SIEMPRE 1. Con esto evitamos que el tanque vaya a
	# distintas velocidades dependiendo de cuál sea su rotación.
	# Por último, multiplicamos el vector de la dirección por la
	# velocidad actual del vehículo. El resultado de esto va a ser en
	# cuánto va a cambiar su posición.
	position += Vector2(-sin(rotation), cos(rotation)).normalized() * speed
	
	# Limitamos la posición del jugador
	# para que no pueda salir del mapa.
	# Los números son simplemente las
	# coordenadas del límite del mapa.
	position.x = clamp(position.x, 0, 3328)
	position.y = clamp(position.y, 0, 2304)
	
	# Comprobamos si podemos disparar,
	# es decir, el tiempo de recarga
	# está a cero. También se puede
	# hacer con un temporizador.
	if reload <= 0:
		
		# Comprobamos si se está presionando
		# el click izquierdo del ratón.
		if Input.is_mouse_button_pressed(1):
			
			# Llamamos a la función disparar AP
			shoot_ap()
			
			# Emitimos la señal "shot"
			emit_signal("shot", RELOAD_TIME_AP)
			
			# Ponemos el tiempo restante
			# para disparar de nuevo al
			# valor del tiempo de recarga.
			reload = RELOAD_TIME_AP
		
		# Comprobamos si se está presionando
		# el click derecho del ratón.
		elif Input.is_mouse_button_pressed(2):
			
			# Llamamos a la función disparar HE
			shoot_he()
			
			# Emitimos la señal "shot"
			emit_signal("shot", RELOAD_TIME_HE)
			
			# Ponemos el tiempo restante
			# para disparar de nuevo al
			# valor del tiempo de recarga.
			reload = RELOAD_TIME_HE
	
	# Al no poder disparar, restamos
	# el tiempo que ha transcurrido
	else:
		reload -= delta


# Función que rota la torreta
func rotate_turret(delta):
	
	# Primero obtenemos la posición global de la torreta, es decir,
	# la posición respecto al punto de origen (0, 0)
	var global_pos = $Sprites/Turret.global_transform.get_origin()
	
	# Conseguimos la posición global del ratón. También se puede obtener
	# la posición relativa, pero como la cámara se mueve, no funciona bien.
	var mouse_position = get_global_mouse_position()
	
	# Movemos la mira a la ubicación del
	# ratón y reiniciamos su rotación.
	# En este caso no usamos la ubicación
	# global del ratón, sino su posición
	# en la pantalla mediante la
	# obtención primero del Viewport.
	sight.global_position = get_viewport().get_mouse_position()
	sight.global_rotation = 0
	
	# Calculamos el vector que une la posición
	# del ratón y la posición de la torreta.
	# Este vector es el resultado de restarle a la
	# posición de la torreta la del ratón.
	var target_vect = global_pos - mouse_position
	
	# Calculamos el ángulo que forma el vector objetivo
	# con la función atan2(...). A esta función le pasamos
	# el valor del eje y del vector como primer parámetro y
	# el valor del eje x como segundo parámetro. El resultado
	# es el ángulo que forma el vector con el eje X.
	var angle = atan2(target_vect.y, target_vect.x)
	
	# Obtenemos la rotación de la torreta
	# y la guardamos en una variable
	var turret_rot = $Sprites/Turret.global_rotation
	
	# Corregimos el ángulo resultado de la operación anterior
	# (está girado 90º). Para esto, comprobamos cuál de los
	# dos ángulos es mayor, si el actual de rotación de la
	# torreta o el objetivo. Lo corregimos de esta manera
	# de forma que el ángulo objetivo siempre es de los 2
	# posibles el más cercano al que queremos obtener. Es
	# decir, le restamos 90º o le sumamos 270º según nos
	# convenga. Nota: el ángulo está en radianes.
	if angle > turret_rot:
		angle -= PI / 2
	else:
		angle += 3 * PI / 2
	
	# Aplicamos la rotación a la torreta. Lo hacemos de
	# forma global para que no le afecte la rotación del
	# chasis. Usamos interpolación para que no sea instantáneo.
	$Sprites/Turret.global_rotation = lerp(turret_rot, angle, delta * ROTATION_SPEED)

# Función que se ejecuta al hacer click izquierdo.
# Representa un proyectil HEAT-FS, que al ser
# más lento, se usa un proyectil físico.
func shoot_he():
	
	# Creamos una instancia del proyectil
	var proj = ProjectileScene.instance()
	
	# Ponemos la posición en el extremo del cañón
	proj.global_position = $Sprites/Turret/Cannon/ShootPosition.global_position
	
	# Lo rotamos de forma que tenga la dirección y sentido del cañón
	proj.global_rotation = $Sprites/Turret/Cannon/ShootPosition.global_rotation
	
	# Añadimos el proyectil al nodo raíz.
	# De esta forma, si el jugador se mueve
	# no lo hace el proyectil con él.
	get_tree().get_root().get_node("Root").add_child(proj)

# Función que se ejecuta al hacer click derecho.
# Representa un proyectil APFSDS, que al ser muy
# rápido en la vida real, se usa un raycast
# en vez de usar un proyectil físico.
# A IMPLEMENTAR.
func shoot_ap():
	pass # Palabra clave que se usa para
	# que no de error tener una función vacía.

# Sobreescribimos la función
# get_class(), ya que por
# defecto devuelve "Node2D"
# y nos interesa que
# devuelva "Player".
func get_class():
	return "Player"

# Función que se ejecuta al
# ser impactado el jugador
func player_hit():
	
	# Le restamos uno de vida
	health -= 1
	
	# Reflejamos el daño
	# en la barra de salud.
	ui.damage(1)
	
	# Si la salud es 0,
	# emitimos la señal
	# de jugador muerto.
	if health == 0:
		emit_signal("player_died")

# Función que se ejecuta cada vez que
# el jugador detecta un área entrando.
func _on_HitDetector_area_entered(area):
	
	# Llamamos a la función de jugador impactado
	player_hit()
