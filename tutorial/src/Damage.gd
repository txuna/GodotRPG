extends Label

const DURATION = 2 
const TRAVEL = Vector2(0, -80)
const SPREAD = PI/2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show_value(value, crit=false):
	text = str(value)
	var movment = TRAVEL.rotated(rand_range(-SPREAD/2, SPREAD/2))
	rect_pivot_offset = rect_size / 2

	$Tween.interpolate_property(self, "rect_position", rect_position, rect_position+movment, DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	if crit:
		modulate = Color(1, 0, 0)
		$Tween.interpolate_property(self, "rect_scale", rect_scale*2, rect_scale, 0.4, Tween.TRANS_BACK, Tween.EASE_IN)

	$Tween.start()
	yield($Tween, "tween_all_completed") #tween이 완료될떄까지 기다림 
	queue_free()
