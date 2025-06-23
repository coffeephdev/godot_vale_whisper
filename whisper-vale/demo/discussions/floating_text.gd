extends Node3D

@onready var label:Label3D = $Label

const tween_delay := 0.2

func _physics_process(_delta: float) -> void:
	look_at(get_viewport().get_camera_3d().global_position)
	
func hide_text() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0,0,0), tween_delay)
	tween.tween_callback(hide).set_delay(tween_delay)

func display_text():
	var tween = create_tween()
	tween.tween_callback(show)
	tween.tween_property(self, "scale", Vector3(1,1,1), tween_delay)
	
func set_text(new_text:String):
	label.text = new_text
