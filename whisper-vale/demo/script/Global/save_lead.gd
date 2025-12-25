extends Node

var register: Array[Node] = []

const SAVE_PATH := "user://savegame.tale"
const PLAYER_SECTION = "player"
const QUEST_SECTION = "quest"
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("quicksave")):
		savegame()
	elif (event.is_action_pressed("quickload")):
		loadgame()
func add_to_register( node: Node ):
	register.append(node)
	
func savegame():
	#C:\Users\Light\AppData\Roaming\Godot\app_userdata\Whisper-Vale
	var file = ConfigFile.new()
	for node in register:
		if (node is Player):
			file.set_value(PLAYER_SECTION, "position", node.global_position)
		elif (node is QuestLead):
			var quest_lead = node as QuestLead
			file.set_value(QUEST_SECTION, "completed_quests", quest_lead.completed_quests)
			file.set_value(QUEST_SECTION, "started_quests", quest_lead.started_quests)
	var success = file.save(SAVE_PATH)
	ActivityLog.log_savegame(success, 'Game')
	
func loadgame():
	var file = ConfigFile.new()
	file.load(SAVE_PATH)
	for node in register:
		if (node is Player):
			node.global_position = file.get_value(PLAYER_SECTION, "position")
		elif (node is QuestLead):
			var quest_lead = node as QuestLead
			quest_lead.completed_quests = file.get_value(QUEST_SECTION, "completed_quests")
			quest_lead.started_quests = file.get_value(QUEST_SECTION, "started_quests")
	ActivityLog.log_loadgame()
	
func get_full_tree() -> String:
	return get_tree().root.get_tree_string_pretty()
	
