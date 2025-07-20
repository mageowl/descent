class_name ModifierArray

var array: Array[Modifier] = []
var mod_points: Dictionary = {}
var mod_target: Object

func _get(property):
	if mod_points.has(property):
		return mod_points[property]

func _init(object: Object, modified_methods: Array):
	mod_target = object
	
	for method in modified_methods:
		mod_points[method] = ModPoint.new(mod_target, method)

func apply(modifier: Modifier):
	modifier.target = mod_target
	array.push_back(modifier)
	
	for mod_point in mod_points.values():
		if modifier.has_method(mod_point.name):
			mod_point.trigger.connect(modifier[mod_point.name])

class ModPoint:
	signal trigger(args: Dictionary)
	
	var mod_target
	var name
	
	func _init(object: Object, method: String):
		mod_target = object
		name = method
	
	func modify(args: Dictionary):
		var dict = args.duplicate(false)
		
		trigger.emit(dict)
		return dict

