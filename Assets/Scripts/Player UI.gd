extends CanvasLayer

# Función que es llamada
# al ser instanciado el nodo
func _ready():
	
	# Ponemos la barra de
	# recarga al máximo
	shot(0.1)

# Función para establecer
# el valor de salud de
# la barra de salud.
func set_health(health):
	
	# Establecemos el valor máximo
	$HPBar.max_value = health
	
	# Establecemos el valor actual
	$HPBar.value = health

# Función que es llamada
# al ser dañado el jugador
func damage(dmg):
	
	# Usamos un objeto "Tween" para
	# animar la barra de salud.
	# El nodo Tween se encarga de
	# animar una propiedad mediante
	# interpolación. Los parámetros son:
	# 1- Nodo a animar
	# 2- Nombre de la propiedad a animar
	# 3- Valor inicial de la propiedad,
	# pasando null se usa el valor actual.
	# 4- Valor final de la propiedad
	# 5- Número de segundos que va a tardar
	$Tween.interpolate_property($HPBar, "value", null, $HPBar.value - dmg, 1)
	
	# Iniciamos la animación
	$Tween.start()

# Función que es llamada al disparar
# el jugador. El parámetro es el
# tiempo de recarga tras disparar.
func shot(time):
	
	# Como antes, usamos un objeto "Tween"
	# para animar la barra de recarga.
	$Tween.interpolate_property($ReloadBar, "value", 0, $ReloadBar.max_value, time)
	
	# Iniciamos la animación
	$Tween.start()

# Función para obtener
# una referencia a
# la mira.
func get_sight():
	
	# Devuelve una referencia
	# a la mira.
	return $Sight
