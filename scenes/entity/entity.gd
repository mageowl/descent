class_name Entity extends CharacterBody2D

@export var max_hp = 10
var modifiers = ModifierArray.new(self, ["damage", "heal"])
@onready var hp = max_hp
var invul = 0

func _process(_delta):
	if invul >= 1:
		invul -= 1

func damage(source: DamageSource, hurt_points: int, type: DamageSource.Type):
	var args = modifiers.damage.modify({"source": source, "hurt_points": hurt_points, "type": type})
	if invul == 0: hp -= args.hurt_points
	return 0 if invul >= 1 else args.hurt_points

func heal(source: DamageSource, hit_points: int):
	var args = modifiers.damage.modify({"source": source, "hit_points": hit_points})
	hp += args.hit_points
