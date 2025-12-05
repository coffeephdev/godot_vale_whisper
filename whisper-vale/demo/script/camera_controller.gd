class_name CameraController extends Node3D

@export var player: Player
@export var distance_max: float = 3

@export var travel_speed: float = 7

@export var target_lookat_offset: float = 2
@export var camera_height_offset: float = 1.5
#@onready var Camera: Camera3D = $Camera3D

@export var rotation_speed: float = 0.1

func _ready() -> void:
	self.global_position.y = player.global_position.y + target_lookat_offset 
	
func _physics_process(delta: float) -> void:
	translate_controller(delta)

	var velocity: Vector2 = Input.get_last_mouse_velocity()
	mouse_rotate_camera(velocity * rotation_speed * delta / 100)
	self.transform = self.transform.looking_at(player.global_position + (Vector3.UP * target_lookat_offset))
	obstacle_player_cast()
	auto_reset_height(delta)

func mouse_rotate_camera(move):
	const ratio_compensation: float = 1.5
	self.translate_object_local(Vector3(-move.x, move.y * ratio_compensation, 0))

func translate_controller(delta: float):
	var distance_to_player: float = player.global_position.distance_to(self.global_position)
	
	if (distance_to_player > distance_max):
		var moving_speed = - delta * travel_speed * max(abs(distance_to_player - distance_max), 0)
		self.translate_object_local(Vector3(0, 0, moving_speed))
	
func obstacle_player_cast():
	var exclude_array = [player.get_rid(), RID(self)]
	
	var req = PhysicsRayQueryParameters3D.new()
	req.from = player.global_position
	req.to = self.global_position
	req.exclude = exclude_array
	
	var result := get_world_3d().direct_space_state.intersect_ray(req)
	
	if (result.size() > 0):
		var collision = result["collider"]
		if ( collision ):
			self.position = result["position"]
			var safety_margin := 0.15
			self.translate_object_local(Vector3(0, safety_margin, 0))
			
func auto_reset_height(delta):
	var exclude_array = [player.get_rid(), RID(self)]
	
	var req = PhysicsRayQueryParameters3D.new()
	req.from = self.position
	req.to = self.position + (Vector3.DOWN * camera_height_offset)
	req.exclude = exclude_array
	var result := get_world_3d().direct_space_state.intersect_ray(req)
	
	if (result.size() > 0):
		var collision = result["collider"]
		if ( collision ):
			self.translate(Vector3.UP * delta * rotation_speed)
