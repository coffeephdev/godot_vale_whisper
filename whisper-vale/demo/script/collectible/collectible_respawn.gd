class_name CollectibleRespawn extends Collectible

@export var refresh_cooldown: float = 0.2

@onready var refresh_cooldown_minutes = refresh_cooldown * 60

var cooldown := Timer.new()

func _on_gathered() -> void:
	QuestLead.notice_collected_item(resource)
	start_cooldown()
	set_collectible_inactive()
	
func _ready() -> void:
	setup_area3D()
	setup_cooldown()
	set_collectible_active()

func start_cooldown():
	cooldown.start(refresh_cooldown_minutes)
	
func _timeout():
	set_collectible_active()
	
func setup_cooldown():
	self.add_child(cooldown)
	cooldown.timeout.connect(_timeout)
	cooldown.one_shot = true
	
func _on_body_entered(_body: Node3D) -> void:
	gathered.emit()
