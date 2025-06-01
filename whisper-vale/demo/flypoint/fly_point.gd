class_name flyPoint extends Node3D

@export var flyname: StringName
var flyname_offset = Vector2(5,-8)

func _ready() -> void:
	setup_label()
	
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
	
func fly(body: Node3D, landing_position: Vector3):
	teleport(body, landing_position)

func _on_interact_area_body_entered(body: Node3D) -> void:
	var nextFly = get_first_fly_point()
	print("TP to [", nextFly.flyname, "] from [", flyname, "]")
	fly(body, nextFly.position)
	

#func _on_interact_area_body_exited(body: Node3D) -> void:
