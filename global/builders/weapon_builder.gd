@tool
class_name WeaponBuilder extends SceneBuilder

var scene_types = {
	"Generic": Node2D,
	"Melee": Area2D,
	"None": Node
}

func _enter_tree():
	steps.append(step_texture("Texture"))
	steps.append(step_polygon("Collision Shape", Color(1, 0, 0, 0.5)))
	steps.append(step_value("Name", ""))
	steps.append(step_value("Scene Type", "Choose One", ["Generic", "Melee", "None"]))
	print("added steps")

func _on_finished():
	var scene = (scene_types[data.scene_type.value]).new()
	scene.set_script(GenericWeapon)
	scene.name = data.name.value.to_pascal_case()
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	sprite.texture = data.texture.texture
	scene.add_child(sprite)
	sprite.owner = scene
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(scene)
	if data.scene_type.value != "None": ResourceSaver.save(packed_scene, "res://scenes/weapon/weapon_objects/" + data.name.value.to_snake_case() + ".tscn", ResourceSaver.FLAG_CHANGE_PATH)
	
	var weapon_type = WeaponType.new()
	weapon_type.name = data.name.value
	weapon_type.gui_texture = data.texture.texture
	weapon_type.collision_shape = data.collision_shape.polygon
	weapon_type.object = packed_scene if data.scene_type.value != "None" else load("res://scenes/weapon/weapon_objects/" + data.name.value.to_snake_case() + ".tscn")
	
	ResourceSaver.save(weapon_type, "res://scenes/weapon/weapon_types/" + data.name.value.to_snake_case() + ".tres", ResourceSaver.FLAG_CHANGE_PATH)
	
	for child in get_children(): remove_child(child)

