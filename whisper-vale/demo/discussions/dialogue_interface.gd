class_name dialogue_interface extends MarginContainer

@onready var dialogue: RichTextLabel = $VBoxContainer/MarginContainer2/RichTextLabel
@onready var title:Label = $VBoxContainer/Control/Label

var current_dialogue: Dialogue = null

func _ready() -> void:
	GameMaster.dialogue = self
	hide_dialogue()

func hide_dialogue():
	dialogue.text = ""
	title.text = ""
	current_dialogue = null
	hide()
	
func show_dialogue(mob_name: StringName, mob_dialogue: Dialogue):
	title.text = mob_name
	dialogue.text = mob_dialogue.dialogue
	show()
