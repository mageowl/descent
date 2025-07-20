class_name GenericMeleeWeapon extends GenericWeapon

@export var hurt_time_max = 0.25
@export var hurt_time_min = 0.1
@export var knockback_min = 190
@export var knockback_max = 200
@export var knockback_decay = 20
@export var damage_type: DamageSource.Type = Type.PHYSICAL
@export var damage := 4
@export_node_path("Area2D") var hurt_box
@onready var hurt_box_node: Area2D = get_node(hurt_box)
@export_node_path("RayCast2D") var pogo_raycast
@onready var pogo_raycast_node: RayCast2D = get_node(pogo_raycast)
var targets: Array[Entity] = []

func _process_weapon(aim: Vector2):
	if cooldown <= hurt_time_max and cooldown > hurt_time_min:
		for target: Node2D in hurt_box_node.get_overlapping_bodies():
			if target is Entity and target != parent and not targets.has(target):
				var damage_dealt = target.damage(self, damage, damage_type)
				target.knockback(aim * randi_range(knockback_min, knockback_max), knockback_decay)
				GlobalParticleManager.emit_damage_particles(target.position, damage_dealt)
				targets.push_back(target)
	if cooldown == 0:
		targets = []
	
	if input_map.is_action_pressed("attack") and cooldown <= hurt_time_min:
		_attack()
		targets = []

		if aim.y > 0.5 and pogo_raycast_node.is_colliding():
			parent.velocity.y = -250

func _attack():
	pass
