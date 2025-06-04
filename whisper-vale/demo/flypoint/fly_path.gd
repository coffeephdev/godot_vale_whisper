class_name fly_path extends Path3D
@export var fly_speed = 5
@export_category("Fly Points")
@export var fly_point_1:fly_point = null
@export var fly_point_2:fly_point = null

@onready var path_name:StringName = fly_point_1.flyname + "-" + fly_point_2.flyname
@onready var path_follow: PathFollow3D = $PathFollow3D

var is_flying := false
var flying_body:Player = null
var invert_fly_direction := false
	
func _process(delta: float) -> void:
	if is_flying:
		update_fly(delta)
			
func start_fly (body:Player):
	is_flying = true
	flying_body = body
	flying_body.can_move = false
	flying_body.reparent(path_follow)
	flying_body.position = Vector3(0,0,0)
	
func update_fly(delta:float):
	if path_follow.progress_ratio <= 0:
		stop_fly()
	if is_flying:
		path_follow.progress -= delta * fly_speed

func stop_fly():
	is_flying = false
	path_follow.progress = 0
	flying_body.can_move = true
	flying_body.reparent(get_tree().root)
	flying_body = null
