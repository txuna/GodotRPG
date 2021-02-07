extends KinematicBody2D


var motion = Vector2()
const GRAVITY = 9.8
var coin_value = 0 
# Coin에도 gravity를 넣어서 돈을 떨어트릴 수 있게 (공중에 있을 시)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func set_value(value):
	coin_value = value

func get_coin_value():
	return coin_value

func _physics_process(delta: float) -> void:
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
