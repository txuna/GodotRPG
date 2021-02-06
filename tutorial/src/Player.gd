extends KinematicBody2D

const GRAVITY = 9.8
const SPEED = 10
const MAX_SPEED = 200
const JUMP_HEIGHT = 500
var attacking = false # 현재 공격중이니 다른 모션은 사용할 수 없게 -> 완전히 공격이 끊낼 수 있도록 
var attack_delay = false # 다음 공격까지 딜레이 타이머 

#var jumping = false

signal change_hp 
signal change_ep
signal set_hp_and_ep

export var health = 100
export var ep = 3000

export var attack_ep = 20
export var slash_ep = 10

var motion = Vector2()

const SWORD = preload("res://src/Sword.tscn")
#position은 나중에 스킬 나갈때 쓰는 위치 

func _ready() -> void:
	emit_signal("set_hp_and_ep", health, ep)

func _physics_process(delta):
	motion.y += GRAVITY
	# 공격모션이 중간에 끊기지 않게 하기위해 
	if attacking == false:
		if Input.is_action_pressed("ui_right"):
			motion.x += SPEED
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1 
		
		elif Input.is_action_pressed("ui_left"):
			motion.x -= SPEED
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
		
	if motion.x > MAX_SPEED:
		motion.x = MAX_SPEED
	if motion.x < -MAX_SPEED:
		motion.x = -MAX_SPEED
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			motion.y -= JUMP_HEIGHT

			
	if attack_delay == false:
		if Input.is_action_just_pressed("attack"):
			set_skill("attack")
	
		if Input.is_action_just_pressed("skill"):
			set_skill("slash")
		
	motion = move_and_slide(motion, Vector2.UP)

func set_skill(skill_type: String) ->void:
	var skill_instance
	var damage
	var direction = get_skill_direction()
	var player_stats = {}
	
	if check_possible_skill_ep(skill_type):
		if skill_type == "attack":
			skill_instance = SWORD.instance()
			player_stats = {
				"min_attack" : 200,
				"max_attack" : 500,
				"crit" : 100, 
				"crit_damage" : 2
			}
			
		elif skill_type == "slash":
			skill_instance = SWORD.instance()
			player_stats = {
				"min_attack" : 100,
				"max_attack" : 400,
				"crit" : 20, 
				"crit_damage" : 2
			}
	else:
		return
	
	#skill_instance.set_direction(1)
	attacking = true
	attack_delay = true
	$AnimatedSprite.play(skill_type)
	skill_instance.set_damage(player_stats)
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
		if ep - attack_ep >= 0:
			ep -= attack_ep
			emit_signal("change_ep", attack_ep)
			return true
		else:
			return false
	elif skill_type == "slash":
		if ep - slash_ep >= 0:
			ep -= slash_ep
			emit_signal("change_ep", slash_ep)
			return true
		else:
			return false
	else:
		return false

func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "attack" or $AnimatedSprite.animation == "slash":
		$AnimatedSprite.stop()
		attacking = false


func _on_SkillDelay_timeout() -> void:
	attack_delay = false
