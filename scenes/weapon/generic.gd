class_name GenericWeapon extends DamageSource

var cooldown: float = 0.0
var input_map: FilteredInputMap

func _get_weapon_data() -> WeaponData:
	return WeaponData.new()

func _set_data(map: FilteredInputMap, entity_team: Team) -> void:
	input_map = map
	team = entity_team

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown > 0: cooldown = max(cooldown - delta, 0);

func _process_weapon(_aim: Vector2):
	pass
