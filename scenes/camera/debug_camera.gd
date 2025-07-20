extends Camera2D

@onready var default_pos = position

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= 1
	if Input.is_action_pressed("ui_right"):
		position.x += 1
	if Input.is_action_pressed("ui_down"):
		position.y += 1
	if Input.is_action_pressed("ui_up"):
		position.y -= 1
	if Input.is_action_pressed("ui_home"):
		zoom *= 0.99
	if Input.is_action_pressed("ui_end"):
		zoom *= 1.01
	if Input.is_action_just_pressed("ui_cancel"):
		position = default_pos
		zoom = Vector2.ONE
