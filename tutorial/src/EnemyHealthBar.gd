extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween


#func _on_health_updated(health, mount):
#	update_tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.4, Tween.TRANS_SIZE, Tween.EASE_IN_OUT)
#	update_tween.start()
#	
#func _on_max_health_updated(max_health):
#	health_bar.max_value = max_health

func take_damage(health):
	var current_hp = health_bar.value
	health_bar.value -= health
	update_tween.interpolate_property(health_bar, "value", current_hp, health_bar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	yield(update_tween, "tween_all_completed")

func set_health(health):
	health_bar.max_value = health
	health_bar.value = health
