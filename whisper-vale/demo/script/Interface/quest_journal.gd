class_name QuestJournal extends Control

@onready var content: RichTextLabel = $text
const color := Color.GOLD
const outline_color := Color.DARK_GOLDENROD
const outline_size = 4
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QuestLead.emit_quest_update.connect(_on_quest_update)
	write_journal()
		
func _on_quest_update():
	write_journal()
	
func write_journal():
	content.clear()
	if (QuestLead.started_quests.size() > 0):
		content.push_bold()
		content.push_outline_color(outline_color)
		content.push_outline_size(outline_size)
		content.push_font_size(18)
		add_paragraph("Quest Journal")
		add_paragraph(" ")
		for quest in QuestLead.started_quests:
			write_quest(quest)
		
func write_quest(quest: QuestData):
	
	if (quest.completed):
		content.push_strikethrough(outline_color)
	content.push_font_size(16)
	content.push_bold()
	content.push_indent(2)
	add_paragraph(quest.get_description())
	
	for step in quest.quest_steps:
		if (quest.completed):
			content.push_strikethrough(outline_color)
		var status = "🗹" if step.completed else "☐"
		content.push_font_size(16)
		content.push_indent(4)
		add_paragraph(step.get_description(quest.tag) + " : " + status, HORIZONTAL_ALIGNMENT_RIGHT)

func add_paragraph(text:String, alignment:HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT):
	content.push_outline_color(outline_color)
	content.push_outline_size(outline_size)
	content.push_color(color)
	content.push_paragraph(alignment)
	content.append_text(text)
	content.pop_all()
