class_name fly_path extends Path3D
@export var fly_speed = 5
@export_category("Fly Points")
@export var fly_point_1:fly_point = null
@export var fly_point_2:fly_point = null

@onready var path_name:StringName = fly_point_1.flyname + "-" + fly_point_2.flyname
@onready var path_follow: PathFollow3D = $PathFollow3D

var is_flying = false

func _process(delta: float) -> void:
	if is_flying:
		if path_follow.progress_ratio <= 0:
			is_flying = false
			path_follow.progress_ratio = 0
		if is_flying:
			path_follow.progress -= delta * fly_speed
