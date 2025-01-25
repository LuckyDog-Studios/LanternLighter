extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $DarknAnimatedSprite
@onready var animated_sprite_2d_lit: AnimatedSprite2D = $LitAnimatedSprite

const SPEED = 500
const ACCELERATION = 8.0

var inputDir: Vector2

func get_input():
	inputDir.x =  Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	inputDir.y =  Input.get_action_strength("DOWN") - Input.get_action_strength("UP")
	return inputDir.normalized()
	
func _process(delta: float) -> void:
	var player_input = get_input()
	animate(player_input)
	velocity = lerp(velocity, player_input * SPEED, delta * ACCELERATION)
	move_and_slide()

func animate(player_input: Vector2):
	if player_input == Vector2.ZERO:
		animated_sprite_2d.play("idle")
		animated_sprite_2d_lit.play("idle")
	if animated_sprite_2d.animation == "idle":
		animated_sprite_2d_lit.frame = animated_sprite_2d.frame
