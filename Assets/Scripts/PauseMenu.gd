extends Control


func _ready():
	pass


func _on_Resume_pressed():
	get_tree().paused = false
	self.hide()
