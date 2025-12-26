class_name QuestData extends Object

var tag: String
var completed: bool = false
var quest_steps : Array[QuestStepData] = []

func populate(resource:Quest):
	tag = resource.tag
	for step_resource in resource.quest_steps:
		var quest_step = QuestStepData.new()
		quest_step.tag = step_resource.tag
		quest_steps.append(quest_step)
