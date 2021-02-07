extends KinematicBody2D

const GRAVITY = 9.8

var attacking = false # 현재 공격중이니 다른 모션은 사용할 수 없게 -> 완전히 공격이 끊낼 수 있도록 
var attack_delay = false # 다음 공격까지 딜레이 타이머 
var invincible = false
#var jumping = false

signal change_hp 
signal change_ep
signal set_hp_and_ep


export var attack_ep = 20
export var slash_ep = 10

var motion = Vector2()

const SWORD = preload("res://src/Sword.tscn")
const DAMAGE_SKIN = preload("res://src/Damage.tscn")

export var player_state = {
	"max_hp" : 1000,
	"current_hp" : 1000,
	"max_ep" : 500,
	"current_ep" : 500,
	"coin" : 0,
	"min_attack" : 100,
	"max_attack" : 400,
	"crit" : 32,
	"crit_damage" : 2,
	"def" : 100, 
	"speed" : 10,
	"max_speed" : 200,
	"jump_height" : 500,
}

export var player_inventory = {
	"item" : [
		{
			"item_name" : "BIG Sword",
			"description" : "This is Big sword...",
			"plus_state" : {
				"attack" : 100, 
			},
			"kindof" : "equipment",
		},
		{
			"item_name" : "Branch",
			"description" : "This is Small Branch",
			"plus_state" : {
				"attack" : 10,
			},
			"kindof" : "equipment",
		},
		{
			"item_name" : "Red Potion",
			"description" : "this is red potion",
			"plus_state" : {
				"current_hp" : 20,
			},
			"kindof" : "consumption",
		}
	]
}

#position은 나중에 스킬 나갈때 쓰는 위치 

func _ready() -> void:
	emit_signal("set_hp_and_ep", player_state["max_hp"], player_state["max_ep"])

func _physics_process(delta):
	motion.y += GRAVITY
	# 공격모션이 중간에 끊기지 않게 하기위해 
	if attacking == false:
		if Input.is_action_pressed("ui_right"):
			motion.x += player_state["speed"]
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1 
		
		elif Input.is_action_pressed("ui_left"):
			motion.x -= player_state["speed"]
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		
		elif attacking == false:
			motion.x = lerp(motion.x, 0, 0.1)
			if motion.y < GRAVITY:
				$AnimatedSprite.play("jump")
			if motion.y > GRAVITY:
				$AnimatedSprite.play("fall")
			if int(motion.y) == int(GRAVITY):
				$AnimatedSprite.play("stand")
		
	if motion.x > player_state["max_speed"]:
		motion.x = player_state["max_speed"]
	if motion.x < -player_state["max_speed"]:
		motion.x = -player_state["max_speed"]
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			motion.y -= player_state["jump_height"]

			
	if attack_delay == false:
		if Input.is_action_just_pressed("attack"):
			set_skill("attack")
	
		if Input.is_action_just_pressed("skill"):
			set_skill("slash")
		
	motion = move_and_slide(motion, Vector2.UP)
	if invincible == true:
		return
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("enemies"):
			invincible = true
			$InvincibleTimer.start()
			take_damage(collision.collider.attack())
			return
		elif collision.collider.is_in_group("coins"):
			player_state["coin"] = collision.collider.get_coin_value()
			collision.collider.queue_free()

func set_skill(skill_type: String) ->void:
	var skill_instance
	var direction = get_skill_direction()
	
	if check_possible_skill_ep(skill_type):
		if skill_type == "attack":
			skill_instance = SWORD.instance()

		elif skill_type == "slash":
			skill_instance = SWORD.instance()

	else:
		return
	
	#skill_instance.set_direction(1)
	attacking = true
	attack_delay = true
	$AnimatedSprite.play(skill_type)
	skill_instance.set_damage(player_state)
	get_parent().add_child(skill_instance)
	skill_instance.position = $Position2D.global_position
	$SkillDelay.start()
	

func get_skill_direction() -> int:
	if sign($Position2D.position.x) == 1:
		return 1
	else:
		return -1

func check_possible_skill_ep(skill_type: String) -> bool:
	if skill_type == "attack":
		if player_state["current_ep"] - attack_ep >= 0:
			player_state["current_ep"] -= attack_ep
			emit_signal("change_ep", attack_ep)
			return true
		else:
			return false
	elif skill_type == "slash":
		if player_state["current_ep"] - slash_ep >= 0:
			player_state["current_ep"] -= slash_ep
			emit_signal("change_ep", slash_ep)
			return true
		else:
			return false
	else:
		return false

func take_damage(enemy_damage):
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.rect_position = $DamagePosition.position
	add_child(damage_skin)
	damage_skin.show_value(enemy_damage, false)
	if player_state["current_hp"] - enemy_damage <= 0:
		pass
	else:
		player_state["current_hp"] -= enemy_damage
		emit_signal("change_hp", enemy_damage)
	

func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "attack" or $AnimatedSprite.animation == "slash":
		$AnimatedSprite.stop()
		attacking = false


func _on_SkillDelay_timeout() -> void:
	attack_delay = false


func _on_InvincibleTimer_timeout() -> void:
	invincible = false
