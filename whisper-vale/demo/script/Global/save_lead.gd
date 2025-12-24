extends Node

var register: Array[Node] = []

var save_path := "user://savegame.txt"
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("quicksave")):
		savegame()
	elif (event.is_action_pressed("quickload")):
		loadgame()
func add_to_register( node: Node ):
	register.append(node)
	
func savegame():
	#C:\Users\Light\AppData\Roaming\Godot\app_userdata\Whisper-Vale
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var dico_save:Dictionary
	for node in register:
		if (node is Player):
			dico_save.set("pos_x", node.global_position.x)
			dico_save.set("pos_y", node.global_position.y)
			dico_save.set("pos_z", node.global_position.z)
		elif (node is QuestLead):
			var quest_lead = node as QuestLead
			dico_save.set("completed_quest", quest_lead.completed_quests)
			dico_save.set("started_quests", quest_lead.started_quests)
	var success = file.store_string(JSON.stringify(dico_save))
	ActivityLog.log_savegame(success,"Game")
	file.close()
	
func loadgame():
	var file = FileAccess.open(save_path, FileAccess.READ)
	var dico_save:Dictionary = JSON.parse_string(file.get_as_text(true))
	for node in register:
		if (node is Player):
			node.global_position.x = dico_save.get("pos_x")
			node.global_position.y = dico_save.get("pos_y")
			node.global_position.z = dico_save.get("pos_z")
		elif (node is QuestLead):
			var quest_lead = node as QuestLead
			quest_lead.completed_quests.clear()
			quest_lead.completed_quests.assign(dico_save.get("completed_quest")) 
			# this is not working. Need to save with quest tag and also quest_step tag
			quest_lead.started_quests.clear()
			quest_lead.started_quests.assign( dico_save.get("started_quests"))
	file.close()
	ActivityLog.log_loadgame()
	
func get_full_tree() -> String:
	return get_tree().root.get_tree_string_pretty()
	
