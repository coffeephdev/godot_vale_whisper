class_name Mob extends CharacterBody3D

@export var mob_name:StringName = ""

@export_category("Dialogues")
@export var dialogue: Resource = null

@export_category("Whispers")
@export var whispers: Array[String] = []
@export var whisper_distance := 20

@export_subgroup("Whisper Timer")
@export var display_time := 5
@export var hide_time := 20


@onready var timer:Timer = $Timer

@onready var has_whispers := whispers.size() > 0
@onready var has_dialogue := dialogue != null

var whisper_index = null

func _ready() -> void:
	if has_whispers:
		setup_whispers()

func _process(_delta: float) -> void:
	if has_whispers:
		handle_whispers()
	
func setup_whispers():
	timer.timeout.connect(timer_reached)
	
func handle_whispers():
	if (GameLead.player.position.distance_to(self.position) < whisper_distance):
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
	pass

func hide_whisper():
	pass
	
func show_whisper():
	pass
