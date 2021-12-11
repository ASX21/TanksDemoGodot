extends Node2D

# Declaración de constantes
const SPEED = -100

# Declaración de variables

# Variable usada para
# almacenar una referencia
# al nodo del jugador
var player : Player


func _ready():
	player = get_parent().get_node("Player")
	var target_pos = player.global_position - global_position
	rotation = atan2(target_pos.y, target_pos.x) + PI / 2

func _process(delta):
	var distance = (player.global_position - self.global_position).length()
	if distance > 300:
		position += Vector2(-sin(rotation), cos(rotation)).normalized() * SPEED * delta
	
	if global_position.x < 0 || global_position.x > 3328:
		queue_free()
	if global_position.y < 0 || global_position.y > 2304:
		queue_free()
