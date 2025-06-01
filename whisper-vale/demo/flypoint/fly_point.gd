class_name flyPoint extends Node3D

@export var flyname: StringName

var flyname_offset = Vector3(5, -8, 0)

var is_flying = false
var flying_progress = 0
var flying_body: Node3D = null
var landing_position = Vector3(0,0,0)

func _ready() -> void:
	setup_label()
	
func _physics_process(delta: float) -> void:
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
	
func get_first_fly_point() -> Node3D:
	return Flypaths.fly_points.filter(func(fly): return fly.flyname != flyname)[0]
	
func teleport(body: Node3D, landing_position: Vector3):
	body.position = landing_position
	
func start_fly(body: Node3D, landing_position: Vector3):
	
	is_flying = true
	flying_body = body
	landing_position = landing_position
	print("Fly from", [flying_body.position], " to ", [landing_position])
	
func update_fly(delta:float):
	flying_progress += delta
	flying_body.position = flying_body.position.lerp(landing_position, 1)
	
func stop_fly():
	print("Fly Complete, new position: ", flying_body.position)
	is_flying = false
	flying_progress = 0
	landing_position = Vector3(0,0,0)
	flying_body = null
	
	
func _on_interact_area_body_entered(body: Node3D) -> void:
	var nextFly = get_first_fly_point()
	start_fly(body, nextFly.position)
	

#func _on_interact_area_body_exited(body: Node3D) -> void:
