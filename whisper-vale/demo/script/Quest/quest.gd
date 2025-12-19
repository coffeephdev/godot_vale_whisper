class_name Quest extends Resource

@export var tag: String
@export_multiline var description: String
@export var completed: bool = false
@export var quest_steps : Array[QuestStep] = []

func _ready() -> void:
	pass # Replace with function body.
