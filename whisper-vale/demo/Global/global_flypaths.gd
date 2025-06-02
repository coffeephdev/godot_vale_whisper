extends Node

@onready var fly_points = get_tree().get_nodes_in_group("fly_points") as Array[fly_point]
@onready var fly_paths = get_tree().get_nodes_in_group("fly_paths") as Array[fly_path]

func _ready():
	
	for point in fly_points:
		print("Fly found: ", point.flyname, (point.position))
