extends Node2D

@onready var directional_light_2d: DirectionalLight2D = $DirectionalLight2D
@onready var update_timer: Timer = $UpdateTimer

const day_length = 120
const min_energy = 0.5


func _on_update_timer_timeout() -> void:
	directional_light_2d.energy -= (1.6 - min_energy) /(day_length / update_timer.wait_time) #1.6 is starting energy
	if directional_light_2d.energy <= min_energy:
		update_timer.stop()
