extends Camera2D

@export_node_path var target_container: NodePath
var targets: Array[Node]
var has_targets = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not target_container.is_empty():
		targets = get_node(target_container).get_children()
		has_targets = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if has_targets:
		position = targets.reduce(func (av, target): 
			return av + target.position, Vector2.ZERO) / targets.size()
		position = round(position)
