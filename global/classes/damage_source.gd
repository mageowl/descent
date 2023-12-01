class_name DamageSource extends Node2D

enum Type {
	FORCE,
	COLD,
	FIRE,
	POISON,
	PHYSICAL,
	PSYCHIC,
	RADIANT,
}

enum Team { PLAYER, ENEMY }

var modifiers = ModifierArray.new(self, ["deal_damage"])
var team = Team.ENEMY
var parent: Entity
