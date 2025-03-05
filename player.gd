extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002

var gravity = ProjectSettings.get("physics/3d/default_gravity")
var look_x = 0.0
var look_y = 0.0

@onready var camera_pivot = $CameraPivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse for camera control

func _input(event):
	if event is InputEventMouseMotion:
		look_x -= event.relative.x * mouse_sensitivity
		look_y -= event.relative.y * mouse_sensitivity
		look_y = clamp(look_y, -1.5, 1.5)  # Prevent over-rotation

		camera_pivot.rotation.y = look_x
		camera_pivot.rotation.x = look_y

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction = direction.normalized() * speed
	velocity.x = direction.x
	velocity.z = direction.z

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
