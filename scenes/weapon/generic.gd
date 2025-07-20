class_name GenericWeapon extends DamageSource

var cooldown: float = 0.0
var input_map: FilteredInputMap

func _enter_tree():
	if input_map == null: process_mode = Node.PROCESS_MODE_DISABLED

func _get_weapon_data() -> WeaponData:
	return WeaponData.new()

func _set_data(map: FilteredInputMap, entity_team: Team) -> void:
	input_map = map
	team = entity_team
	process_mode = Node.PROCESS_MODE_INHERIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown > 0: cooldown = max(cooldown - delta, 0);

func _process_weapon(_aim: Vector2):
	pass

func create_unique_resource(obj: Object, path: String):
	obj[path] = obj[path].duplicate(true)
