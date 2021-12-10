extends Node

export (PackedScene) var PlayerScene

func _ready():
	pass


func _on_Play_pressed():
	$Menus/MainMenu.hide()
	var player : Player = PlayerScene.instance()
	player.position = Vector2(600, 400)
	self.add_child(player)


func _on_Pause_pressed():
	$Menus/PauseMenu.show()
	get_tree().paused = true
