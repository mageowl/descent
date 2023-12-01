class_name PathfindingEnemy extends Enemy

@onready var tilemap: PlatformerLevel2D = find_parent("Room*")
var astar = AStar2D.new()
var path = []
var target_position: Vector2

func pathfind_to(location: Vector2):
	if astar.has_point(0):
		var from = astar.get_closest_point(global_position)
		var to = astar.get_closest_point(location)
		path = Array(astar.get_point_path(from, to))
