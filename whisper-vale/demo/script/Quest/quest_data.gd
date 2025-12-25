class_name QuestData extends Object

var tag: String
var completed: bool = false
var quest_steps : Array[QuestStepData]

func _init(resource: Quest) -> void:
	tag = resource.tag
	quest_steps = quest_steps.map(func(step:QuestStep): return step.tag )
