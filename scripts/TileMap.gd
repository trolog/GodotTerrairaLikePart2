extends TileMap

export(int) var max_x = 200
export(int) var max_y = 200

var noise : OpenSimplexNoise = OpenSimplexNoise.new()

var snap_size_x  = 8
var snap_size_y = 8

var debug : bool = false

onready var selector : Sprite = $selector

func _ready() -> void:

	randomize()
	
	noise.seed = randi()
	noise.octaves = 0
	noise.period = 5
	noise.persistence = 0.588
	noise.lacunarity = 2.43
	
	generate_level()
	
func generate_level():
	for x in max_x:
		for y in max_y:
			var tile_id = generate_id(noise.get_noise_2d(x,y))
			if(tile_id != -1):
				set_cell(x,y,tile_id)

func generate_id(noise_level : float):
	if(noise_level <= -0.3):
		return -1
	else:
		return 0
		
func _physics_process(_delta: float) -> void:
	if(Input.is_action_just_pressed("debug")):
		debug = !debug
		$selector.visible = debug # show depending if we're debugging or not
		
	if(!debug) : return
	
	if(Input.is_action_just_pressed("mb_left")):
		var tile : Vector2 = world_to_map(selector.mouse_pos * 8) # gets the tile we clicked on
		var tile_id = get_cellv(tile) # returns the ID of that cell
		
		var new_id = -1
		
		if(tile_id != -1): # we clicked on a mud block
			if(tile_id < 5): # we can increase the mud block
				new_id = (tile_id +1)
			else:
				new_id = -1
			set_cellv(tile,new_id)
	
	if(Input.is_action_just_pressed("mb_right")):
		var tile : Vector2 = world_to_map(selector.mouse_pos * 8)
		set_cellv(tile,0)
		
	
