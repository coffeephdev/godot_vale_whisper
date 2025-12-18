class_name Quest extends Resource

@export var tag: String
@export var quest_steps : Array[QuestStep] = []
@export_multiline var description: String
@export var completed: bool = false

func _ready() -> void:
	pass # Replace with function body.
