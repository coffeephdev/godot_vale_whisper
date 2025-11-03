extends Camera3D

@export var player: CharacterBody3D
@export var distance: int

func _process(_delta: float) -> void:
	self.transform.looking_at(player.position)
