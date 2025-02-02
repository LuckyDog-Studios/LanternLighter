extends Node2D

const GHOST_ENEMY = preload("res://scenes/ghost_enemy.tscn")

func _ready() -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var enemy_instance = GHOST_ENEMY.instantiate()
	get_parent().get_parent().add_child(enemy_instance)
	
	enemy_instance.position = $"Spawn Location".global_position
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	$"Spawn Location".position = position
