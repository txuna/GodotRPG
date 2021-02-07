extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi()%2 == 0:
		$TextureRect.texture = load("res://assets/art/inventory/Iron Sword.png")
	else:
		$TextureRect.texture = load("res://assets/art/inventory/Tree Branch.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
