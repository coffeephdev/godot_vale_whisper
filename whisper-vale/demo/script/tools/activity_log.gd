class_name ActivityLog

static func log_quest(status: String, quest:Quest) -> void:
	print_rich("[b][color=green]" + status + ":[/color][/b] " + quest.description)
	
static func log_quest_step(status: String, quest_step:QuestStep) -> void:
	print_rich("[b][color=FOREST_GREEN]" + status + ":[/color][/b] " + quest_step.description)
