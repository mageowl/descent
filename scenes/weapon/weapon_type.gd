class_name WeaponType extends Resource

const weapon_drop = preload("res://scenes/weapon/weapon_drop.tscn")

static var FIST = WeaponType.new(true)
@export var name = "Generic Weapon"
@export var object: PackedScene
@export var gui_texture: Texture
@export var collision_shape: PackedVector2Array
@export var ammo: int = -1

func _init(is_null: bool = true):
	if is_null:
		name = "Fists"

func spawn() -> WeaponDrop:
	return weapon_drop.instantiate().setup(self)
