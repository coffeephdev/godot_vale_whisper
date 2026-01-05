class_name QuestStepData extends Object

var tag : String
var completed: bool = false

func get_description(quest_tag:String) -> String:
	return QuestLead.get_quest_step_description(quest_tag, tag)
