class_name WeaponData

static var FIST = WeaponData.new().set_display_name("Fist")

var display_name := "MissingData"
var ammo := -1
# etc.

func set_display_name(value: String):
	display_name = value
	return self

func set_ammo(value = null):
	ammo = value
	return self
