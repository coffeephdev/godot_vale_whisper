extends Node3D

@export_group("Timer")
@export var display_time := 7
@export var hide_time := 10

@onready var label:Label3D = $Label
@onready var timer:Timer = $Timer

const margin := 0.34

func _ready() -> void:
	set_text("hello fren")
	timer.timeout.connect(timer_reached)

func _physics_process(_delta: float) -> void:
	look_at(get_viewport().get_camera_3d().global_position)
	
func timer_reached():
	timer.stop()
	handle_text()
	
func handle_text():
	if not timer.is_stopped():
		return
	
	if visible:
		hide_text()
	else:
		display_text()

func hide_text() -> void:
		self.hide()
		timer.start(hide_time)

func display_text():
	self.show()
	timer.start(display_time)
	
func set_text(new_text:String):
	label.text = new_text
