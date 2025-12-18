extends Node

@export_storage var started_quests = []
const quest_resource_path = "res://demo/data/quest/"

func _ready() -> void:
	pass # Replace with function body.

func start_quest(quest: QuestStep):
	started_quests.append(quest)

func start_quest_string(quest: String):
	var resource := load(quest_resource_path.path_join(quest) + ".tres") as QuestStep
	start_quest(resource)
