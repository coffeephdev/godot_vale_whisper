class_name CameraController extends Node3D

@export var player: CharacterBody3D
@export var distance_max: int = 3

@export var travel_speed = 7

@export var target_height_offset = 2
@onready var Camera: Camera3D = $Camera3D

@export var rotation_speed = 0.1

func _ready() -> void:
	var player_height: float = player.global_position.y + target_height_offset
	self.global_position.y = player_height

func _input(_event: InputEvent) -> void:
	return
	# if event is not InputEventMouseMotion:
	# 	return
		
	# if event.is_action_pressed("enable_mousecontrol"):
	# 	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# else:
	# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# 	mouse_rotate_camera(event.screen_relative * rotation_speed / 100)
	

	
func _physics_process(delta: float) -> void:
	translate_controller(delta)
	self.transform = self.transform.looking_at(player.global_position + Vector3.UP * target_height_offset)

	var truc = Input.get_last_mouse_velocity()
	mouse_rotate_camera(truc * rotation_speed / 100)


func mouse_rotate_camera(move):
	self.translate_object_local(Vector3(-move.x, move.y * 1.5, 0))

func translate_controller(delta: float):
	var distance_to_player: float = player.global_position.distance_to(self.global_position)
	var moving_speed = - delta * travel_speed * max(abs(distance_to_player - distance_max), 0)

	if (distance_to_player > distance_max):
		self.translate_object_local(Vector3(0, 0, moving_speed))
	else:
		self.translate_object_local(Vector3(0, 0, -moving_speed))
