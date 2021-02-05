extends MarginContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var health_bar = $HBoxContainer/Bars/LifeBar/Health 
onready var health_tween = $HBoxContainer/Bars/LifeBar/Tween 
onready var health_number = $HBoxContainer/Bars/LifeBar/Count/Background/Number

onready var ep_number = $HBoxContainer/Bars/EpBar/Count/Background/Number
onready var ep_tween = $HBoxContainer/Bars/EpBar/Tween
onready var ep_bar = $HBoxContainer/Bars/EpBar/Ep
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_hp_ep(hp, ep):
	health_bar.max_value = hp 
	health_bar.value = hp 
	ep_bar.max_value = ep 
	ep_bar.value = ep
	health_number.text = str(hp)
	ep_number.text = str(ep)

func change_hp(hp):
	var current_hp = health_bar.value
	health_bar.value -= hp
	health_number.text = str(health_bar.value)
	health_tween.interpolate_property(health_bar, "value", current_hp, health_bar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	health_tween.start()
	
	
func change_ep(ep):
	var current_ep = ep_bar.value
	ep_bar.value -= ep
	ep_number.text = str(ep_bar.value)
	ep_tween.interpolate_property(ep_bar, "value", current_ep, ep_bar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	ep_tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Player_change_ep(ep) -> void:
	change_ep(ep)


func _on_Player_change_hp(hp) -> void:
	change_ep(hp)


func _on_Player_set_hp_and_ep(hp, ep) -> void:
	set_hp_ep(hp, ep)
