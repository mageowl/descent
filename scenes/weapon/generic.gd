class_name GenericWeapon extends DamageSource

var cooldown: float = 0.0
var input_map: FilteredInputMap

func _get_weapon_data() -> WeaponData:
	return WeaponData.new()

func _set_input_map(map: FilteredInputMap) -> void:
	input_map = map

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown > 0: cooldown = max(cooldown - delta, 0);

class WeaponData extends Resource:
	
	var display_name := "MissingData"
	var ammo := -1
#	etc.
	
	func set_display_name(value: String):
		display_name = value
		return self
	
	func set_ammo(value = null):
		ammo = value
		return self
