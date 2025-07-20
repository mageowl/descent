class_name ResourcePool extends Resource

@export var items: Array[Resource] = []

func pick_random() -> Resource:
	return items.pick_random()

func pick_many(count: int) -> Array[Resource]:
	var a: Array[Resource] = items.duplicate()
	return range(count).map(func (): return Util.remove_at(a, randi_range(0, a.size())))
