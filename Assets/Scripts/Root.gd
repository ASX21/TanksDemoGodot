extends Node

export (PackedScene) var PlayerScene

func _ready():
	$Menus/PauseMenu/HBoxContainer/VBoxContainer/Menu.connect("pressed", self, "_end_game")

func _on_Play_pressed():
	$Menus/MainMenu.hide()
	$Menus/InGame.show()
	var player : Player = PlayerScene.instance()
	player.position = Vector2(600, 400)
	self.add_child(player)


func _on_Pause_pressed():
	$Menus/PauseMenu.show()
	get_tree().paused = true



func _end_game():
	$Menus/MainMenu.show()
	$Menus/InGame.show()
	for child in self.get_children():
		if child.get_class() == Player || child.is_in_group("Enemies"):
			self.remove_child(child)
