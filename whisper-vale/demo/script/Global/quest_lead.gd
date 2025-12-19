extends Node

@export_storage var started_quests: Array[Quest] = []
const quest_resource_path = "res://demo/data/quest/"

func _process(_delta: float) -> void:
	check_quests_completion()

func start_quest(quest_string: String) -> void:
	var quest = get_quest_instance_from_string(quest_string)
	started_quests.append(quest)
	print("Started : " + quest.description)
	
func is_quest_step_completed(quest_tag:String, step_tag:String) -> bool:
	for quest in started_quests:
		if (quest.tag != quest_tag):
			continue
			
		for step in quest.quest_steps:
			if (step.tag == step_tag):
				return step.completed
				
	return false
	
func is_quest_started(quest_tag:String) -> bool:
	return started_quests.any(func(quest:Quest): 
		return quest.tag == quest_tag)
	
func notice_collected_item(resource:CollectibleResource) -> void:
	for quest in started_quests:
		for step in quest.quest_steps:
			if (step is not QuestStepItem || step.completed):
				continue
			
			step = step as QuestStepItem
			if (is_same(step.item_to_collect, resource)):
				print("Step Completed : " + step.description)
				step.completed = true

func check_quests_completion() -> void:
	for quest in started_quests:
		if quest.completed:
			continue
		
		if quest.quest_steps.all(func(step:QuestStep): return step.completed ):
			quest.completed = true
			print("Completed : " + quest.description)
			
func get_quest_instance_from_string(quest_string:String):
	var resource := load(quest_resource_path.path_join(quest_string) + ".tres") as Quest
	return resource.duplicate(true)
