extends Node

var damage_particles := preload("res://global/damage_particles.tscn")
@onready var damage_particles_instance: GPUParticles2D = damage_particles.instantiate()

func _ready():
	get_tree().get_nodes_in_group("main_camera")[0].add_child(damage_particles_instance)
	damage_particles_instance.top_level = true

func emit(particle_node: GPUParticles2D, position: Vector2, time: float):
	var particles: GPUParticles2D = particle_node.duplicate()
	particles.emitting = true
	particles.position = position
	add_child(particles)
	
	await get_tree().create_timer(time).timeout
	particles.queue_free()

func emit_damage_particles(position: Vector2, hurt_points: int):
	var offset = Vector2(randi_range(-5, 5) - 0.5, randi_range(-5, 5) - 0.5)
	
	damage_particles_instance.emit_particle(Transform2D(0, position + offset), Vector2.ZERO, Color.WHITE, Color(0, 0, hurt_points, 0), GPUParticles2D.EMIT_FLAG_POSITION + GPUParticles2D.EMIT_FLAG_CUSTOM)
