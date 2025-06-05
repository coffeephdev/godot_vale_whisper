class_name fly_point extends Node3D

@export var flyname: StringName
var flyname_offset = Vector3(5, -8, 0)

var available_fly_paths := [] as Array[fly_path]

func _ready() -> void:
	setup_label()
	
func setup_label():
	var fly_label := Label3D.new()
	fly_label.font_size = 64
	fly_label.text = flyname
	add_child(fly_label)
	fly_label.translate(Vector3(0, flyname_offset.x, flyname_offset.y))
	
func get_first_fly_point() -> fly_point:
	return Flypaths.fly_points.filter(func(fly:fly_point): return fly.flyname != flyname)[0]
	
func find_road(next_fly_name:StringName)-> fly_path:
	var current_point := self.flyname
	var next_point := next_fly_name
	var path_road: fly_path = Flypaths.fly_paths.filter(func(path:fly_path):
		return (( path.close_fly_point.flyname == current_point ||
		 	path.far_fly_point.flyname == current_point ) &&
			( path.close_fly_point.flyname == next_point ||
		 	path.far_fly_point.flyname == next_point ))
		)[0]
	
	return path_road
	
func _on_interact_area_body_entered(player: Player) -> void:
	var nextFly := get_first_fly_point()
	var fly_road := find_road(nextFly.flyname)
	if not fly_road.is_flying:
		print("Fly from ", [self.flyname], " to ", [nextFly.flyname])
		fly_road.start_fly(player, nextFly)
		

#func _on_interact_area_body_exited(body: Node3D) -> void:
