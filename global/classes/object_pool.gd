class_name ObjectPool extends Node

var object: PackedScene
@export var pool_size: int = 20

func set_owners(parent, target = parent):
	for c in parent.get_children():
		c.owner = target
		if c.get_child_count() > 0: set_owners(c, target)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(get_child_count() == 1, "ObjectPool must have exactly one child.")
	var child = get_child(0)
	set_owners(child)
	
	object = PackedScene.new()
	object.pack(child)
	child.queue_free()
	
	for i in pool_size:
		var instance: Node = object.instantiate()
		
		instance.process_mode = PROCESS_MODE_DISABLED
		if instance is Node2D: instance.visible = false
		if instance.has_method("disable"): instance.disable()
		if instance.has_signal("free_instance"): instance.free_instance.connect(free_instance.bind(instance.get_index()))
		if instance.has_method("set_parent"): instance.set_parent(get_parent())
		
		add_child(instance)

func spawn(position: Vector2 = Vector2.INF) -> Node:
	var instance_array = get_children().filter(func(b): return b.process_mode == PROCESS_MODE_DISABLED)
	var instance: Node
	
	if instance_array.size() > 0: instance = instance_array[0]
	else: return null
	
	instance.process_mode = PROCESS_MODE_INHERIT
	if instance is Node2D: 
		instance.visible = true
		if position != Vector2.INF: instance.position = position
	if instance.has_method("enable"): instance.enable()
	
	return instance

func free_instance(index: int) -> void:
	var instance: Node = get_children()[index]
	instance.process_mode = PROCESS_MODE_DISABLED
	if instance is Node2D: instance.visible = false
	if instance.has_method("disable"): instance.disable()

