class_name Player extends Entity

const SPEED = 125.0
const ACCELERATION = 0.1
const FRICTION = 0.7
const AIR_FRICTION = 0.1

const JUMP_VELOCITY = 200.0
const MIN_JUMP_VELOCITY = 5.0
const MIN_JUMP_SPAN = 4

const GRAVITY = 1000.0
const JUMP_GRAVITY = 900.0

const CYOTE_TIME = 8
const HOLD_JUMP = 4

@export var player_index = 0
@onready var weapon_container = $Weapons
@onready var animation_tree = $Sprite/AnimationTree
@onready var sprite = $Sprite
@onready var input_map: FilteredInputMap = $InputMap
@onready var pickup_radius = $PickupRadius
var falling = 0
var impact = 0
var jump_input = 0
var short_jump = false
var short_jumped = false

var current_action_callback: Callable = Util.PASS
var weapons: Array[WeaponType] = [WeaponType.FIST, WeaponType.FIST]
var current_weapon
var weapon_index: int = 0

func _ready():
	input_map.controller = player_index
	set_name.call_deferred(StringName("Player" + str(player_index + 1)))
	
	for weapon in weapon_container.get_children():
		weapon._set_input_map(input_map)

func animate(direction):
	var set_p = func (property, value): 
		animation_tree["parameters/" + property] = value
	
	if direction != 0: sprite.flip_h = direction < 0
	set_p.call("is_walking/transition_request", "walk" if direction != 0 else "static")
	set_p.call("tilting/transition_request", ["left", "static", "right"][round(direction) + 1])
	set_p.call("in_air/transition_request", "ground" if is_on_floor() else "air")
	
	if is_on_floor():
		if impact > 0:
			var squash_factor: float = min(impact / 10.0, 50.0) / 80.0
			set_p.call("squash/blend_position", -squash_factor)
			impact -= 50
		else:
			set_p.call("squash/blend_position", 0)
			
			if impact < 0 or impact > 0: impact = 0
	else:
		var squash_factor : float = min((min(velocity.y, GRAVITY * 10) * 0.5) / (JUMP_VELOCITY * (2 if velocity.y > 0 else 1)), 0.3)
		set_p.call("squash/blend_position", squash_factor)
		
		impact = velocity.y * 1.6

func movement(delta) -> int:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (GRAVITY if velocity.y >= 0 else JUMP_GRAVITY) * delta
		falling += 1
	else:
		falling = 0
		short_jump = false
		short_jumped = false

	# Handle Jump.
	if input_map.is_action_just_pressed("jump"):
		jump_input = 4
	elif jump_input > 0:
		jump_input -= 1
	
	if jump_input > 0 and falling < CYOTE_TIME:
		velocity.y = -JUMP_VELOCITY
		falling = 0 
	
	if input_map.is_action_just_released("jump"):
		if velocity.y < 0 and not short_jumped:
			short_jump = true
	
	if falling >= MIN_JUMP_SPAN and short_jump and not short_jumped:
		velocity.y = -MIN_JUMP_VELOCITY
		short_jumped = true
	
	var direction = Util.deadzone(input_map.get_axis("left", "right"), 0.15, 0.4)
	if direction and not input_map.is_action_pressed("aim"):
		velocity.x = move_toward(velocity.x, sign(direction) * SPEED, ACCELERATION * SPEED * abs(direction))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * (FRICTION if is_on_floor() else AIR_FRICTION))
	
	return sign(direction) if not input_map.is_action_pressed("aim") else 0

func equip_weapon(weapon: WeaponType):
	if current_weapon != null:
		var thrown_instance: RigidBody2D = weapons[weapon_index].spawn()
		thrown_instance.position = position
		thrown_instance.apply_impulse(Vector2(0, -randi_range(80, 100)).rotated(randf_range(-0.2 * TAU, 0.2 * TAU)))
		get_parent().add_child(thrown_instance)
		current_weapon.queue_free()
	
	var instance: GenericWeapon = weapon.object.instantiate()
	instance._set_input_map(input_map)
	weapon_container.add_child(instance)
	
	weapons[weapon_index] = weapon
	current_weapon = instance

func swap_weapon():
	if current_weapon != null:
		current_weapon.visible = false
		current_weapon._swap_from() if current_weapon.has_method("_swap_from") else null
	
	weapon_index = (weapon_index + 1) % 2
	current_weapon = weapon_container.get_child(weapon_index) if weapons[weapon_index] != WeaponType.FIST else null
	if current_weapon != null:
		current_weapon.visible = true
		current_weapon._swap_to() if current_weapon.has_method("_swap_to") else null

func _physics_process(delta):
	var direction = movement(delta)
	animate(direction)
	
	if current_weapon != null:
		var aim = Util.deadzone2(input_map.get_vector("left", "right", "aim_up", "aim_down")).normalized().snapped(Vector2(1, 1))
		if aim == Vector2.ZERO: aim.x = int(sprite.flip_h) * -2 + 1
		if aim.y > 0 and not input_map.is_action_pressed("aim"): aim.x = 0
		current_weapon._process_weapon(aim)
	
	if input_map.is_action_just_pressed("action") and current_action_callback != Util.PASS:
		current_action_callback.call(self)
	if input_map.is_action_just_pressed("swap_weapon"):
		swap_weapon()
	
	move_and_slide()


func _on_enter_action_trigger(body):
	animation_tree["parameters/marker_state/transition_request"] = "action"

	if body.has_method("_on_action"):
		current_action_callback = body._on_action


func _on_exit_action_trigger(_body):
	animation_tree["parameters/marker_state/transition_request"] = "static"
	current_action_callback = Util.PASS
