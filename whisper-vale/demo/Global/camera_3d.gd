extends Camera3D

@export var player: CharacterBody3D
@export var distance: int

func _process(delta: float) -> void:
	transform.looking_at(player.position)
