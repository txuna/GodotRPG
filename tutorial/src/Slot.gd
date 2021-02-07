extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var ItemClass = preload("res://src/Item.tscn")
var item = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi() % 2 == 0:
		item = ItemClass.instance() 
		add_child(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
