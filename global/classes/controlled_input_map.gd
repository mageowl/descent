class_name ControlledInputMap extends FilteredInputMap

var actions = {}
var just_pressed = []
var just_released = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func press(action: StringName):
	actions[action] = true
	just_pressed.push_back(action)

func release(action: StringName):
	actions[action] = false
	just_released.push_back(action)

func _physics_process(_delta):
	just_pressed = []
	just_released = []

func is_action_pressed(action: StringName):
	return actions[action] if actions.has(action) else false

func is_action_just_pressed(action: StringName):
	return just_pressed.has(action)

func is_action_just_released(action: StringName):
	return just_released.has(action)

func get_axis(negitive_action: StringName, positive_action: StringName):
	return (actions[positive_action] if actions.has(positive_action) else 0) - (actions[negitive_action] if actions.has(negitive_action) else 0)

func get_vector(negitive_x: StringName, positive_x: StringName, negitive_y: StringName, positive_y: StringName):
	return Vector2.INF
