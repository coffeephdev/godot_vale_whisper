class_name dialogue_interface extends MarginContainer

@onready var dialogue: RichTextLabel = $VBoxContainer/MarginContainer2/RichTextLabel
@onready var title:Label = $VBoxContainer/Control/Label

var current_dialogue: DialogueManager.DialogueLine = null

func _ready() -> void:
	DialogueLead.dialogue_window = self
	hide_dialogue()

func hide_dialogue():
	clear_responses()
	dialogue.text = ""
	title.text = ""
	current_dialogue = null
	hide()
	
func show_dialogue():
	clear_responses()
	title.text = current_dialogue.character
	dialogue.text = current_dialogue.text
	
	build_responses()
	show()
	
func build_responses():
	if current_dialogue.responses.size() > 0:
		for response in current_dialogue.responses:
			var button = Button.new()
			button.text = response.response
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			%responses.add_child(button)
	elif current_dialogue.next_id != null:
		pass
		# NEED TO IMPLEMENT THE BALLOON DIALOGUE
func clear_responses():
	for button:Button in %responses.get_children():
		button.queue_free()
		%responses.remove_child(button)
