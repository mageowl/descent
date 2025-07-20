class_name PlatformerEnemy extends PathfindingEnemy

@export_group("Pathfinding")
@export var jump_size = Vector2.ZERO
@export var max_fall_distance = 80
@export_node_path("RayCast2D") var short_jump
@onready var short_jump_raycast = get_node(short_jump)

@export_group("Speed")
@export var speed = 100.0
@export var acceleration = 0.1
@export var friction = 0.7
@export var air_friction = 0.1

@export_group("Gravity")
@export var jump_velocity = 200.0
@export var min_jump_velocity = -50.0
@export var min_jump_time: int = 8
@export var gravity = 1000.0
@export var jump_gravity = 900.0

var trigger = {
	"jump": false,
	"direction": 0
}
var jumping = false
var fall_time = 0
var prevent_physics = false

func _ready():
	super()
	await get_tree().create_timer(0.2).timeout
	tilemap.query_agent(astar, PlatformerAgentQuery2D.create(jump_size))

func _get_direction() -> int:
	return 0

func movement(delta: float):
	# Gravity
	if not is_on_floor():
		velocity.y += (gravity if velocity.y >= 0 else jump_gravity) * delta
		fall_time += 1
	else:
		jumping = false
		fall_time = 0
	
	# Jump
	if trigger.jump and is_on_floor():
		velocity.y = -jump_velocity
		jumping = true
	
	if jumping and fall_time > min_jump_time and velocity.y < -min_jump_velocity and short_jump_raycast.is_colliding():
		velocity.y = -min_jump_velocity
		jumping = false
	
	if trigger.direction:
		velocity.x = move_toward(velocity.x, sign(trigger.direction) * speed, acceleration * speed * abs(trigger.direction))
	else:
		velocity.x = move_toward(velocity.x, 0, speed * (friction if is_on_floor() else air_friction))
	
	velocity += knockback_force
	
	move_and_slide()
	trigger.direction = 0
	trigger.jump = false

func _physics_process(delta):
	super(delta)
	if not prevent_physics: movement(delta)
