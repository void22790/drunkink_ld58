extends Node2D

@onready var drawing_canvas: Node2D = $"../Drawing Canvas"
@onready var sprite_2d: Sprite2D = $Sprite2D

var init_pos = Vector2(300.0, 400.0)
var distance: float = 5.0
var ready_up: bool = false

func _ready() -> void:
	sprite_2d.position = init_pos

func _process(_delta: float) -> void:
	if Main.game_state == Main.GameState.IDLE:
		sprite_2d.position = lerp(sprite_2d.position, init_pos, 0.05)
	elif Main.game_state == Main.GameState.DRAWING:
		var target = drawing_canvas.cursor_layer.map_to_local(drawing_canvas.cursor_pos)
		if !ready_up:
			sprite_2d.position = lerp(sprite_2d.position, target, 0.2)
			if sprite_2d.position.distance_to(target) < distance:
				sprite_2d.position = target
				ready_up = true
		else:
			sprite_2d.position = drawing_canvas.cursor_layer.map_to_local(drawing_canvas.cursor_pos)
