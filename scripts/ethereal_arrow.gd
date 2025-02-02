extends Node2D

var speed = 1000  # Adjust as needed
var direction = Vector2.ZERO  # Default direction
var attack_player = false
var freeze_movement = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func shoot(new_direction: Vector2):
	direction = new_direction
	rotation = direction.angle() + PI/2 # Rotate arrow towards movement direction

func _process(delta: float) -> void:
	if not freeze_movement:
		position += direction * speed * delta  # Move the arrow
	
func death_animation() -> void:
	freeze_movement = true
	animation_player.play("death")
	await get_tree().create_timer(0.75).timeout
	queue_free()
