extends Node

# gérer le trigger des whisper
# enregistrer les npc avec des whisper pour les gérer
# gérer le nombre de whispers en cours
# pouvoir cacher les dialogues et les whispers en cas de cinématique par ex.
# checker la distance entre le player et les mobs avant de trigger
var whisper_pool = []
var active_speaker:Mob = null
const SPEAKER_DISTANCE = 110

func _process(_delta: float) -> void:
	active_speaker_checker()
	
func start_dialogue(mob: Mob):
	active_speaker = mob
	DialogueManager.show_dialogue_balloon(active_speaker.dialogue)
	
func active_speaker_checker():
	if not active_speaker:
		return
		
	# if GameLead.player.global_position.distance_to(active_speaker.global_position) > SPEAKER_DISTANCE:
	# 	active_speaker = null
