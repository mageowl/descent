class_name World extends TileMap

const POOL_LEFT = preload("res://scenes/world/rooms/pool/left.tres")
const POOL_RIGHT = preload("res://scenes/world/rooms/pool/right.tres")
const POOL_UP = preload("res://scenes/world/rooms/pool/up.tres")
const POOL_DOWN = preload("res://scenes/world/rooms/pool/down.tres")

const POOL_DEAD_LEFT = preload("res://scenes/world/rooms/pool/deadend_left.tres")
const POOL_DEAD_RIGHT = preload("res://scenes/world/rooms/pool/deadend_right.tres")
const POOL_DEAD_UP = preload("res://scenes/world/rooms/pool/deadend_up.tres")
const POOL_DEAD_DOWN = preload("res://scenes/world/rooms/pool/deadend_down.tres")

enum RoomConnection {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	ABS,
}

static var CONNECTION_ID = {
	RoomConnection.LEFT: Vector2i(15, 2),
	RoomConnection.RIGHT: Vector2i(15, 3),
	RoomConnection.UP: Vector2i(16, 1),
	RoomConnection.DOWN: Vector2i(15, 1),
}

static var CONNECTION_OPPOSITE = {
	RoomConnection.LEFT: RoomConnection.RIGHT,
	RoomConnection.RIGHT: RoomConnection.LEFT,
	RoomConnection.UP: RoomConnection.DOWN,
	RoomConnection.DOWN: RoomConnection.UP,
}

static var CONNECTION_OFFSET = {
	RoomConnection.LEFT: Vector2i(-1, 0),
	RoomConnection.RIGHT: Vector2i(1, 0),
	RoomConnection.UP: Vector2i(0, -1),
	RoomConnection.DOWN: Vector2i(0, 1),
	RoomConnection.ABS: Vector2i.ZERO
}

enum TileType {
	CORNER_TOPLEFT,
	SIDE_TOP,
	CORNER_TOPRIGHT,
	SIDE_RIGHT,
	CORNER_BOTTOMRIGHT,
	SIDE_BOTTOM,
	CORNER_BOTTOMLEFT,
	SIDE_LEFT,
	CENTER,
	CORNER_LEFTTOP,
	CORNER_RIGHTTOP,
	CORNER_RIGHTBOTTOM,
	CORNER_LEFTBOTTOM,
	THRUST_LEFTTOP,
	THRUST_RIGHTTOP,
	CORNER_LEFTTOP_RIGHTBOTTOM,
	CORNER_RIGHTTOP_LEFTBOTTOM,
	LIGHT,
	PLATFORM_VERT_TOP,
	PLATFORM_VERT,
	PLATFORM_VERT_BOTTOM,
	PLATFORM_HORZ_LEFT,
	PLATFORM_HORZ,
	PLATFORM_HORZ_RIGHT,
	PLATFORM_SINGLE,
	DBL_THRUST_BOTTOMRIGHT,
	DBL_THRUST_BOTTOMLEFT,
	DBL_THRUST_TOPRIGHT,
	DBL_THRUST_TOPLEFT,
	SLOPE_TOPLEFT_1,
	SLOPE_TOPLEFT_2,
	SLOPE_TOPLEFT_3,
	SLOPE_TOPRIGHT_1,
	SLOPE_TOPRIGHT_2,
	SLOPE_TOPRIGHT_3,
	SLOPE_BOTTOMRIGHT_1,
	SLOPE_BOTTOMRIGHT_2,
	SLOPE_BOTTOMRIGHT_3,
	SLOPE_BOTTOMLEFT_1,
	SLOPE_BOTTOMLEFT_2,
	SLOPE_BOTTOMLEFT_3,
	PLATFORM_CORNER_TOPLEFT,
	PLATFORM_TRIPLE_TOP,
	PLATFORM_CORNER_TOPRIGHT,
	PLATFORM_TRIPLE_RIGHT,
	PLATFORM_CORNER_BOTTOMRIGHT,
	PLATFORM_TRIPLE_BOTTOM,
	PLATFORM_CORNER_BOTTOMLEFT,
	PLATFORM_TRIPLE_LEFT,
	PLATFORM_CENTER,
}

static var BLOCK_TILES = {
	Vector2i(1, 2): TileType.CORNER_TOPLEFT,
	Vector2i(2, 2): TileType.SIDE_TOP,
	Vector2i(4, 2): TileType.CORNER_TOPRIGHT,
	Vector2i(4, 3): TileType.SIDE_RIGHT,
	Vector2i(4, 5): TileType.CORNER_BOTTOMRIGHT,
	Vector2i(3, 5): TileType.SIDE_BOTTOM,
	Vector2i(2, 5): TileType.CORNER_BOTTOMLEFT,
	Vector2i(2, 4): TileType.SIDE_LEFT,
	Vector2i(3, 3): TileType.CENTER,
	Vector2i(8, 0): TileType.CORNER_LEFTTOP,
	Vector2i(13, 0): TileType.CORNER_RIGHTTOP,
	Vector2i(13, 2): TileType.CORNER_RIGHTBOTTOM,
	Vector2i(9, 4): TileType.CORNER_LEFTBOTTOM,
	Vector2i(12, 2): TileType.THRUST_LEFTTOP,
	Vector2i(1, 16): TileType.THRUST_RIGHTTOP,
	Vector2i(17, 4): TileType.CORNER_LEFTTOP_RIGHTBOTTOM,
	Vector2i(21, 4): TileType.CORNER_RIGHTTOP_LEFTBOTTOM,
	Vector2i(19, 6): TileType.LIGHT,
	Vector2i(5, 9): TileType.PLATFORM_VERT_TOP,
	Vector2i(5, 10): TileType.PLATFORM_VERT,
	Vector2i(5, 11): TileType.PLATFORM_VERT_BOTTOM,
	Vector2i(1, 12): TileType.PLATFORM_HORZ_LEFT,
	Vector2i(2, 12): TileType.PLATFORM_HORZ,
	Vector2i(4, 12): TileType.PLATFORM_HORZ_RIGHT,
	Vector2i(3, 10): TileType.PLATFORM_SINGLE,
	Vector2i(10, 10): TileType.DBL_THRUST_BOTTOMRIGHT,
	Vector2i(12, 10): TileType.DBL_THRUST_BOTTOMLEFT,
	Vector2i(12, 18): TileType.DBL_THRUST_TOPRIGHT,
	Vector2i(9, 18): TileType.DBL_THRUST_TOPLEFT,
	Vector2i(17, 9): TileType.SLOPE_TOPLEFT_1,
	Vector2i(17, 10): TileType.SLOPE_TOPLEFT_2,
	Vector2i(16, 10): TileType.SLOPE_TOPLEFT_3,
	Vector2i(19, 9): TileType.SLOPE_TOPRIGHT_1,
	Vector2i(19, 10): TileType.SLOPE_TOPRIGHT_2,
	Vector2i(20, 10): TileType.SLOPE_TOPRIGHT_3,
	Vector2i(20, 12): TileType.SLOPE_BOTTOMRIGHT_1,
	Vector2i(19, 12): TileType.SLOPE_BOTTOMRIGHT_2,
	Vector2i(19, 13): TileType.SLOPE_BOTTOMRIGHT_3,
	Vector2i(16, 12): TileType.SLOPE_BOTTOMLEFT_1,
	Vector2i(17, 12): TileType.SLOPE_BOTTOMLEFT_2,
	Vector2i(17, 13): TileType.SLOPE_BOTTOMLEFT_3,
	Vector2i(16, 16): TileType.PLATFORM_CORNER_TOPLEFT,
	Vector2i(18, 16): TileType.PLATFORM_TRIPLE_TOP,
	Vector2i(20, 16): TileType.PLATFORM_CORNER_TOPRIGHT,
	Vector2i(16, 18): TileType.PLATFORM_TRIPLE_RIGHT,
	Vector2i(18, 18): TileType.PLATFORM_CORNER_BOTTOMRIGHT,
	Vector2i(20, 18): TileType.PLATFORM_TRIPLE_BOTTOM,
	Vector2i(16, 20): TileType.PLATFORM_CORNER_BOTTOMLEFT,
	Vector2i(18, 20): TileType.PLATFORM_TRIPLE_LEFT,
	Vector2i(20, 20): TileType.PLATFORM_CENTER,
}

## Sets the template used for world generation.
@export var template: WorldTemplate
var modifiers: Array[WorldModifier] = []

var max_depth: int
var covered_area: Array[Rect2i] = []

func _ready():
	max_depth = WorldGeneration.rng.randi_range(template.length_min, template.length_max)
	
	place_room(Vector2i.ZERO, RoomConnection.ABS, 0, template.start_room)
	
	for cell in get_used_cells(0):
		var atlas = get_cell_atlas_coords(0, cell)
		
		match template.tileset:
			1:
				atlas = get_tile_bricks(BLOCK_TILES[atlas])
		
		set_cell(1, cell, template.tileset, atlas)

func place_room(room_position: Vector2i, direction: RoomConnection, depth: int, room: PackedScene = null):
	if room == null:
		room = get_room(direction)
	if depth >= max_depth:
		room = get_deadend(direction)
	
	var instance: TileMap
	var pos: Vector2i
	var connection_offset: Vector2i
	
	for i in range(12):
		instance = room.instantiate()
		
		connection_offset = Vector2i(instance.get_used_cells_by_id(1, 0, CONNECTION_ID[CONNECTION_OPPOSITE[direction]]).pick_random()) \
			if direction != RoomConnection.ABS else Vector2i.ZERO
		pos = room_position - connection_offset + CONNECTION_OFFSET[direction]
		
		var rect = instance.get_used_rect()
		var can_fit = true
		rect.position = pos
		
		for cover in covered_area:
			if rect.intersects(cover):
				can_fit = false
				break
		
		if can_fit:
			covered_area.append(rect)
			break
		elif i == 10:
			room = get_deadend(direction)
	
	var pattern: TileMapPattern = instance.get_pattern(0, instance.get_used_cells(0))
	set_pattern(0, pos, pattern)
	
	for connection in instance.get_used_cells_by_id(1, 0, CONNECTION_ID[RoomConnection.RIGHT]):
		if connection == connection_offset: continue
		place_room(pos + connection, RoomConnection.RIGHT, depth + 1)
	for connection in instance.get_used_cells_by_id(1, 0, CONNECTION_ID[RoomConnection.LEFT]):
		if connection == connection_offset: continue
		place_room(pos + connection, RoomConnection.LEFT, depth + 1)
	for connection in instance.get_used_cells_by_id(1, 0, CONNECTION_ID[RoomConnection.UP]):
		if connection == connection_offset: continue
		place_room(pos + connection, RoomConnection.UP, depth + 1)
	for connection in instance.get_used_cells_by_id(1, 0, CONNECTION_ID[RoomConnection.DOWN]):
		if connection == connection_offset: continue
		place_room(pos + connection, RoomConnection.DOWN, depth + 1)
	
	instance.queue_free()

func get_room(direction: RoomConnection) -> PackedScene:
	match direction:
		RoomConnection.LEFT:
			return POOL_LEFT.pick_random()
		RoomConnection.RIGHT:
			return POOL_RIGHT.pick_random()
		RoomConnection.UP:
			return POOL_UP.pick_random()
		RoomConnection.DOWN:
			return POOL_DOWN.pick_random()
		_:
			return null

func get_deadend(direction: RoomConnection) -> PackedScene:
	match direction:
		RoomConnection.LEFT:
			return POOL_DEAD_LEFT.pick_random()
		RoomConnection.RIGHT:
			return POOL_DEAD_RIGHT.pick_random()
		RoomConnection.UP:
			return POOL_DEAD_UP.pick_random()
		RoomConnection.DOWN:
			return POOL_DEAD_DOWN.pick_random()
		_:
			print("hey")
			return null

func get_tile_bricks(tile: TileType) -> Vector2i:
	pass
	#match tile:
		#TileType.CORNER_TOPLEFT
		#TileType.SIDE_TOP
		#TileType.CORNER_TOPRIGHT
		#TileType.SIDE_RIGHT
		#TileType.CORNER_BOTTOMRIGHT
		#TileType.SIDE_BOTTOM
		#TileType.CORNER_BOTTOMLEFT
		#TileType.SIDE_LEFT
		#TileType.CENTER
		#TileType.CORNER_LEFTTOP
		#TileType.CORNER_RIGHTTOP
		#TileType.CORNER_RIGHTBOTTOM
		#TileType.CORNER_LEFTBOTTOM
		#TileType.THRUST_LEFTTOP
		#TileType.THRUST_RIGHTTOP
		#TileType.CORNER_LEFTTOP_RIGHTBOTTOM
		#TileType.CORNER_RIGHTTOP_LEFTBOTTOM
		#TileType.LIGHT
		#TileType.PLATFORM_VERT_TOP
		#TileType.PLATFORM_VERT
		#TileType.PLATFORM_VERT_BOTTOM
		#TileType.PLATFORM_HORZ_LEFT
		#TileType.PLATFORM_HORZ
		#TileType.PLATFORM_HORZ_RIGHT
		#TileType.PLATFORM_SINGLE
		#TileType.DBL_THRUST_BOTTOMRIGHT
		#TileType.DBL_THRUST_BOTTOMLEFT
		#TileType.DBL_THRUST_TOPRIGHT
		#TileType.DBL_THRUST_TOPLEFT
		#TileType.SLOPE_TOPLEFT_1
		#TileType.SLOPE_TOPLEFT_2
		#TileType.SLOPE_TOPLEFT_3
		#TileType.SLOPE_TOPRIGHT_1
		#TileType.SLOPE_TOPRIGHT_2
		#TileType.SLOPE_TOPRIGHT_3
		#TileType.SLOPE_BOTTOMRIGHT_1
		#TileType.SLOPE_BOTTOMRIGHT_2
		#TileType.SLOPE_BOTTOMRIGHT_3
		#TileType.SLOPE_BOTTOMLEFT_1
		#TileType.SLOPE_BOTTOMLEFT_2
		#TileType.SLOPE_BOTTOMLEFT_3
		#TileType.PLATFORM_CORNER_TOPLEFT
		#TileType.PLATFORM_TRIPLE_TOP
		#TileType.PLATFORM_CORNER_TOPRIGHT
		#TileType.PLATFORM_TRIPLE_RIGHT
		#TileType.PLATFORM_CORNER_BOTTOMRIGHT
		#TileType.PLATFORM_TRIPLE_BOTTOM
		#TileType.PLATFORM_CORNER_BOTTOMLEFT
		#TileType.PLATFORM_TRIPLE_LEFT
		#TileType.PLATFORM_CENTER
