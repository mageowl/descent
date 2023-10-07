class_name DamageSource extends Node2D

enum TYPE {
	Point,
	Cold,
	Fire,
	Poison,
	Physical,
	Phychic,
	Radiant
}

var modifiers = ModifierArray.new(self, [])
