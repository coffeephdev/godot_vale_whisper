class_name fly_point extends Node3D

@export var flyname: StringName

var flyname_offset = Vector3(5, -8, 0)

var is_flying = false
var flying_progress = 0
var flying_body: Node3D = null
var starting_position = Vector3(0,0,0)
var landing_position = Vector3(0,0,0)

func _ready() -> void:
	setup_label()
	
func _process(delta: float) -> void:
	if !is_flying:
		return
		
	if flying_progress >= 1:
		stop_fly()
		return
		
	update_fly(delta)
	
func setup_label():
	var fly_label = Label3D.new()
	fly_label.font_size = 64
	fly_label.text = flyname
	add_child(fly_label)
	fly_label.translate(Vector3(0, flyname_offset.x, flyname_offset.y))
	
func get_first_fly_point() -> fly_point:
	return Flypaths.fly_points.filter(func(fly:fly_point): return fly.flyname != flyname)[0]
	
func find_road(next_fly_name:StringName)-> fly_path:
	var current_point = self.flyname
	var next_point = next_fly_name
	var path_road: fly_path = Flypaths.fly_paths.filter(func(path:fly_path):
		return (( path.fly_point_1.flyname == current_point ||
		 	path.fly_point_2.flyname == current_point ) &&
			( path.fly_point_1.flyname == next_point ||
		 	path.fly_point_2.flyname == next_point ))
		)[0]
	
	print("Fly from ", [current_point], " to ", [next_point], " via ", [path_road.path_name], " road")
	return path_road
	
func start_fly(body: Node3D, new_position: Vector3):
	is_flying = true
	flying_body = body
	starting_position = body.position
	landing_position = new_position
	
func update_fly(delta:float):
	flying_progress += delta
	flying_body.position = starting_position.lerp(landing_position, flying_progress)
	
func stop_fly():
	is_flying = false
	flying_progress = 0
	starting_position = Vector3(0,0,0)
	landing_position = Vector3(0,0,0)
	flying_body = null
	
func _on_interact_area_body_entered(body: CharacterBody3D) -> void:
	var nextFly = get_first_fly_point()
	var fly_road = find_road(nextFly.flyname)
	body.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	body.reparent(fly_road.path_follow)
	fly_road.is_flying = true
	#start_fly(body, nextFly.position)

#func _on_interact_area_body_exited(body: Node3D) -> void:
