extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.position = get_viewport().get_mouse_position()

func _process(_delta: float) -> void:
	sprite_2d.position = get_viewport().get_mouse_position()
