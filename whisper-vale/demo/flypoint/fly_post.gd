class_name fly_post extends Node3D

@export var flyname: StringName
var flyname_offset = Vector3(5, -8, 0)

var available_fly_roads := [] as Array[fly_road]

func _ready() -> void:
	setup_label()
	
func setup_label():
	var fly_label := Label3D.new()
	fly_label.font_size = 64
	fly_label.text = flyname
	add_child(fly_label)
	fly_label.translate(Vector3(0, flyname_offset.x, flyname_offset.y))
	
func get_first_fly_post() -> fly_post:
	var first_road = available_fly_roads[0]
	if first_road.close_fly_post.flyname != self.flyname:
		return first_road.close_fly_post 
	else:
		return first_road.far_fly_post
	
	
func find_road(next_fly_name:StringName)-> fly_road:
	if available_fly_roads.size() <= 0:
		return
		
	var current_point := self.flyname
	var next_point := next_fly_name
	var path_road: fly_road = available_fly_roads.filter(func(path:fly_road):
		return (( path.close_fly_post.flyname == current_point ||
		 	path.far_fly_post.flyname == current_point ) &&
			( path.close_fly_post.flyname == next_point ||
		 	path.far_fly_post.flyname == next_point ))
		)[0]
	
	return path_road
	
func _on_interact_area_body_entered(player: Player) -> void:
	GameMaster.fly_menu.show()
	return
	var nextFly := get_first_fly_post()
	var road := find_road(nextFly.flyname)
	if road == null || road.is_flying :
		return
		
	print("Fly from ", [self.flyname], " to ", [nextFly.flyname])
	road.start_fly(player, nextFly)
		

func _on_interact_area_body_exited(body: Node3D) -> void:
	GameMaster.fly_menu.hide()
