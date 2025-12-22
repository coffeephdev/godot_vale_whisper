extends Node

# Interface
@onready var fly_interface: fly_menu = null
@onready var camera:CameraController = null
@onready var player:Player = null
@onready var fly_posts = get_tree().get_nodes_in_group("fly_posts") as Array[fly_post]

# savegame
var save_path := "user://savegame.txt"

func get_nearest_fly_post(position:Vector3)-> fly_post:
	var nearest_point = {"point": null, "distance": Vector3.ZERO}
	for point in fly_posts:
		
		var distance:float = point.position.distance_to(position)
		if nearest_point.point == null:
			nearest_point.point = point
			nearest_point.distance = distance
		
		if distance < nearest_point.distance:
			nearest_point.point = point
			nearest_point.distance = distance
	return nearest_point.point
	
func _ready():
	for point in fly_posts:
		print("Fly found: ", point.flyname, (point.position))
		
	savegame()

func savegame():
	#C:\Users\Light\AppData\Roaming\Godot\app_userdata\Whisper-Vale
	var scene = get_tree().current_scene
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	var success = file.store_string(get_full_tree())
	ActivityLog.log_savegame(success)
	file.close()
	
func get_full_tree() -> String:
	return get_tree().root.get_tree_string_pretty()
