class_name FilteredInputMap extends Node

@export var controller: int = -1 : 
	set(v):
		controller = v
		if v > -1:
			prefix = "p%d_" % controller

var prefix = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if controller > -1:
		prefix = "p%d_" % controller
	
	if not InputController.existing_filters.has(prefix):
		prefix = ""
		print("Could not create Filtered Input Map with prefix '%s'." % prefix)

func is_action_pressed(action: StringName):
	return Input.is_action_pressed(prefix + action)

func is_action_just_pressed(action: StringName):
	return Input.is_action_just_pressed(prefix + action)

func is_action_just_released(action: StringName):
	return Input.is_action_just_released(prefix + action)

func get_axis(negitive_action: StringName, positive_action: StringName):
	return Input.get_axis(prefix + negitive_action, prefix + positive_action)

func get_vector(negitive_x: StringName, positive_x: StringName, negitive_y: StringName, positive_y: StringName):
	return Input.get_vector(prefix + negitive_x, prefix + positive_x, prefix + negitive_y, prefix + positive_y)
