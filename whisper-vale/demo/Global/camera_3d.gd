extends Camera3D

@export var player: CharacterBody3D
@export var distance_max: int = 3

@export var camera_height: int = 2
@export var speed = 7

const target_height_offset = 2


func _physics_process(delta: float) -> void:
	self.transform = self.transform.looking_at(player.global_position + Vector3.UP * target_height_offset)

	var player_height: float = player.global_position.y + target_height_offset

	self.global_position.y = player_height + camera_height

	var distance_to_player: float = player.global_position.distance_to(self.global_position)

	var moving_speed = -delta * speed * max(abs(distance_to_player - distance_max), 0)

	if (distance_to_player > distance_max):
		self.translate_object_local(Vector3(0, 0, moving_speed))
	else:
		self.translate_object_local(Vector3(0, 0, -moving_speed))
