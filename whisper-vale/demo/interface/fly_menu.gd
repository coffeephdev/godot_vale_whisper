class_name fly_menu extends Control

@onready var flying_body: Player = null

func display_menu(player:Player, roads: Array[fly_road], start_point: fly_post):
	show()
	flying_body = player
	for road in roads:
		var button = Button.new()
		var destination := (road.far_fly_post
							if road.close_fly_post.flyname.contains(start_point.flyname)
							else road.close_fly_post)
		print(destination.flyname)
		button.text = destination.flyname
		button.button_down.connect(_button_pressed.bind(road, destination))
		$fly_points.add_child(button)
		
func hide_menu():
	flying_body = null
	for button in $fly_points.get_children():
		$fly_points.remove_child(button)
		button.queue_free()
	hide()

func _ready() -> void:
	GameMaster.fly_interface = self
	hide()

func _button_pressed(road: fly_road, destination: fly_post) -> void:
	road.start_fly(flying_body, destination)
