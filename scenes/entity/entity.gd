class_name Entity extends CharacterBody2D

signal hp_changed(value: int)
signal max_hp_changed(value: int)

const FLASH_SHADER = preload("res://global/shaders/flash.gdshader")

@export var max_hp: int = 10 :
	set(v):
		max_hp_changed.emit(v)
		max_hp = max(v, 1)
		hp = min(hp, max_hp)
@export var team: DamageSource.Team = DamageSource.Team.ENEMY
@onready var hp: int = max_hp :
	set(v):
		hp_changed.emit(v)
		hp = max(v, 0)
var modifiers = ModifierArray.new(self, ["damage", "heal", "deal_damage"])
var invul = 0

var knockback_force: Vector2
var knockback_decay: float
var knockback_power: float

func _ready():
	var sprite = get_node_or_null("Sprite")
	if sprite != null:
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = FLASH_SHADER

func _physics_process(delta):
	if invul >= 1:
		invul -= 1
	
	knockback_force = knockback_force.move_toward(Vector2.ZERO, knockback_power * knockback_decay * delta)

func damage(source: DamageSource, hurt_points: int, type: DamageSource.Type):
	var args = {"source": source, "hurt_points": hurt_points, "type": type}
	if source.parent != null: args = source.parent.modifiers.deal_damage.modify(args)
	args = source.modifiers.deal_damage.modify(args)
	args = modifiers.damage.modify(args)
	
	if team == source.team: args.hurt_points = -1
	
	if args.hurt_points != -1 && has_node("Sprite"):
		var tween = create_tween()
		var shader_material: ShaderMaterial = $Sprite.material
		tween.tween_callback(func (): shader_material.set_shader_parameter("flash", true))
		tween.tween_interval(0.1)
		tween.tween_callback(func (): shader_material.set_shader_parameter("flash", false))
	if invul == 0 and args.hurt_points > 0: hp -= args.hurt_points
	if hp <= 0: _kill()
	
	
	return 0 if invul >= 1 else args.hurt_points

func heal(source: DamageSource, hit_points: int):
	var args = modifiers.damage.modify({"source": source, "hit_points": hit_points})
	hp += args.hit_points

func knockback(force: Vector2, decay: float):
	knockback_force = force
	knockback_decay = decay
	knockback_power = force.length()

func _kill():
	queue_free()
