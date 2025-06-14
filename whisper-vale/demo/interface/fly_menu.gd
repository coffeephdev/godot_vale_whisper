extends Control

func _ready() -> void:
	GameMaster.fly_menu = self
	self.hide()
