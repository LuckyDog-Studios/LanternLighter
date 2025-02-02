extends Node2D
@onready var weapon_timer: Timer = $WeaponTimer
const ETHEREAL_ARROW = preload("res://scenes/ethereal_arrow.tscn")
var canFire = true

func _process(delta: float) -> void:
	if canFire and Input.is_action_pressed("ATTACK1"):
		canFire = false
		weapon_timer.start()
		
		var arrow_instance = ETHEREAL_ARROW.instantiate()
		arrow_instance.global_position = global_position
		
		# direction towards mouse
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		arrow_instance.shoot(direction)
		
		get_tree().root.add_child(arrow_instance)

func _on_weapon_timer_timeout() -> void:
	canFire = true
