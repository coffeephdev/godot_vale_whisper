extends Node

var register: Array[Node] = []

var save_path := "user://savegame.txt"
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("quicksave")):
		savegame()
func add_to_register( node: Node ):
	register.append(node)
	
func savegame():
	#C:\Users\Light\AppData\Roaming\Godot\app_userdata\Whisper-Vale
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	for node in register:
		if (node is Player):
			var player_dict = {
				"pos_x": node.global_position.x,
				"pos_y": node.global_position.y,
				"pos_z": node.global_position.z
			}
			var success = file.store_line(JSON.stringify(player_dict))
			ActivityLog.log_savegame(success)
	file.close()
	
func loadgame():
	pass
	
func get_full_tree() -> String:
	return get_tree().root.get_tree_string_pretty()
	
