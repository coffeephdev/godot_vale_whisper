class_name ActivityLog

static func log_quest(status: String, quest:QuestData) -> void:
	print_rich("[b][color=green]" + status + ":[/color][/b] " + quest.tag)
	
static func log_quest_step(status: String, quest_step:QuestStepData) -> void:
	print_rich("[b][color=FOREST_GREEN]" + status + ":[/color][/b] " + quest_step.tag)
	
static func log_savegame(success: Error, topic: String) -> void:
	if success == OK:
		print_rich("[b][color=DEEP_SKY_BLUE]Saving " + topic + ": [/color][/b]" + "Successful")
	else:
		print_rich("[b][color=CRIMSON]Saving " + topic + ": [/color][/b]" + str(success))
		
static func log_loadgame():
	print_rich("[b][color=DEEP_SKY_BLUE]Game Loaded[/color][/b]")
