class_name QuestJournal extends Control

@onready var content: RichTextLabel = $text
const color:Color = Color.GOLD
	
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
		add_paragraph("Quest Journal", HORIZONTAL_ALIGNMENT_CENTER)
		add_paragraph(" ")
		content.pop()
		for quest in QuestLead.started_quests:
			write_quest(quest)
		
func write_quest(quest: QuestData):
	if (quest == null):
		return
	content.push_bold()
	add_paragraph(quest.tag)
	content.pop()
	
	for step in quest.quest_steps:
		var status = "🗹" if step.completed else "☐"
		add_paragraph("    " + step.tag + " : " + status, HORIZONTAL_ALIGNMENT_RIGHT)

func add_paragraph(text:String, alignment:HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT):
	content.push_color(color)
	content.push_paragraph(alignment)
	content.append_text(text)
	content.pop()
	content.pop()
