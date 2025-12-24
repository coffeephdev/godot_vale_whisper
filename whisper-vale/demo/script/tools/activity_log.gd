class_name ActivityLog

static func log_quest(status: String, quest:Quest) -> void:
	print_rich("[b][color=green]" + status + ":[/color][/b] " + quest.description)
	
static func log_quest_step(status: String, quest_step:QuestStep) -> void:
	print_rich("[b][color=FOREST_GREEN]" + status + ":[/color][/b] " + quest_step.description)
	
static func log_savegame(success: bool, topic: String) -> void:
	if success:
		print_rich("[b][color=DEEP_SKY_BLUE]Saving " + topic + ": [/color][/b]" + "Successful")
	else:
		print_rich("[b][color=CRIMSON]Saving " + topic + ": [/color][/b]" + "Error")
		
static func log_loadgame():
	print_rich("[b][color=DEEP_SKY_BLUE]Game Loaded[/color][/b]")
