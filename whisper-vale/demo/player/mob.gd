class_name Mob extends CharacterBody3D

@export var mob_name:StringName = ""

@export_category("Whispers")
@export var whispers: Array[String] = []
@export var whisper_distance := 20

@export_subgroup("Whisper Timer")
@export var display_time := 5
@export var hide_time := 20

@export_category("Dialogues")
@export var dialogues: Array[Dialogue] = []

@onready var timer:Timer = $Timer
@onready var floating_text = $FloatingText

@onready var has_whispers := whispers.size() > 0
@onready var has_dialogues := dialogues.size() > 0

var whisper_index = null

func _ready() -> void:
	if has_whispers:
		setup_whispers()

func _process(_delta: float) -> void:
	if has_whispers:
		handle_whispers()
	
func setup_whispers():
	timer.timeout.connect(timer_reached)
	floating_text.set_text(whispers[0])
	
func handle_whispers():
	if (GameMaster.player.position.distance_to(self.position) < whisper_distance):
		update_whispers()
	else:
		if timer.is_stopped():
			return
			
		hide_whisper()
		timer.stop()
		
func timer_reached():
	timer.stop()
	update_whispers()
	
func update_whispers():
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
