class_name Enemy extends Entity

@export var follow_range: int = 100
var target: Player = null

func create_unique_resource(obj: Object, path: String):
	obj[path] = obj[path].duplicate(true)

func has_los_to(v: Vector2):
	var ray_query = PhysicsRayQueryParameters2D.create(position, v, 0b0000_0001)
	var collision = get_world_2d().direct_space_state.intersect_ray(ray_query)
	
	return not collision
