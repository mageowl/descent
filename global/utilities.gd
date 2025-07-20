class_name Util

@warning_ignore("shadowed_variable")
static func deadzone(value: float, deadzone: float = 0.1, snap: float = 0.95) -> float:
	return (value if abs(value) < snap else sign(value)) if abs(value) > deadzone else 0

@warning_ignore("shadowed_variable")
static func deadzone2(vec: Vector2, deadzone: float = 0.1, snap: float = 0.95) -> Vector2:
	var x = (vec.x if abs(vec.x) < snap else sign(vec.x)) if abs(vec.x) > deadzone else 0
	var y = (vec.y if abs(vec.y) < snap else sign(vec.y)) if abs(vec.y) > deadzone else 0
	return Vector2(x, y)

static func remove_at(array: Array, index: int):
	var v = array[index]
	array.remove_at(index)
	return v

static func PASS():
	pass
