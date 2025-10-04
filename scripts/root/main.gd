extends Node2D

class_name Main

@onready var drawing_canvas: Node2D = $"Drawing Canvas"
@onready var drawing_hand: Node2D = $"Drawing Hand"
@onready var mouse_cursor: Node2D = $"Mouse Cursor"

var canvas_position: Vector2i
var canvas_size: Vector2i
var stencil_ink: int

enum GameState {IDLE, DRAWING}

static var game_state = GameState.IDLE

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	canvas_position = drawing_canvas.canvas_position
	canvas_size = drawing_canvas.canvas_size
	stencil_ink = drawing_canvas.stencil_ink

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mode"):
		if game_state == GameState.IDLE:
			game_state = GameState.DRAWING
			drawing_hand.ready_up = false
			mouse_cursor.hide()
		elif game_state == GameState.DRAWING:
			game_state = GameState.IDLE
			mouse_cursor.show()

func _on_match_button_pressed() -> void:
	var ink = 0
	for x in range(canvas_position.x, canvas_position.x + canvas_size.x):
		for y in range(canvas_position.y, canvas_position.y + canvas_size.y):
			var stencil_tile = drawing_canvas.stencil_layer.get_cell_atlas_coords(Vector2i(x,y))
			var draw_tile = drawing_canvas.drawing_layer.get_cell_atlas_coords(Vector2i(x,y))
			if draw_tile == Vector2i(1,0):
				if stencil_tile == Vector2i(2,0):
					ink += 1
	var result: float = float(ink) / float(stencil_ink) * 100
	print("Match %: ", result)
