extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

const ENEMY = preload("res://src/Enemy.tscn")
const MAX_ENEMY = 3
#const Player = preload("res://src/Player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var player = Player.instance()
	#player.position.x = $PlayerSpawnPosition.global_position.x
	#player.position.y = $PlayerSpawnPosition.global_position.y
	#print(player.position)
	#print(player)
	#get_parent().add_child(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func get_current_alive_enemies():
	return get_tree().get_nodes_in_group("enemies").size()

# 특정 시간이 지나면 몬스터를 소환한다 하지만 MAX_ENEMY를 넘기면 소환하지 않는다. 
func _on_EnemySpawn_timeout() -> void:	
	if get_current_alive_enemies() >= 3:
		return
	var enemy = ENEMY.instance()
	enemy.position.y = $EnemySpawnPosition.global_position.y
	enemy.position.x = rand_range($EnemySpawnPosition.global_position.x - 500, $EnemySpawnPosition.global_position.x + 200)
	#enemy.position = $EnemySpawnPosition.global_position
	get_tree().call_group("enemies", "connect", enemy)
	get_parent().add_child(enemy)


func magic():
	get_tree().call_group("enemies", "queue_free")
