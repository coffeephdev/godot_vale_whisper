class_name Collectible extends Node3D

@export var resource: CollectibleResource
@export var is_collected := false

@onready var active_mesh: Node3D = get_node("active")
@onready var inactive_mesh: Node3D = get_node("inactive")

var area3D := Area3D.new()

func gathered() -> void:
	ActivityLog.log_collectible(resource.name)
	is_collected = true
	set_collectible_state()
	
func _ready() -> void:
	setup_area3D()
	set_collectible_state()

func set_collectible_state():
	if (is_collected):
		QuestLead.notice_collected_item(resource)
		active_mesh.hide()
		inactive_mesh.show()
		area3D.set_deferred("monitoring", false)
	else:
		active_mesh.show()
		inactive_mesh.hide()
		area3D.set_deferred("monitoring", true)
	
func setup_area3D():
	var shape = CylinderShape3D.new()
	shape.height = 10
	shape.radius = 3
	
	var collision = CollisionShape3D.new()
	collision.shape = shape
	
	area3D.monitorable = false
	area3D.add_child(collision)
	area3D.set_collision_mask_value(1, false)
	area3D.set_collision_mask_value(2, true)
	
	self.add_child(area3D)
	area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D) -> void:
	gathered()
