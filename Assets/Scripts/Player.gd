extends Sprite

#Constantes a usar
const ACCEL = 2
const DECEL = 1
const BACKWARD_SPEED = 3
const FORWARD_SPEED = -5
const ROTATION_SPEED = 1.25
const TURRET_ROTATION_SPEED = 2.25
var speed = 0

func _ready():
	pass

# Esta función es llamada una vez por fotograma.
# El parámetro delta es el tiempo transcurrido entre el fotograma actual y el anterior.
# Delta tiene la función de suavizar el movimiento, ya que si no lo usásemos al cambiar
# los FPS del juego, cambiaría la velocidad a la que, en este caso, se mueve el tanque.
func _process(delta):
	#Llamamos a la función que rota la torreta y le pasamos el parámetro delta
	rotate_turret(delta)
	rotate(Input.get_axis("ui_left", "ui_right") * delta * ROTATION_SPEED)
	var accel_axis = Input.get_axis("ui_up", "ui_down")
	if accel_axis == 0:
		speed = lerp(speed, 0, DECEL * delta)
	speed += accel_axis * delta * ACCEL
	speed = clamp(speed, FORWARD_SPEED, BACKWARD_SPEED)
	print(speed)
	position += Vector2(-sin(rotation), cos(rotation)).normalized() * speed

func rotate_turret(delta):
	var global_pos = $Turret.global_transform.get_origin()
	var mouse_position = get_global_mouse_position()
	var target_vect = global_pos - mouse_position
	var angle = (atan2(target_vect.y, target_vect.x))
	var turret_rot = $Turret.global_rotation
	if angle > turret_rot:
		angle -= PI / 2
	else:
		angle += 3 * PI / 2
	$Turret.global_rotation = lerp(turret_rot, angle, delta * ROTATION_SPEED)
