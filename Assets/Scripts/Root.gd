extends Node

# Declaración de variables

# Variable que contiene la escena empaquetada del jugador
export (PackedScene) var PlayerScene
# Variable que contiene la escena empaquetada del enemigo
export (PackedScene) var EnemyScene

# La función ready se ejecuta cuando
# se crea una instancia, en este
# caso, al inicio del juego.
func _ready():
	
	# Hacemos que la semilla sea aleatoria. Sin esto los números
	# generados de forma aleatoria serían siempre los mismos.
	randomize()
	
	# Conectamos la señal del botón de menú mediante el
	# uso de la función connect(...). Los parámetros son:
	# 1- Nombre de la señal a conectar
	# 2- Objeto a la cuál vamos a conectar la señal
	# 3- Nombre de la función a la que vamos a conectar
	# En este caso no es necesario hacerlo de esta manera,
	# ya que usar connect(...) es más útil cuando tenemos
	# que instanciar algo mediante código que contiene
	# una señal que queremos monitorizar.
	$Menus/PauseMenu/HBoxContainer/VBoxContainer/Menu.connect("pressed", self, "return_menu")

# Función que se ejecuta al pulsar el botón "Play"
func _on_Play_pressed():
	# Ocultamos el menú principal
	$Menus/MainMenu.hide()
	
	# Mostramos la interfaz del juego (botón de pausa)
	$Menus/InGame.show()
	
	# Creamos una instancia de la escena
	# del jugador y la almacenamos en
	# una variable llamada "player".
	var player : Player = PlayerScene.instance()
	
	# Cambiamos la posición del jugador para
	# que esté cerca del centro de la pantalla.
	player.position = Vector2(600, 400)
	
	# Conectamos la señal de jugador muerto
	# para que al morir vuelva al menú.
	player.connect("player_died", self, "end_game")
	
	# Cambiamos el nombre al nodo
	# para poder encontrarlo más
	# fácilmente. Esto solo cambia
	# el nombre de la instancia.
	player.name = "Player"
	# Añadimos el nodo del jugador a
	# la escena. Antes únicamente
	# habíamos creado el nodo.
	# NO lo habíamos añadido.
	self.add_child(player)
	
	# Empezamos el temporizador
	# para que vayan apareciendo enemigos
	$Spawner.start()

# Función que se ejecuta al pulsar el botón "Pause"
func _on_Pause_pressed():
	
	# Mostramos el menú de pausa
	$Menus/PauseMenu.show()
	
	# Pausamos el árbol, es decir, el juego
	get_tree().paused = true

func return_menu():
	# Despausamos el juego
	get_tree().paused = false
	
	# Ocultamos el menú de pausa
	$Menus/PauseMenu.hide()
	
	# Terminamos la partida
	end_game()

# Función que se ejecuta al terminar la partida.
# Se ejecuta ya sea por volver al menú o morir el jugador.
func end_game():
	# Mostramos el menú principal
	$Menus/MainMenu.show()
	
	# Ocultamos el botón de pausa
	$Menus/InGame.hide()
	
	# Detenemos el temporizador
	$Spawner.stop()
	
	# Este bucle recorre cada uno
	# de los elementos hijos de Root.
	for child in self.get_children():
		
		# Comprobamos si la clase del
		# nodo hijo es "Player" o si el
		# nodo está en el grupo "Enemies".
		if child.get_class() == "Player" or child.is_in_group("Enemies"):
			
			# En caso de que sea así, se elimina 
			# el nodo hijo de la escena.
			self.remove_child(child)
			
			# Eliminamos el nodo
			# hijo de forma segura.
			child.queue_free()
	


# Función que se ejecuta al llegar el
# temporizador a 0. Esta función hace
# aparecer un enemigo en un punto aleatorio
# de la curva definida en SpawnPositions.
func _on_Spawner_timeout():
	
	$SpawnPositions/SpawnPosition.offset = randi()
	var enemy = EnemyScene.instance()
	enemy.position = $SpawnPositions/SpawnPosition.position
	enemy.add_to_group("Enemies")
	add_child(enemy)

