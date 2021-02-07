extends KinematicBody2D


const GRAVITY = 9.8

const COIN = preload("res://src/Coin.tscn")
const DAMAGE_SKIN = preload("res://src/Damage.tscn")
const LEFT = -1
const RIGHT = 1


var motion = Vector2()
var direction = LEFT

var state = {
	"orange_mushroom" : {
		"name" : "orange_mushroom",
		"attack" : 30,
		"max_hp" : 100000,
		"current_hp" : 100000,
		"booty" : {
			"coin" : 100,
		},
		"def" : 100,
		"speed" : 50,
		"max_speed" : 200,
	},
	"slime" : {
		"name" : "slime",
		"attack" : 30,
		"max_hp" : 100000,
		"current_hp" : 100000,
		"booty" : {
			"coin" : 100,
		},
		"def" : 100,
		"speed" : 50,
		"max_speed" : 200,
	}
}
# CoinPosition은 몬스터가 죽었을 때 코인이 나타날 위치이다. 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemyHealthBar.set_health(state["orange_mushroom"]["max_hp"])
	$AnimatedSprite.play("walk")

func _physics_process(delta: float) -> void:
	motion.y += GRAVITY
	motion.x = direction *state["orange_mushroom"]["speed"]
	
	motion = move_and_slide(motion, Vector2.UP)

func attack():
	return state["orange_mushroom"]["attack"]

func take_damage(damage, crit, index):
	state["orange_mushroom"]["current_hp"] -= damage
	var damage_skin = DAMAGE_SKIN.instance()
	damage_skin.rect_position = $DamagePosition.position
	damage_skin.rect_position.y = $DamagePosition.position.y * index
	add_child(damage_skin)
	damage_skin.show_value(damage, crit)
	if state["orange_mushroom"]["current_hp"] <= 0:
		$EnemyHealthBar.take_damage(damage)
		$AnimatedSprite.play("dead")
	else:
		$EnemyHealthBar.take_damage(damage)
		$AnimatedSprite.play("hit")

# when monster dead
func enemy_dead():
	give_coin()
	queue_free()

func give_coin():
	var coin = COIN.instance()
	coin.set_value(state["orange_mushroom"]["booty"]["coin"])
	get_tree().call_group("coin", "connect", coin)
	coin.position = $CoinPosition.global_position
	get_parent().add_child(coin)

func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "hit":
		$AnimatedSprite.stop()
		$AnimatedSprite.play("walk")
		
	elif $AnimatedSprite.animation == "dead":
		enemy_dead()


# 좌우 움직임에 대해 타이머를 측정한다. 2.5 동안 왼쪽으로 이동후 timeout 시그널이 울리면 오른쪽으로 이동한다. 
func _on_MovmentTimer_timeout() -> void:
	if direction == LEFT:
		$AnimatedSprite.flip_h = true
		direction = RIGHT
	else:
		$AnimatedSprite.flip_h = false
		direction = LEFT
	$AnimatedSprite.play("walk")


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
