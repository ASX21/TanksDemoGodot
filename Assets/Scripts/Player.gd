extends Sprite

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

# Declaración de variables

# Velocidad actual del vehículo
var speed = 0


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


# Función que rota la torreta
func rotate_turret(delta):
	var global_pos = $Turret.global_transform.get_origin()
	var mouse_position = get_global_mouse_position()
	$Sight.global_position = mouse_position
	$Sight.global_rotation = 0
	var target_vect = global_pos - mouse_position
	var angle = (atan2(target_vect.y, target_vect.x))
	var turret_rot = $Turret.global_rotation
	if angle > turret_rot:
		angle -= PI / 2
	else:
		angle += 3 * PI / 2
	$Turret.global_rotation = lerp(turret_rot, angle, delta * ROTATION_SPEED)
