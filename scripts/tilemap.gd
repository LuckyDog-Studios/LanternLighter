extends TileMap

# for character light stuff
@onready var character: CharacterBody2D = $"../Character"
@onready var character_lantern_glow: PointLight2D = $"../Character/LanternGlow"
@onready var character_animated_sprite_lit = $"../Character/LitAnimatedSprite"

#stores all the materials needed for the darkness shader
var material_cache: Dictionary = {}  # Cache to store materials for tiles


const character_offset = Vector2(40, 25)
const dim_speed = 15
const starting_radius = 450


func _process(delta: float) -> void:
	# Convert the character's global position from world coordinates to screen coordinates
	var light_position_screen =  get_global_transform_with_canvas() * character.global_position
	var viewport_size = get_viewport().get_visible_rect().size
	# Update the shader parameter for all cached materials
	for tile_key in material_cache.keys():
		var material = material_cache[tile_key]

		#for shader
		if material:
			#give the shader neccesary variables to follow player
			material.set_shader_parameter("light_position", light_position_screen - character_offset)
			material.set_shader_parameter("viewport_size", viewport_size)
			material.set_shader_parameter("aspect_ratio", viewport_size.x/viewport_size.y)
			#slowly decrease light strength
			if character_lantern_glow.texture_scale > 0:
				character_lantern_glow.texture_scale -= delta*dim_speed/26700
			var current_radius = material.get_shader_parameter("light_radius") # easier to use
			material.set_shader_parameter("light_radius", max(0, current_radius - delta*dim_speed))
			

	


func _ready() -> void:
	notify_runtime_tile_data_update()
	
	
	# GIVE ALL LAMPOSTS A POINTLIGHT2D
	var used_cells = self.get_used_cells_by_id(1, 1, Vector2i(0,0))
	for cell in used_cells:
		var tile_data = self.get_cell_tile_data(1, cell)
		if tile_data:
			var light = PointLight2D.new()
			light.texture = preload("res://assets/sprites/lightgradiant.tres") # for the circular light
			light.energy = 1
			light.position = self.map_to_local(cell) + Vector2(12, -165)
			light.texture_scale = 8
			add_child(light)
	
	character_lantern_glow.texture_scale = starting_radius/180

func _tile_data_runtime_update(layer: int, coords: Vector2i, tile_data: TileData) -> void:
	# Create a unique key for the tile using its coordinates
	var tile_key = str(layer) + "_" + str(coords)
	
	
	# Check if a material is already cached for this tile
	if not material_cache.has(tile_key):
		var new_mat = ShaderMaterial.new()
		new_mat.shader = load("res://scripts/game.gdshader")
		new_mat.set_shader_parameter("softness", 1)
		new_mat.set_shader_parameter("light_radius",starting_radius)
		material_cache[tile_key] = new_mat
		
	
	#CACHE MATERIAL
	tile_data.material = material_cache[tile_key]

func _use_tile_data_runtime_update(layer: int, coords: Vector2i) -> bool:
	var tile_data = self.get_cell_tile_data(layer, coords)

	# Only update tiles that have no material set
	if tile_data and tile_data.material == null and layer == 0:
		return true
	return false
