extends Area2D

const SPEED = 800 
var velocity = Vector2()
var direction = 1
var skill_damages = {} #damage dict
var player_stats = {}

const SKILL_DAMAGE_PERCENT = 80
const SKILL_NUMBER_OF = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func set_direction(dir) -> void:
	direction = dir 
	if dir == -1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func set_damage(stats) -> void:
	player_stats = stats

#func _physics_process(delta: float) -> void:
#	velocity.x = SPEED * delta * direction
#	translate(velocity)



func _on_Sword_body_entered(body: Node) -> void:
	if "Enemy" in body.name:
		for i in range(SKILL_NUMBER_OF):
			var crit
			var damage = int(rand_range(player_stats["min_attack"], player_stats["max_attack"]))
			damage = int(damage * SKILL_DAMAGE_PERCENT / 100)
			var temp = rand_range(0, 100)
			if temp <= player_stats["crit"]:
				crit = true
				damage *= player_stats["crit_damage"]
			else:
				crit = false
			body.take_damage(damage, crit, i)

	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


# 스킬 지속시간 
func _on_AliveTimer_timeout() -> void:
	queue_free()
