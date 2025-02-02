class_name GhostEnemy
extends Node2D

var SPEED = 150
var HEALTH = 25
@onready var character: CharacterBody2D = $"../Character"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if character:
		global_position = global_position.move_toward(character.global_position, delta*SPEED)
	

func take_damage(amount: int) -> void:
	HEALTH -= amount
	
	animation_player.play("hit")
	
	if HEALTH <= 0:
		queue_free()
	
	
