extends Control


# Función que es llamada al
# presionar el botón "Resume".
func _on_Resume_pressed():
	
	# Quitamos la pausa en el juego
	get_tree().paused = false
	
	# Ocultamos el menú
	self.hide()
