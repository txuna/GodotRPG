extends Area2D

const SPEED = 800 
var velocity = Vector2()
var direction = 1
var skill_damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func set_direction(dir) -> void:
	direction = dir 
	if dir == -1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func set_damage(damage) -> void:
	skill_damage = damage

#func _physics_process(delta: float) -> void:
#	velocity.x = SPEED * delta * direction
#	translate(velocity)



func _on_Sword_body_entered(body: Node) -> void:
	if "Enemy" in body.name:
		body.take_damage(skill_damage)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


# 스킬 지속시간 
func _on_AliveTimer_timeout() -> void:
	queue_free()
