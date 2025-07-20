extends Node

var existing_filters: Array[String] = [""]
var using_keyboard = false

func _ready():
	add_controller_filter(0)
	add_controller_filter(1)
	add_controller_filter(2)
	add_controller_filter(3)
	
	if Input.get_connected_joypads().size() == 0:
		using_keyboard = true

func add_controller_filter(controller_id):
	var prefix = "p%d_" % controller_id
	existing_filters.append(prefix)
	
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("ui_"): continue
		
		var events = InputMap.action_get_events(action)
		var action_name = prefix + action
		InputMap.add_action(action_name)
		
		for event in events:
			var filtered_event: InputEvent = event.duplicate()
			filtered_event.set_device(controller_id)
			InputMap.action_add_event(action_name, filtered_event)

