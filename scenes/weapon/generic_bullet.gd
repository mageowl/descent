class_name BasicBullet extends Area2D

signal hit_level
signal hit_entity

@export_group("Physics")
@export var speed = 200
@export var bullet_gravity = 0
@export var pierce = 0
@export var bounce = 0
@export var bounce_damping = 0.8
@export_group("Display")
@export var rotateSprite = true
@export_node_path("GPUParticles2D") var hit_particles: NodePath
@export_node_path("GPUParticles2D") var trail_particles: NodePath
@export_group("Entity Collision")
@export var damage = 0
@export var damage_type = DamageSource.TYPE.Physical
var velocity = Vector2.ZERO
var hits = -1
var bounces = -1
var destroyed = false
var damage_source: DamageSource
var hit_particle_node: GPUParticles2D
var trail_particle_node: GPUParticles2D

func destroy():
	if destroyed: return
	else: destroyed = true
	
	if get_parent() is ObjectPool:
		get_parent().call_deferred("free_instance", get_index())
	else:
		queue_free()

func enable():
	destroyed = false
	hits = 0
	bounces = 0
	if trail_particle_node: trail_particle_node.restart()

func set_parent(parent: Node):
	if parent is DamageSource: damage_source = parent

# Called when the node enters the scene tree for the first time.
func _ready():
	hits = pierce
	body_entered.connect(hit_body)
	if !hit_particles.is_empty(): hit_particle_node = get_node(hit_particles)
	if !trail_particles.is_empty(): trail_particle_node = get_node(trail_particles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var query = PhysicsRayQueryParameters2D.create(position, position + speed * velocity * delta)
	query.hit_from_inside = true
	var result = get_world_2d().direct_space_state.intersect_ray(query)

	velocity.y += bullet_gravity * delta
	
	if result:
		hit_body(result.collider, result.normal)
	
	position += speed * velocity * delta
	if rotateSprite: rotation = velocity.angle();

func hit_body(collision_shape: Node2D, normal: Vector2 = Vector2.ZERO):
	if destroyed: return
	
	if collision_shape is TileMap:
		if bounces < bounce and abs(normal.x) <= abs(normal.y):
			velocity.y *= -bounce_damping
			bounces += 1
			return
		else: destroy()
	elif collision_shape is Entity:
		var damage_dealt = collision_shape.damage(damage_source, damage, damage_type)
		GlobalParticleManager.emit_damage_particles(position, damage_dealt)
		destroy()
	
	if hit_particles: GlobalParticleManager.emit(hit_particle_node, global_position, hit_particle_node.lifetime + 0.5)
