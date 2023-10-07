class_name BasicBullet extends Area2D

signal hit_level
signal hit_entity

@export_group("Physics")
@export var speed = 200
@export var bullet_gravity = 0
@export var pierce = 0
@export_group("Display")
@export var rotateSprite = true
@export_node_path("GPUParticles2D") var hit_particles: NodePath
@export_group("Entity Collision")
@export var damage = 0
@export var damage_type = DamageSource.TYPE.Physical
var velocity = Vector2.ZERO
var hits = -1
var destroyed = false
var damage_source: DamageSource
var hit_particle_node: GPUParticles2D

func destroy():
	if destroyed: return
	else: destroyed = true
	
	if get_parent() is ObjectPool:
		get_parent().call_deferred("free_instance", get_index())
	else:
		queue_free()

func enable():
	destroyed = false

func set_parent(parent: Node):
	if parent is DamageSource: damage_source = parent

# Called when the node enters the scene tree for the first time.
func _ready():
	hits = pierce
	body_entered.connect(hit_body)
	if hit_particles != null: hit_particle_node = get_node(hit_particles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var query = PhysicsRayQueryParameters2D.create(position, position + speed * velocity * delta)
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	
	if result:
		hit_body(result.collider)
	
	position += speed * velocity * delta
	if rotateSprite: rotation = velocity.angle();

func hit_body(collision_shape: Node2D):
	if hit_particles: GlobalParticleManager.emit(hit_particle_node, global_position, hit_particle_node.lifetime + 0.5)
	if destroyed: return
	
	if collision_shape is TileMap:
		destroy()
	elif collision_shape is Entity:
		var damage_dealt = collision_shape.damage(damage_source, damage, damage_type)
		GlobalParticleManager.emit_damage_particles(position, damage_dealt)
		destroy()
