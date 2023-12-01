class_name Entity extends CharacterBody2D

const FLASH_SHADER = preload("res://global/shaders/flash.gdshader")

@export var max_hp = 10
@export var team: DamageSource.Team = DamageSource.Team.ENEMY
@onready var hp = max_hp
var modifiers = ModifierArray.new(self, ["damage", "heal", "deal_damage"])
var invul = 0

func _ready():
	var sprite = get_node_or_null("Sprite")
	if sprite != null:
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = FLASH_SHADER

func _process(_delta):
	if invul >= 1:
		invul -= 1

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

func _kill():
	queue_free()
