class_name mob extends CharacterBody3D

@export var thoughs: Array[String] = []

@onready var text = $dialog

func _on_area_3d_body_entered(body: Player) -> void:
	text.display_text()
