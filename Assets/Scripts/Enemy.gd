extends Node2D

# Declaración de constantes
const SPEED = -100
# Velocidad de rotación del vehículo
const ROTATION_SPEED = 2

# Declaración de variables

# Al declarar variables que
# no son inicializadas, es
# decir, no le damos un valor
# inicial, es recomendable poner
# su tipo con ": Clase"

# Variable usada para
# almacenar una referencia
# al nodo del jugador.
var player : Player

# Posición objetivo del vehículo
var target_pos : Vector2

# Rotación objetivo del chasis
var target_rotation : float

# Tiempo restante de recarga
var reload

# Escena empaquetada que representa un proyectil
export (PackedScene) var ProjectileScene


func _ready():
	# Ponemos el valor de la
	# recarga a su valor inicial
	reload = 1
	
	# Obtenemos el nodo del jugador,
	# que es un hijo directo del nodo
	# padre, en este caso, el nodo
	# raíz del árbol del juego.
	player = get_parent().get_node("Player")
	
	# Rotamos inicialmente al enemigo
	# para que mire hacia el jugador.
	rotate_towards_player()

# Función llamada al principio de cada
# fotograma. Más detalle en la escena Player.
func _process(delta):
	
	# Rotamos la torreta del enemigo
	rotate_turret(delta)
	
	# Distancia numérica entre la posición del jugador
	# y el punto hacia el cuál se mueve el enemigo.
	# Esta distancia es la longitud del vector
	# resultante de la diferencia de ambas posiciones.
	# La distancia siempre es positiva y no importa el
	# orden de la resta, ya que aunque el resultado
	# cambia de sentido, su dirección y longitud es
	# exactamente la misma.
	var distance_player_target = (player.global_position - target_pos).length()
	
	# Comprobamos si el jugador se ha separado
	# más de 500 unidades de la posición objetivo.
	if distance_player_target > 500:
		# En caso de ser así, rotamos
		# al enemigo hacia el jugador.
		rotate_towards_player()
	
	# Distancia entre el enemigo y el jugador.
	# Siguiendo exactamente la misma lógica
	# que la distancia anterior.
	var distance_to_player = (player.global_position - self.global_position).length()
	
	# Comprobamos si el enemigo está cerca del jugador
	if distance_to_player > 300:
		
		# En caso de estar a más de 300
		# unidades, movemos al enemigo
		# hacia el jugador.
		position += Vector2(-sin(rotation), cos(rotation)).normalized() * SPEED * delta
	
	# Comprobamos si el tiempo restante
	# de recarga es menor o igual a 0.
	if reload <= 0:
		# Si lo es, comprobamos que
		# esté a menos de 1000 unidades
		# de distancia del jugador.
		if distance_to_player <= 1000:
			# Si lo está, el
			# enemigo dispara.
			shoot()
	else:
		# Si no ha recargado, seguimos
		# disminuyendo el tiempo que
		# queda para recargar.
		reload -= delta
	
	# Limitamos la posición del enemigo
	# para que no pueda salir del mapa.
	# Los números son simplemente las
	# coordenadas del límite del mapa.
	# Nota: no sería necesario, dado
	# que al perseguir el jugador,
	# el enemigo no sale del mapa.
	# Si modificas parámetros y no
	# aparecen enemigos, puede que estén
	# saliendo del mapa y siendo eliminados.
	if global_position.x < 0 || global_position.x > 3328:
		queue_free()
	if global_position.y < 0 || global_position.y > 2304:
		queue_free()
	
	# Aplicamos la rotación con interpolación
	# lineal para que sea más suave.
	rotation = lerp(rotation, target_rotation, delta * ROTATION_SPEED)

# Función que se ejecuta cuando
# hace falta cambiar la dirección
# del enemigo para que vaya
# hacia el jugador.
func rotate_towards_player():
	
	# Guardamos la posición del
	# jugador como la posición a la
	# que se va a dirigir el enemigo.
	target_pos = player.global_position
	
	# Vector que une la posición del
	# enemigo a la posición objetivo.
	var target_vect = target_pos - global_position
	
	# Guardamos la rotación objetivo para
	# poder rotar lentamente el enemigo.
	target_rotation = atan2(target_vect.y, target_vect.x)
	
	# Como en el jugador, comprobamos y
	# corregimos la rotación objetivo.
	# El ángulo está en radianes.
	if target_rotation > global_rotation:
		target_rotation -= 3 * PI / 2
	else:
		target_rotation += PI / 2

# Función que rota la torreta del
# enemigo apuntando al jugador.
# El parámetro delta se usa para
# que sea independiente de los FPS.
func rotate_turret(delta):
	# Calculamos el vector desde la posición del
	# enemigo hasta la posición del jugador.
	var turret_target_vect = player.global_position - global_position
	
	# Calculamos el ángulo de rotación objetivo de la torreta
	var turret_target_rotation = atan2(turret_target_vect.y, turret_target_vect.x)
	
	# Como antes y en el jugador, corregimos la rotación objetivo
	# de la torreta para que vaya por el camino más corto.
	if turret_target_rotation > $Sprites/Turret.global_rotation:
		turret_target_rotation -= 3 * PI / 2
	else:
		turret_target_rotation += PI / 2
	
	# Aplicamos la rotación con interpolación lineal
	$Sprites/Turret.global_rotation = lerp($Sprites/Turret.global_rotation, turret_target_rotation, delta)

# Función que dispara un proyectil
func shoot():
	
	# Creamos una instancia del proyectil
	var proj = ProjectileScene.instance()
	
	# Ponemos la posición en el extremo del cañón
	proj.global_position = $Sprites/Turret/Cannon/ShootPosition.global_position
	
	# Lo rotamos de forma que tenga la dirección y sentido del cañón
	proj.global_rotation = $Sprites/Turret/Cannon/ShootPosition.global_rotation
	
	# Cambiamos la capa para
	# que lo detecte el jugador
	# pero no otros enemigos.
	proj.shot_by_enemy()
	
	
	# Añadimos el proyectil al nodo raíz.
	# De esta forma, si el enemigo se mueve
	# no lo hace el proyectil con él.
	get_tree().get_root().get_node("Root").add_child(proj)
	
	# Ponemos el tiempo de recarga
	# al número de segundos que
	# queremos que tarde en
	# volver a disparar.
	reload = 2

# Función que se ejecuta
# cuando el enemigo entra
# en contacto con otra área.
func _on_HitDetector_area_entered(area):
	# Eliminamos el enemigo
	queue_free()
