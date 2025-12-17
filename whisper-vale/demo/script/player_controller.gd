class_name PlayerController extends Node

func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("Interaction"):
		GameLead.player.interact()
