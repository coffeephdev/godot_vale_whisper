class_name mob extends CharacterBody3D

@export var thoughs: Array[String] = []

@onready var whisper = $whisper

@export var thought_distance := 20

func _process(_delta: float) -> void:
	if (GameMaster.player.position.distance_to(self.position) < thought_distance):
		whisper.handle_text()
