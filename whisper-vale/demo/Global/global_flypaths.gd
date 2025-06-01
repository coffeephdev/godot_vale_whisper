extends Node

@onready var fly_points = get_tree().get_nodes_in_group("fly_points") as Array[flyPoint]

func _ready():
	
	for point in fly_points:
		print("Fly found: ", point.flyname)
