class_name Player extends CharacterBody3D

@export var ray_lenght = 10
@export var MAX_SPEED = 6.0
@export var CAMERA: CameraController = null
@export var CAN_MOVE := true

@export var interactor: Interactor

enum _Anim {
	FLOOR,
	AIR,
}

const CHAR_SCALE = Vector3(0.3, 0.3, 0.3)
const TURN_SPEED = 100.0
const JUMP_VELOCITY = 12.5
const BULLET_SPEED = 20.0
const AIR_IDLE_DEACCEL = false
const ACCEL = 140.0
const DEACCEL = 14.0
const AIR_ACCEL_FACTOR = 0.5
const SHARP_TURN_THRESHOLD = deg_to_rad(140.0)

var movement_dir := Vector3()
var mouse_motion := Vector2()
var jumping := false
var auto_walk := false

var dialogue_target = null

@onready var initial_position := position
@onready var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * \
		ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@onready var _animation_tree := $AnimationTree as AnimationTree

func _init() -> void:
	unique_name_in_owner = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	GameLead.player = self
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func handle_auto_walk():
	if Input.is_action_just_pressed("auto_walk"):
		auto_walk = !auto_walk
	if Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_back"):
		auto_walk = false
		
func _physics_process(delta):
	if !CAN_MOVE:
		return
	
	velocity += gravity * delta

	var anim := _Anim.FLOOR

	var vertical_velocity := velocity.y
	var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)

	var horizontal_direction := horizontal_velocity.normalized()
	var horizontal_speed := horizontal_velocity.length()

	# Player input.
	handle_auto_walk()
	
	var cam_basis := CAMERA.get_global_transform().basis
	var movement_vec2 := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
	if auto_walk:
		movement_vec2.y = -1
		
	var movement_direction := Vector3(movement_vec2.x, 0, movement_vec2.y)
			
	movement_direction = cam_basis * movement_direction
	movement_direction.y = 0
	
	horizontal_direction = movement_direction.normalized()

	if (horizontal_direction != Vector3.ZERO && horizontal_speed < MAX_SPEED):
			horizontal_speed += ACCEL * delta
	else:
		horizontal_speed -= DEACCEL * delta
		if horizontal_speed < 0:
			horizontal_speed = 0

	horizontal_velocity = horizontal_direction * horizontal_speed

	var mesh_xform := ($Player/Skeleton as Node3D).get_transform()
	var facing_mesh := -mesh_xform.basis[0].normalized()
	facing_mesh = (facing_mesh - Vector3.UP * facing_mesh.dot(Vector3.UP)).normalized()

	facing_mesh = adjust_facing(
		facing_mesh,
		movement_direction,
		delta,
		1.0 / horizontal_speed * TURN_SPEED,
		Vector3.UP
	)
	
	var m3 := Basis(
		- facing_mesh,
		Vector3.UP,
		- facing_mesh.cross(Vector3.UP).normalized()
	).scaled(CHAR_SCALE)

	$Player/Skeleton.set_transform(Transform3D(m3, mesh_xform.origin))
	
	if is_on_floor():
			if not jumping and Input.is_action_pressed(&"jump"):
				vertical_velocity = JUMP_VELOCITY
				jumping = true
	else:
		anim = _Anim.AIR

		if movement_direction.length() > 0.1:
			horizontal_velocity += movement_direction * (ACCEL * AIR_ACCEL_FACTOR * delta)
			if horizontal_velocity.length() > MAX_SPEED:
				horizontal_velocity = horizontal_velocity.normalized() * MAX_SPEED
		elif AIR_IDLE_DEACCEL:
			horizontal_speed = horizontal_speed - (DEACCEL * AIR_ACCEL_FACTOR * delta)
			if horizontal_speed < 0:
				horizontal_speed = 0
			horizontal_velocity = horizontal_direction * horizontal_speed

		if Input.is_action_just_released("jump") and velocity.y > 0.0:
			# Reduce jump height if releasing the jump key before reaching the apex.
			vertical_velocity *= 0.7

	if jumping and vertical_velocity < 0:
		jumping = false

	velocity = horizontal_velocity + Vector3.UP * vertical_velocity

	if is_on_floor():
		movement_dir = velocity
	
	move_and_slide()

	if is_on_floor():
		# How much the player should be blending between the "idle" and "walk/run" animations.
		_animation_tree[&"parameters/run/blend_amount"] = horizontal_speed / MAX_SPEED

		# How much the player should be running (as opposed to walking). 0.0 = fully walking, 1.0 = fully running.
		_animation_tree[&"parameters/speed/blend_amount"] = minf(1.0, horizontal_speed / (MAX_SPEED * 0.5))

	_animation_tree[&"parameters/state/blend_amount"] = anim
	_animation_tree[&"parameters/air_dir/blend_amount"] = clampf(-velocity.y / 4 + 0.5, 0, 1)

func adjust_facing(facing: Vector3, target: Vector3, step: float, adjust_rate: float, \
		current_gn: Vector3) -> Vector3:
	var normal := target
	var t := normal.cross(current_gn).normalized()

	var x := normal.dot(facing)
	var y := t.dot(facing)

	var ang := atan2(y, x)

	if absf(ang) < 0.001:
		return facing

	var s := signf(ang)
	ang = ang * s
	var turn := ang * adjust_rate * step
	var a: float
	if ang < turn:
		a = ang
	else:
		a = turn
	ang = (ang - a) * s

	return (normal * cos(ang) + t * sin(ang)) * facing.length()
	
func raycast_target():
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		return
		
	var space := get_world_3d().direct_space_state
	var mousepos := get_viewport().get_mouse_position()
	var query := PhysicsRayQueryParameters3D.create(
		CAMERA.global_position,
		CAMERA.project_position(mousepos, ray_lenght)
		)
	query.exclude = [self]
	
	var result := space.intersect_ray(query)
		
	if result == null:
		reset_raycast()
		return
		
	var object = result.get("collider")
	if object == dialogue_target:
		return
		
	if object == null || object is not CharacterBody3D:
		reset_raycast()
		return
		
	if object is not Mob:
		reset_raycast()
		return
		
	if object.has_dialogue:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		dialogue_target = object
		
func reset_raycast():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	dialogue_target = null

func _on_dialogue_started(_resource):
	CAN_MOVE = false
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CONFINED
func _on_dialogue_ended(_resource):
	CAN_MOVE = true
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED

func interact():
	if (interactor.nearest_contact != null):
		DialogueLead.start_dialogue(interactor.nearest_contact)
