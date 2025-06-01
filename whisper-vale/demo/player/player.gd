class_name Player extends CharacterBody3D


enum _Anim {
	FLOOR,
	AIR,
}

const CHAR_SCALE = Vector3(0.3, 0.3, 0.3)
const MAX_SPEED = 6.0
const TURN_SPEED = 100.0
const CAM_SPEED = 0.1
const JUMP_VELOCITY = 12.5
const BULLET_SPEED = 20.0
const AIR_IDLE_DEACCEL = false
const ACCEL = 14.0
const DEACCEL = 14.0
const AIR_ACCEL_FACTOR = 0.5
const SHARP_TURN_THRESHOLD = deg_to_rad(140.0)

var movement_dir := Vector3()
var mouse_motion := Vector2()
var jumping := false

@onready var initial_position := position
@onready var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * \
		ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@onready var _camera_root := $CamRoot as Node3D
@onready var _camera := $CamRoot/Camera3D as Camera3D
@onready var _animation_tree := $AnimationTree as AnimationTree

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		if Input.is_action_pressed("enable_cam"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_rotate_camera(event.screen_relative * 0.008)
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func mouse_rotate_camera(move):
	_camera_root.rotate_y(-move.x)
	_camera_root.orthonormalize()
	_camera_root.rotation.x = clamp(_camera_root.rotation.x + move.y, -.99, .99)

func _physics_process(delta):
	if global_position.y < -12:
		# Player hit the reset button or fell off the map.
		position = initial_position
		velocity = Vector3.ZERO

	velocity += gravity * delta

	var anim := _Anim.FLOOR

	var vertical_velocity := velocity.y
	var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)

	var horizontal_direction := horizontal_velocity.normalized()
	var horizontal_speed := horizontal_velocity.length()

	# Player input.
	var cam_basis := _camera.get_global_transform().basis
	var movement_vec2 := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
	var movement_direction := Vector3(movement_vec2.x, 0, movement_vec2.y)
	
	if Input.is_action_pressed("enable_cam"):
		pass
	else:
		#Rotate with Keyboard
		movement_direction.x = 0
		var cam_movement = Vector3(0, movement_vec2.x, 0).normalized()
		
		if cam_movement.length() > 0:
			_camera_root.rotate(-cam_movement, CAM_SPEED)
			
	movement_direction = cam_basis * movement_direction
	movement_direction.y = 0
	
	movement_direction = movement_direction.normalized()

	if is_on_floor():
		horizontal_direction = movement_direction

		if horizontal_speed < MAX_SPEED:
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
			-facing_mesh,
			Vector3.UP,
			-facing_mesh.cross(Vector3.UP).normalized()
		).scaled(CHAR_SCALE)

		$Player/Skeleton.set_transform(Transform3D(m3, mesh_xform.origin))

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

	var ang := atan2(y,x)

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
