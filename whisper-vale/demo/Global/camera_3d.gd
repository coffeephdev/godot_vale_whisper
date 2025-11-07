extends Camera3D

@export var player: CharacterBody3D
@export var distance_max: int

const camera_height: int = 10
const speed = 10

func _physics_process(delta: float) -> void:
	var player_height: float = player.position.y
	var distance_to_player: float = player.position.distance_to(self.position)

	self.position.z = player_height + camera_height

	if (distance_to_player > distance_max):
		self.translate_object_local(Vector3(0, 0, -delta * speed))
	else:
		self.translate_object_local(Vector3(0, 0, delta * speed))

	self.transform = self.transform.looking_at(player.position)
