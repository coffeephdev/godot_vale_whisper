extends Node
var quest_list: Array[QuestData] = []
var quest_resources: Array[Quest] = []
var started_quests: Array[QuestData] = []
var completed_quests: Array[QuestData] = []

signal emit_quest_update

const quest_resource_path = "res://demo/data/quest/"
const seconds_before_ending_quest = 6

func _ready() -> void:
	build_quest_list()
	SaveLead.add_to_register(self)
	
func _process(_delta: float) -> void:
	check_quests_completion()

func start_quest(quest_tag: String) -> void:
	var id := quest_list.find_custom(func(quest:QuestData): return quest.tag == quest_tag)
	var quest_data = quest_list.get(id)
	started_quests.append(quest_data)
	emit_quest_update.emit()
	ActivityLog.log_quest("Quest Started", quest_data)
	
func is_quest_step_completed(quest_tag:String, step_tag:String) -> bool:
	for quest in started_quests:
		if (quest.tag != quest_tag):
			continue
			
		for step in quest.quest_steps:
			if (step.tag == step_tag):
				return step.completed
				
	return false
	
func is_quest_started_or_completed(quest_tag:String) -> bool:
	var is_started = is_quest_started(quest_tag)
	var is_completed = is_quest_completed(quest_tag)
	return is_started || is_completed
	
func is_quest_completed(quest_tag:String) -> bool:
	return completed_quests.any(func(quest:QuestData): 
		return quest.tag == quest_tag)
		
func is_quest_started(quest_tag:String) -> bool:
	return started_quests.any(func(quest:QuestData): 
		return quest.tag == quest_tag)
		
func notice_collected_item(resource:CollectibleResource) -> void:
	for quest in started_quests:
		for step in quest.quest_steps:
			if (step is not QuestStepItemData || step.completed):
				continue
			
			step = step as QuestStepItemData
			if (is_same(step.item_to_collect, resource)):
				step.completed = true
				ActivityLog.log_quest_step("Step Completed", step)
				emit_quest_update.emit()
				
func set_quest_step_complete(quest_tag:String, quest_step_tag:String) -> void:
	var quest_step = get_started_quest_step(quest_tag, quest_step_tag) as QuestStepData
	if (quest_step == null || quest_step.completed):
		return
		
	quest_step.completed = true
	ActivityLog.log_quest_step("Step Completed", quest_step)
	emit_quest_update.emit()

func check_quests_completion() -> void:
	for quest in started_quests:
		if quest.completed:
			completed_quests.append(quest)
			started_quests.erase(quest)
			get_tree().create_timer(seconds_before_ending_quest).timeout.connect(_on_completed_quest)
			continue
		
		if quest.quest_steps.all(func(step:QuestStepData): return step.completed ):
			quest.completed = true
			ActivityLog.log_quest("Quest Completed", quest)
			emit_quest_update.emit()
			
func _on_completed_quest():
	emit_quest_update.emit()
	
func build_quest_list() -> void:
	var resource_folder := DirAccess.open(quest_resource_path)
	for file_name in resource_folder.get_files():
		var file_path := quest_resource_path.path_join(file_name)
		var resource = load(file_path) as Quest
		quest_resources.append(resource)
		
		var quest_data = QuestData.new()
		quest_data.populate(resource)
		quest_list.append(quest_data)
		
func get_started_quest(quest_tag: String) -> QuestData:
	var id = started_quests.find_custom(func(quest:QuestData):
		return quest.tag == quest_tag)
	return started_quests[id]
		
func get_started_quest_step(quest_tag: String, quest_step_tag: String) -> QuestStepData:
	var quest = get_started_quest(quest_tag)
	var id = quest.quest_steps.find_custom(func(quest_step:QuestStepData):
		return quest_step.tag == quest_step_tag)
	return quest.quest_steps[id]
	
func get_quest_description(quest_tag:String) -> String:
	var id = quest_resources.find_custom(func(quest:Quest):return quest.tag == quest_tag)
	return quest_resources[id].description
	
func get_quest_step_description(quest_tag:String, step_tag:String) -> String:
	var quest_id = quest_resources.find_custom(func(quest:Quest):return quest.tag == quest_tag)
	var step_id = quest_resources[quest_id].quest_steps.find_custom(func(quest_step:QuestStep):return quest_step.tag == step_tag)
	return quest_resources[quest_id].quest_steps[step_id].description
