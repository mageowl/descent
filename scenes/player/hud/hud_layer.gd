extends CanvasLayer

const HUD = preload("res://scenes/player/hud/player_hud.tscn")

@export_node_path("Node2D") var player_container
@onready var player_container_node: Node2D = get_node(player_container)
@onready var hud_container = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	player_container_node.child_entered_tree.connect(add_player)
	for player in player_container_node.get_children():
		add_player(player)

func add_player(player: Player):
	var instance = HUD.instantiate()
	
	player.hp_changed.connect(instance.set_hp)
	player.max_hp_changed.connect(instance.set_max_hp)
	
	hud_container.add_child(instance)
	player.hud = instance
	
	instance.set_hp(player.hp)
	instance.set_max_hp(player.max_hp)
	instance.set_player_data(player.player_index, player.skin)
