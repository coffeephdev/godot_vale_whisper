class_name QuestData extends Object

var tag: String
var completed: bool = false
var quest_steps : Array[QuestStepData] = []

func populate(resource:Quest):
	tag = resource.tag
	for step_resource in resource.quest_steps:
		var quest_step = null
		
		match step_resource.get_script():
			QuestStep:
				quest_step = QuestStepData.new()
			QuestStepItem:
				quest_step = QuestStepItemData.new()
				quest_step.item_to_collect = step_resource.item_to_collect
		
		quest_step.tag = step_resource.tag
		quest_steps.append(quest_step)

func get_description() -> String:
	return QuestLead.get_quest_description(tag)
