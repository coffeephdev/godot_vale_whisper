extends Node3D

func _process(delta: float) -> void:
	self.look_at(GameLead.camera.global_position)
