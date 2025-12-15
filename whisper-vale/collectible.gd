class_name Collectible extends Node3D

@export var refresh_cooldown: int = 5

@onready var active_mesh: Node3D = get_node("active")
@onready var inactive_mesh: Node3D = get_node("inactive")

var cooldown := Timer.new()
var area3D := Area3D.new()

signal gathered

func _on_gathered() -> void:
	start_cooldown()
	set_collectible_inactive()
	
func _ready() -> void:
	setup_area3D()
	setup_cooldown()
	
	set_collectible_active()

func start_cooldown():
	cooldown.start(refresh_cooldown)
	
func _timeout():
	set_collectible_active()
	
func set_collectible_active():
	active_mesh.show()
	inactive_mesh.hide()
	area3D.set_deferred("monitoring", true)
	
func set_collectible_inactive():
	active_mesh.hide()
	inactive_mesh.show()
	area3D.set_deferred("monitoring", false)
	
func setup_area3D():
	var shape = CylinderShape3D.new()
	shape.height = 10
	shape.radius = 3
	
	var collision = CollisionShape3D.new()
	collision.shape = shape
	
	area3D.monitorable = false
	area3D.monitoring = false
	area3D.add_child(collision)
	
	self.add_child(area3D)
	area3D.body_entered.connect(_on_body_entered)

func setup_cooldown():
	self.add_child(cooldown)
	cooldown.timeout.connect(_timeout)
	cooldown.one_shot = true
	
func _on_body_entered(_body: Node3D) -> void:
	gathered.emit()
