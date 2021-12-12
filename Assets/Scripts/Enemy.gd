extends Node2D

# Declaración de constantes
const SPEED = -100
# Velocidad de rotación del vehículo
const ROTATION_SPEED = 2

# Declaración de variables

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
	reload = 0
	player = get_parent().get_node("Player")
	rotate_towards_player()

func _process(delta):
	rotate_turret(delta)
	var distance_player_target = (player.global_position - target_pos).length()
	if distance_player_target > 500:
		rotate_towards_player()
	
	var distance_to_player = (player.global_position - self.global_position).length()
	if distance_to_player > 300:
		position += Vector2(-sin(rotation), cos(rotation)).normalized() * SPEED * delta
	
	if reload <= 0:
		if distance_to_player <= 1000:
			shoot()
	else:
		reload -= delta
	
	# Limitamos la posición del jugador
	# para que no pueda salir del mapa.
	# Los números son simplemente las
	# coordenadas del límite del mapa.
	if global_position.x < 0 || global_position.x > 3328:
		queue_free()
	if global_position.y < 0 || global_position.y > 2304:
		queue_free()
	
	rotation = lerp(rotation, target_rotation, delta * ROTATION_SPEED)

func rotate_towards_player():
	target_pos = player.global_position
	var target_vect = target_pos - global_position
	target_rotation = atan2(target_vect.y, target_vect.x) 
	if target_rotation > global_rotation:
		target_rotation -= 3 * PI / 2
	else:
		target_rotation += PI / 2

func rotate_turret(delta):
	var turret_target_vect = player.global_position - global_position
	var turret_target_rotation = atan2(turret_target_vect.y, turret_target_vect.x)
	
	
	if turret_target_rotation > $Sprites/Turret.global_rotation:
		turret_target_rotation -= 3 * PI / 2
	else:
		turret_target_rotation += PI / 2
	
	$Sprites/Turret.global_rotation = lerp($Sprites/Turret.global_rotation, turret_target_rotation, delta)

# Función que dispara un proyectil
func shoot():
	var proj = ProjectileScene.instance()
	proj.global_position = $Sprites/Turret/Cannon/ShootPosition.global_position
	proj.global_rotation = $Sprites/Turret/Cannon/ShootPosition.global_rotation
	proj.shot_by_enemy()
	get_tree().get_root().get_node("Root").add_child(proj)
	reload = 2

func _on_HitDetector_area_entered(area):
	queue_free()
