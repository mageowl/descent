class_name PlatformerLevel2D extends TileMap

@export var nav_layer = 0
var nav_data = {
	"points": [],
	"connections": [],
	"ledges": { "l": [], "r": [] }
}

func sort_ltr(a: Vector2i, b: Vector2i):
	return b.x > a.x or (a.x == b.x && b.y < a.y)

func _enter_tree():
	set_layer_modulate(0, Color.TRANSPARENT)
	var cells = get_used_cells(nav_layer)
	cells.sort_custom(sort_ltr)

	for cell in cells:
		var tile: TileData = get_cell_tile_data(nav_layer, cell)
		var tile_points = []
		var tile_ledges = {"l": [], "r": []}
		var tile_connection = null

		match (tile.get_custom_data("navigation")):
			1:
				tile_points.append(Vector2i(0, 0))
				tile_connection = Vector2i(1, 0)
			2:
				tile_points.append(Vector2i(0, 0))
				tile_points.append(Vector2i(1, 0))
				tile_ledges.r.append(Vector2i(1, 0))
				tile_connection = Vector2i(1, 0)
			3:
				tile_points.append(Vector2i(0, 1))
				tile_connection = Vector2i(1, 0)
			4:
				tile_points.append(Vector2i(0, 0))
			5:
				tile_connection = Vector2i(0, 1)
			6:
				tile_points.append(Vector2i(0, 0))
				tile_ledges.l.append(Vector2i(0, 0))
				tile_connection = Vector2i(1, 0)
			7:
				tile_points.append(Vector2i(0, 0))
				tile_connection = Vector2i(1, 1)
		
		if tile_connection != null:
			nav_data.connections.append([nav_data.points.size(), Vector2((tile_connection + cell) * tile_set.tile_size)])
		nav_data.points.append_array(tile_points.map(func (pt): return Vector2((cell + pt) * tile_set.tile_size)))
		nav_data.ledges.l.append_array(tile_ledges.l.map(func (pt): return Vector2((cell + pt) * tile_set.tile_size)))
		nav_data.ledges.r.append_array(tile_ledges.r.map(func (pt): return Vector2((cell + pt) * tile_set.tile_size)))

func _draw():
	for line in nav_data.connections:
		if (nav_data.points.size() > line[0] + 1): draw_line(nav_data.points[line[0]], line[1], Color.WHITE, 1)
	
	for point in nav_data.points:
		draw_circle(point, 1, Color.RED)

func query_agent(astar: AStar2D, query: PlatformerAgentQuery2D):
	var index = 0
	for point in nav_data.points:
		astar.add_point(index, point)
		index += 1
	
	for connection in nav_data.connections:
		astar.connect_points(connection[0], astar.get_closest_point(connection[1]))
	
	for ledge in nav_data.ledges.r:
		astar_ledge(tile_set.tile_size.x, ledge, query, astar)
	for ledge in nav_data.ledges.l:
		astar_ledge(-tile_set.tile_size.x, ledge, query, astar)

func astar_ledge(offset: float, ledge: Vector2, query: PlatformerAgentQuery2D, astar: AStar2D):
	var drop = ledge + Vector2(offset, 0)
	var raycast = PhysicsRayQueryParameters2D.create(drop, drop + Vector2(0, query.max_fall), 0b0001_0000)
	raycast.hit_from_inside = true
	var collision = get_world_2d().direct_space_state.intersect_ray(raycast)
	
	if collision:
		astar.connect_points(astar.get_closest_point(ledge), astar.get_closest_point(collision.position), false)
