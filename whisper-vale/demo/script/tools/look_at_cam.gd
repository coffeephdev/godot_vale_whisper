extends Node3D

func _process(_delta: float) -> void:
	self.look_at(GameLead.camera.global_position)
