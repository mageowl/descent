class_name WeaponDrop extends RigidBody2D

@export var weapon: WeaponType
@onready var sprite = $Sprite2D
@onready var collision_polygon = $CollisionPolygon2D
var inventory_object

func setup(weapon_type: WeaponType):
	weapon = weapon_type
	return self

func _ready():
	inventory_object = weapon.object
	sprite.texture = weapon.gui_texture
	collision_polygon.polygon = weapon.collision_shape

func _on_action(player: Player):
	player.equip_weapon(weapon)
	queue_free()
