class_name PathfindingEnemy extends Enemy

@onready var tilemap: PlatformerLevel2D = get_tree().get_nodes_in_group("level")[0]
var astar = AStar2D.new()
var path = []

func _ready():
	await get_tree().create_timer(0.2).timeout
	tilemap.query_agent(astar, PlatformerAgentQuery2D.create(Vector2.ZERO))

func pathfind_to(target: Vector2):
	if astar.has_point(0):
		var from = astar.get_closest_point(global_position)
		var to = astar.get_closest_point(target)
		path = Array(astar.get_point_path(from, to))
