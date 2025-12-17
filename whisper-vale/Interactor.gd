class_name Interactor extends Area3D

@export var interact_button: Node3D = null
@export_storage var nearest_contact : Node3D = null

var contact_list : Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_interactor_entered)
	self.body_exited.connect(_on_interactor_exited)
	var player:Player = get_parent()
	player.interactor = self
	
func _process(_delta: float) -> void:
	var contact = get_nearest_contact()
	if (contact):
		interact_button.show()
		interact_button.global_position = contact.global_position
		interact_button.position.y += 2.5
	else:
		interact_button.hide()
	
func _physics_process(_delta: float) -> void:
	self.global_rotation.y = GameLead.camera.global_rotation.y + PI

func _on_interactor_entered(body: Node3D):
	contact_list.append(body)
	
func _on_interactor_exited(body: Node3D):
	contact_list.erase(body)
	
func get_nearest_contact() -> Node3D:
	if (contact_list.is_empty()):
		return null
		
	var previous_data = { "previous_contact" : null }
		
	for contact in contact_list:
		if !(contact is Mob && contact.has_dialogue): 
			continue
			
		var current_distance = self.global_position.distance_squared_to(contact.global_position)
		
		if (!previous_data.has("previous_distance") || previous_data.get("previous_distance") > current_distance):
			previous_data.set("previous_contact", contact)
			previous_data.set("previous_distance", current_distance)
	
	return previous_data.get("previous_contact")
