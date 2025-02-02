class_name HurtBox
extends Area2D



func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	self.area_entered.connect(self._on_area_entered)

func _on_area_entered(hitbox: HitBox):
	if owner.has_method("take_damage"):
		#prevent attacks from damaging the player
		if owner is Player and not hitbox.damagePlayer:
			return
		# prevent enemies from damaging eachotehr
		elif owner is GhostEnemy and hitbox.damagePlayer:
			return
		owner.take_damage(hitbox.damage)
	if hitbox.deleteOnHit:
		if hitbox.owner.has_method("death_animation"):
			hitbox.owner.death_animation()
		else:
			hitbox.owner.queue_free()
