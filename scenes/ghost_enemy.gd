extends Node2D

var SPEED = 100
@onready var character: CharacterBody2D = $"../Character"

func _process(delta: float) -> void:
	if character:
		global_position = global_position.lerp(character.global_position, delta)
	
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("exitied screen")
	queue_free()
