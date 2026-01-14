class_name CollectibleRespawn extends Collectible

@export_custom(PROPERTY_HINT_NONE, "suffix:minute(s)", PROPERTY_USAGE_DEFAULT) var refresh_cooldown: float = 0.2

@onready var refresh_cooldown_minutes = refresh_cooldown * 60

var cooldown := Timer.new()

func gathered() -> void:
	super()
	start_cooldown()
	
func _ready() -> void:
	super()
	setup_cooldown()

func start_cooldown():
	cooldown.start(refresh_cooldown_minutes)
	
func _timeout():
	is_collected = false
	set_collectible_state()
	
func setup_cooldown():
	self.add_child(cooldown)
	cooldown.timeout.connect(_timeout)
	cooldown.one_shot = true
