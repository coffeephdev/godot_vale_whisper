extends Node3D

@export_group("Visibility Range")
@export var near_visibility := 3.0
@export var far_visibility := 15.0

@export_group("Timer")
@export var always_show := true
@export var display_time := 5

@onready var label:Label3D = $Label
@onready var timer:Timer = $Timer

const margin := 0.34

func _ready() -> void:
	set_text("hello fren")
	setup_visibility_range()
	
	timer.timeout.connect(timer_reached)

func timer_reached():
	print("timer reached")
	if visible:
		hide_text()
	else:
		display_text()

func hide_text() -> void:
	self.hide()
	
func setup_visibility_range():
	label.visibility_range_begin = near_visibility
	label.visibility_range_end = far_visibility
	label.visibility_range_begin_margin = margin
	label.visibility_range_end_margin = margin
	
func _physics_process(_delta: float) -> void:
	look_at(get_viewport().get_camera_3d().global_position)

func display_text():
	self.show()
	if not always_show:
		timer.start(display_time)
	
func set_text(new_text:String):
	label.text = new_text
