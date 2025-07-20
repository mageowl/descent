class_name PlayerHUD extends Control

const SKINS = [preload("res://scenes/player/hud/icons/john-head.png"), preload("res://scenes/player/hud/icons/gator-head.png"), preload("res://scenes/player/hud/icons/ora-head.png")]
const PLAYER_IDS = [preload("res://scenes/player/hud/icons/p1.png"),preload("res://scenes/player/hud/icons/p2.png"),preload("res://scenes/player/hud/icons/p3.png"),preload("res://scenes/player/hud/icons/p4.png")]

@onready var headshot = $Headshot
@onready var p_index = $PlayerIndex
@onready var hp_label = $HP
@onready var hp_bar = $HealthBar
@onready var weapons = [$Weapon1, $Weapon2]
@onready var weapon_indicator = $WeaponIndicator

func set_player_data(index: int, character: int):
	headshot.texture = SKINS[character]
	p_index.texture = PLAYER_IDS[index]
	weapon_indicator.texture = Player.MARKERS[index]

func set_hp(value: int):
	print(value, hp_bar)
	hp_label.text = str(value)
	hp_bar.value = value

func set_max_hp(value: int):
	print(value)
	hp_bar.max_value = value

func set_weapon(index: int, sprite: Texture):
	weapons[index].texture = sprite

func select_weapon(index: int):
	create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).tween_property(weapon_indicator, "position:x", 47 - 12 * index, 0.25)
