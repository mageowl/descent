class_name PlatformerEnemy extends PathfindingEnemy

@export_group("Speed")
@export var speed = 100.0
@export var acceleration = 0.1
@export var friction = 0.7
@export var air_friction = 0.1

@export_group("Gravity")
@export var jump_velocity = 200.0
@export var gravity = 1000.0
@export var jump_gravity = 900.0

func _ready():
	await get_tree().create_timer(0.2).timeout
	tilemap.query_agent(astar, PlatformerAgentQuery2D.create(Vector2.ZERO))

func _get_direction() -> int:
	return 0

func movement(delta: float, direction: int):
	pass

func _physics_process(delta):
	var direction = _get_direction()
	movement(delta, direction)
