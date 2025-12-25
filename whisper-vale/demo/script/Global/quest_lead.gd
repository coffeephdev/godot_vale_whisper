extends Node
var quest_list: Array[QuestData] = []

var started_quests: Array[QuestData] = []
var completed_quests: Array[QuestData] = []
const quest_resource_path = "res://demo/data/quest/"

func _ready() -> void:
	build_quest_list()
	SaveLead.add_to_register(self)
	
func _process(_delta: float) -> void:
	check_quests_completion()

func start_quest(quest_tag: String) -> void:
	var id := quest_list.find_custom(func(quest:QuestData): return quest.tag == quest_tag)
	var quest = quest_list.get(id)
	started_quests.append(quest)
	ActivityLog.log_quest("Started", quest)
	
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
	return completed_quests.any(func(quest:Quest): 
		return quest.tag == quest_tag)
		
func is_quest_started(quest_tag:String) -> bool:
	return started_quests.any(func(quest:Quest): 
		return quest.tag == quest_tag)
		
func notice_collected_item(resource:CollectibleResource) -> void:
	for quest in started_quests:
		for step in quest.quest_steps:
			if (step is not QuestStepItemData || step.completed):
				continue
			
			step = step as QuestStepItemData
			if (is_same(step.item_to_collect, resource)):
				ActivityLog.log_quest_step("Step Completed", step)
				step.completed = true
				
func set_quest_step_complete(quest_tag:String, quest_step_tag:String) -> void:
	var quest_step = get_started_quest_step(quest_tag, quest_step_tag) as QuestStepData
	if (quest_step == null || quest_step.completed):
		return
		
	ActivityLog.log_quest_step("Step Completed", quest_step)
	
	quest_step.completed = true

func check_quests_completion() -> void:
	for quest in started_quests:
		if quest.completed:
			continue
		
		if quest.quest_steps.all(func(step:QuestStep): return step.completed ):
			quest.completed = true
			completed_quests.append(quest)
			started_quests.erase(quest)
			ActivityLog.log_quest("Quest Completed", quest)
			
func build_quest_list() -> void:
	var resource_folder = DirAccess.open(quest_resource_path)
	for file in resource_folder:
		var resource = file as Quest
		var quest = QuestData.new(resource)
		quest_list.append(quest)
		
func get_started_quest(quest_tag: String) -> QuestData:
	var id = started_quests.find_custom(func(quest:Quest):
		return quest.tag == quest_tag)
	return started_quests[id]
		
func get_started_quest_step(quest_tag: String, quest_step_tag: String) -> QuestStepData:
	var quest = get_started_quest(quest_tag)
	var id = quest.quest_steps.find_custom(func(quest_step:QuestStep):
		return quest_step.tag == quest_step_tag)
	return quest.quest_steps[id]
