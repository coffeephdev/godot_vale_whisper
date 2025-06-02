class_name fly_path extends Path3D

@export_category("Fly Points")
@export var fly_point_1:fly_point = null
@export var fly_point_2:fly_point = null

@onready var path_name:StringName = fly_point_1.flyname + "-" + fly_point_2.flyname
@onready var path_follow: PathFollow3D = $PathFollow3D

func _ready() -> void:
	pass
