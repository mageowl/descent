class_name PlatformerAgentQuery2D

var jump_size: Vector2
var max_fall: float

static func create(jump_size: Vector2, max_fall: float = 100):
	var instance = new()
	instance.jump_size = jump_size
	instance.max_fall = max_fall
	return instance
