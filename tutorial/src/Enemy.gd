extends KinematicBody2D

export var hp = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite.play("walk")
	#pass # Replace with function body.


func take_damage(damage):
	hp -= damage
	if hp <= 0:
		$AnimatedSprite.play("dead")
	else:
		$AnimatedSprite.play("hit")


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "dead" or $AnimatedSprite.animation == "hit":
		$AnimatedSprite.stop()
		$AnimatedSprite.play("walk")

