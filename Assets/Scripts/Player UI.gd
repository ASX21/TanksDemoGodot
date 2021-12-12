extends CanvasLayer


func _ready():
	shot(0.1)

func set_health(health):
	$HPBar.max_value = health
	$HPBar.value = health

func damage(dmg):
	$Tween.interpolate_property($HPBar, "value", null, $HPBar.value - dmg, 1)
	$Tween.start()

func shot(time):
	$Tween.interpolate_property($ReloadBar, "value", 0, $ReloadBar.max_value, time)
	$Tween.start()

func get_sight():
	return $Sight
