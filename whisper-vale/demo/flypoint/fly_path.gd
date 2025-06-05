class_name fly_path extends Path3D
@export var fly_speed = 5
@export_category("Fly Points")

@export var close_fly_point:fly_point = null
@export var far_fly_point:fly_point = null

var path_name:StringName
@onready var path_follow: PathFollow3D = $PathFollow3D

var is_flying := false
var flying_body:Player = null
var invert_fly_direction := false

func _ready() -> void:
	var start_point_position = self.curve.get_point_position(0) + self.position
	var end_point_position = self.curve.get_point_position(self.curve.point_count - 1) + self.position
	
	close_fly_point = Flypaths.get_nearest_fly_point(start_point_position)
	far_fly_point = Flypaths.get_nearest_fly_point(end_point_position)

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
