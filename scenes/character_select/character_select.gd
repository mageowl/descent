class_name CharacterSelectScreen extends Node2D

const PlayerScene = preload("res://scenes/player/player.tscn")
const MARKERS = [
	preload("res://scenes/player/marker-1.png"),
	preload("res://scenes/player/marker-2.png"),
	preload("res://scenes/player/marker-3.png"),
	preload("res://scenes/player/marker-4.png")
]

@onready var fire_anim = $Fire/AnimationPlayer
@onready var player_container = $Shaders/Players
@onready var availible_player_container = $Shaders/SittingPlayers
@onready var player_selectors = $Shaders/PlayerSelectors
var selecting_players: Array[int] = []
var input_cooldown: Array[float] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_anim.play("flicker")
	
	for joypad_id in Input.get_connected_joypads():
		var instance: Player = PlayerScene.instantiate()
		instance.player_index = joypad_id
		instance.process_mode = Node.PROCESS_MODE_DISABLED
		player_container.add_child(instance)

		var selector: Sprite2D = Sprite2D.new()
		selector.texture = MARKERS[joypad_id]
		selector.position = availible_player_container.get_child(joypad_id).position
		selector.offset.y = -10
		selector.name = "Selector%d" % joypad_id
		player_selectors.add_child(selector)
		
		input_cooldown.append(0)
		selecting_players.append(joypad_id)

func _process(delta):
	for i in range(input_cooldown.size()):
		if input_cooldown[i] != 0:
			input_cooldown[i] = move_toward(input_cooldown[i], 0, delta)

func _input(event):
	if event is InputEventJoypadMotion and event.axis == JOY_AXIS_LEFT_X:
		var node_path = "Shaders/PlayerSelectors/Selector%d" % event.device

		if has_node(node_path) and sign(input_cooldown[event.device]) != sign(event.axis_value) and selecting_players[event.device] != -1:
			var selector = get_node(node_path)
			var index = clamp(selecting_players[event.device] + roundi(event.axis_value), 0, availible_player_container.get_child_count() - 1)
			move_selector(selector, index, event.device, sign(event.axis_value))
	elif event is InputEventJoypadButton and event.button_index == JOY_BUTTON_B and selecting_players[event.device] != -1:
		availible_player_container.get_child(selecting_players[event.device]).visible = false
		get_node("Shaders/PlayerSelectors/Selector%d" % event.device).visible = false
		enable_player(event.device, selecting_players[event.device])

func move_selector(selector, index, d, s):
	input_cooldown[d] = s * 0.1
	selecting_players[d] = index
	
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(selector, "position", availible_player_container.get_child(index).position, 0.2)

func enable_player(device, index):
	var player: Player = player_container.get_child(device)
	player.set_character_skin(index)
	player.position = availible_player_container.get_child(index).position
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.player_index = device
	print(device)
	selecting_players[device] = -1
