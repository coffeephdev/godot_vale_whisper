extends Node

@onready var fly_points:Array[fly_point] = get_tree().get_nodes_in_group("fly_points") as Array[fly_point]
@onready var fly_paths:Array[fly_path] = get_tree().get_nodes_in_group("fly_paths") as Array[fly_path]

func get_nearest_fly_point(position:Vector3)-> fly_point:
	var nearest_point = {"point": null, "distance": Vector3.ZERO}
	for point in fly_points:
		var distance:float = position.distance_to(point.position)
		if nearest_point.point == null:
			nearest_point.point = point
			nearest_point.distance = distance
		
		if distance < nearest_point.distance:
			nearest_point.point = point
			nearest_point.distance = distance
	return nearest_point.point
	

func _ready():
	
	for point in fly_points:
		print("Fly found: ", point.flyname, (point.position))
