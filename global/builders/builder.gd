@tool
class_name SceneBuilder extends Node

var steps: Array[Callable] = []
var data: Dictionary = {}
var index: int = -1
var current_step: Node

func _on_finished():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	print("now building")
	next_step()

func next_step():
	print("running next step")
	index += 1

	if current_step != null:
		current_step.set_meta("_edit_lock_", true)
		var step_name = Array(current_step.name.split(" ").slice(1)).reduce(Util.join("_")).to_lower()
		data[step_name] = current_step
	
	if index >= steps.size(): 
		_on_finished()
		return
	
	var step = steps[index]
	current_step = step.call()
	print(step)

func step_texture(step_name: String):
	return func() -> Sprite2D:
		var sprite = Sprite2D.new()
		sprite.name = str(index + 1) + " " + step_name
		sprite.texture_changed.connect(next_step, CONNECT_ONE_SHOT)
		
		add_child(sprite)
		sprite.owner = self
		return sprite

func step_polygon(step_name: String, color: Color):
	return func() -> Polygon2D:
		var polygon = StepPolygon.new()
		polygon.name = str(index + 1) + " " + step_name
		polygon.color = color
		polygon.changed.connect(next_step, CONNECT_ONE_SHOT)
		
		add_child(polygon)
		polygon.owner = self
		return polygon

func step_value(step_name: String, default, enum_array: Array[String] = []):
	return func() -> Node:
		var input = StepValue.new(default, enum_array)
		input.name = str(index + 1) + " " + step_name
		input.changed.connect(next_step, CONNECT_ONE_SHOT)

		add_child(input)
		input.owner = self
		return input

class StepPolygon extends Polygon2D:
	signal changed
	
	@export var done = false :
		set(_v):
			changed.emit()

class StepValue extends Node:
	signal changed
	
	var default_set = false
	var value :
		set(_v):
			value = _v
			
			if default_set:
				await get_tree().create_timer(0.5).timeout
				if value == _v:
					changed.emit()
			else:
				default_set = true
	var type: int
	var enum_array: Array[String]
	
	func _init(default_value, input_enum: Array[String] = []):
		print(default_value)
		type = typeof(default_value)
		enum_array = input_enum
		value = default_value
	
	func _get_property_list():
		return [{
			"name": "value",
			"type": type,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM if not enum_array.is_empty() else PROPERTY_HINT_NONE,
			"hint_string": enum_array.reduce(Util.join(","))
		}]
