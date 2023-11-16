class_name Enemy extends Entity

@export var follow_range: int = 100
var target: Player = null

func has_los_to(v: Vector2):
	if position.distance_to(v) > follow_range: return false
	var ray_query = PhysicsRayQueryParameters2D.create(position, v, 0b0000_0001)
	var collision = get_world_2d().direct_space_state.intersect_ray(ray_query)
	
	return not collision
