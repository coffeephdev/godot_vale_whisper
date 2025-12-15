extends Node
@export var dialogue:DialogueResource
@export var skip_Dialogue:= false

func _ready() -> void:
	if (skip_Dialogue): return
	
	DialogueManager.show_dialogue_balloon(dialogue)
