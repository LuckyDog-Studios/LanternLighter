extends TileMap

@onready var character: CharacterBody2D = $"../Character"
@onready var character_animated_sprite = $"../Character/DarknAnimatedSprite"
@onready var character_animated_sprite_lit = $"../Character/LitAnimatedSprite"
var material_cache: Dictionary = {}  # Cache to store materials for tiles
const character_offset = Vector2(54, 37)

func _process(delta: float) -> void:
	# Convert the character's global position from world coordinates to screen coordinates
	var light_position_screen = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * character.global_position
	var viewport_size = get_viewport().get_visible_rect().size
	# Update the shader parameter for all cached materials
	for tile_key in material_cache.keys():
		var material = material_cache[tile_key]
		#testing...
		if material.get_shader_parameter("light_radius") <= 10:
			character_animated_sprite_lit.visible = false
		else:
			character_animated_sprite_lit.visible = true

		#for shader
		if material:
			material.set_shader_parameter("light_position", light_position_screen - character_offset)
			material.set_shader_parameter("viewport_size", viewport_size)
			material.set_shader_parameter("aspect_ratio", viewport_size.x/viewport_size.y)
			#testing
			material.set_shader_parameter("light_radius", material.get_shader_parameter("light_radius") - (60*delta))

	


func _ready() -> void:
	notify_runtime_tile_data_update()
	
	#add character dark sprite to the list
	var tile_key = "character_animated_sprite"
	if not material_cache.has(tile_key):
		var new_mat = ShaderMaterial.new()
		new_mat.shader = load("res://scripts/game.gdshader")
		new_mat.set_shader_parameter("softness", 1)
		new_mat.set_shader_parameter("light_radius",500)
		material_cache[tile_key] = new_mat
		
	character_animated_sprite.material = material_cache[tile_key]

func _tile_data_runtime_update(layer: int, coords: Vector2i, tile_data: TileData) -> void:
	# Create a unique key for the tile using its coordinates
	var tile_key = str(layer) + "_" + str(coords)
	
	
	# Check if a material is already cached for this tile
	if not material_cache.has(tile_key):
		var new_mat = ShaderMaterial.new()
		new_mat.shader = load("res://scripts/game.gdshader")
		new_mat.set_shader_parameter("softness", 1)
		new_mat.set_shader_parameter("light_radius",500)
		material_cache[tile_key] = new_mat
		
	
	#CACHE MATERIAL
	tile_data.material = material_cache[tile_key]

func _use_tile_data_runtime_update(layer: int, coords: Vector2i) -> bool:
	var tile_data = self.get_cell_tile_data(layer, coords)

	# Only update tiles that have no material set
	if tile_data and tile_data.material == null and layer == 0:
		return true
	return false
