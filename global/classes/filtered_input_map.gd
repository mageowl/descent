class_name FilteredInputMap extends Node

@export var controller: int = -1

var prefix = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if controller > -1:
		prefix = "p%d_" % controller
	
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("ui_"): continue
		
		var events = InputMap.action_get_events(action)
		var action_name = prefix + action
		InputMap.add_action(action_name)
		
		for event in events:
			var filtered_event: InputEvent = event.duplicate()
			event.set_device(controller)
			InputMap.action_add_event(action_name, filtered_event)


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
