extends KinematicBody2D

const GRAVITY = 9.8
const SPEED = 10
const MAX_SPEED = 200
const JUMP_HEIGHT = 500
var attacking = false
var attack_delay = false

var motion = Vector2()

const SWORD = preload("res://src/Sword.tscn")

#position은 나중에 스킬 나갈때 쓰는 위치 

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
			
	if Input.is_action_just_pressed("attack") and attack_delay == false:
		attacking = true
		$AnimatedSprite.play("attack")
		var sword = SWORD.instance()
		
		if sign($Position2D.position.x) == 1:
			sword.set_direction(1)
		else:
			sword.set_direction(-1)
		sword.set_damage(10)
		get_parent().add_child(sword)
		sword.position = $Position2D.global_position
		attack_delay = true
		$SkillDelay.start()
	
	if Input.is_action_just_pressed("skill"):
		attacking = true
		$AnimatedSprite.play("skill")
		
	motion = move_and_slide(motion, Vector2.UP)


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "attack" or $AnimatedSprite.animation == "skill":
		$AnimatedSprite.stop()
		attacking = false


func _on_SkillDelay_timeout() -> void:
	attack_delay = false
