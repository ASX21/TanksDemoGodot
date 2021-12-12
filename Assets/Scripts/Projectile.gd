extends Node2D

# Declaración de constantes

# Velocidad del movimiento del proyectil
const SPEED = -400

# Función que es llamada
# al ser instanciado
# un proyectil.
func _ready():
	# Activamos la emisión
	# del humo del proyectil.
	$Smoke.emitting = true

# Función llamada al principio de cada
# fotograma. Más detalle en la escena Player.
func _process(delta):
	# Desplazamos el proyectil teniendo en cuenta su rotación
	position += Vector2(-sin(rotation), cos(rotation)).normalized() * delta * SPEED
	
	# Limitamos la posición del proyectil
	# para que no pueda salir del mapa.
	# Los números son simplemente las
	# coordenadas del límite del mapa.
	# En caso de salir se borra.
	if global_position.x < 0 || global_position.x > 3328:
		queue_free()
	if global_position.y < 0 || global_position.y > 2304:
		queue_free()

# Función que es llamada
# cuando el proyectil va a
# ser disparado por un enemigo.
func shot_by_enemy():
	
	# Cambiamos el Collision Layer
	# para que el jugador detecte
	# la entrada del proyectil.
	$Area2D.set_collision_layer(2)

# Función que se ejecuta
# cuando el proyectil entra
# en contacto con otra área.
func _on_Area2D_area_entered(area):
	
	# Eliminamos el proyectil
	queue_free()
