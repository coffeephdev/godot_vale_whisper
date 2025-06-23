class_name mob extends CharacterBody3D

@export_group("Whispers")
@export var whispers: Array[String] = []
@export var whisper_distance := 20

@export_subgroup("Whisper Timer")
@export var display_time := 5
@export var hide_time := 20

@onready var timer:Timer = $Timer
@onready var floating_text = $FloatingText

var whisper_index = null

func _ready() -> void:
	timer.timeout.connect(timer_reached)
	floating_text.set_text(whispers[0])

func _process(_delta: float) -> void:
	if (GameMaster.player.position.distance_to(self.position) < whisper_distance):
		handle_whispers()
	else:
		if timer.is_stopped():
			return
			
		hide_whisper()
		timer.stop()
		
func timer_reached():
	timer.stop()
	handle_whispers()
	
func handle_whispers():
	if not timer.is_stopped():
		return
	
	if floating_text.visible:
		hide_whisper()
		timer.start(hide_time)
	else:
		show_whisper()
		timer.start(display_time)

func hide_whisper():
	floating_text.hide_text()
	
func show_whisper():
	if whisper_index == null || whisper_index >= whispers.size() - 1:
		whisper_index = 0
	else:
		whisper_index = whisper_index+1
		
	floating_text.set_text(whispers[whisper_index])
	floating_text.display_text()
