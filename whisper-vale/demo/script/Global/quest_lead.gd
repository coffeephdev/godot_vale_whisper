extends Node

@export_storage var started_quests: Array[Quest] = []
const quest_resource_path = "res://demo/data/quest/"

func _process(_delta: float) -> void:
	check_quests_completion()

func start_quest(quest: Quest):
	started_quests.append(quest)
	
func is_quest_step_completed(quest_tag:String, step_tag:String):
	for quest in started_quests:
		if (quest.tag != quest_tag):
			continue
			
		for step in quest.quest_steps:
			if (step.tag == step_tag):
				return step.completed
				
	return false
	
func notice_collected_item(resource:CollectibleResource):
	for quest in started_quests:
		for step in quest.quest_steps:
			if (step is not QuestStepItem || step.completed):
				continue
			
			step = step as QuestStepItem
			if (is_same(step.item_to_collect, resource)):
				print("Step Completed : " + step.description)
				step.completed = true

func start_quest_string(quest: String):
	var resource := load(quest_resource_path.path_join(quest) + ".tres") as Quest
	var quest_instance = resource.duplicate(true)
	
	start_quest(quest_instance)
	print("Started : " + quest_instance.description)

func check_quests_completion():
	for quest in started_quests:
		if quest.completed:
			continue
		
		if quest.quest_steps.all(func(step:QuestStep): return step.completed ):
			quest.completed = true
			print("Completed : " + quest.description)
