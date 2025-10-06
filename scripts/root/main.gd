extends Node2D

class_name Main

@onready var drawing_canvas: Node2D = $"Drawing Canvas"
@onready var drawing_hand: Node2D = $"Drawing Hand"
@onready var timer_hand: Node2D = $"Timer Hand"
@onready var mouse_cursor: Node2D = $"Mouse Cursor"
@onready var start_text: Control = $"GUI Control/Start Text"
@onready var gui_control: Control = $"GUI Control"
@onready var number_shadow: Label = $"GUI Control/Level/Number Shadow"
@onready var number_text: Label = $"GUI Control/Level/Number Text"

var canvas_position: Vector2i
var canvas_size: Vector2i
var stencil_ink: int

var image_data: Array[Color] = []

var init_drawing: bool = false

enum GameDifficulty {EASY = 2, MEDIUM = 1, HARD = 0}
enum GameState {IDLE, DRAWING}

static var game_state = GameState.IDLE
static var difficulty = GameDifficulty.EASY

func _ready() -> void:
	difficulty = GameData.difficulty
	AudioControl.game.play()
	canvas_position = drawing_canvas.canvas_position
	canvas_size = drawing_canvas.canvas_size
	stencil_ink = drawing_canvas.stencil_ink
	drawing_canvas.out_of_ink.connect(_out_of_ink)
	number_shadow.text = str(GameData.tt_number)
	number_text.text = str(GameData.tt_number)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mode"):
		if !init_drawing:
			init_drawing = true
			_start_drawing()
		if game_state == GameState.IDLE:
			gui_control.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
			AudioControl.machine.play()
			game_state = GameState.DRAWING
			drawing_hand.ready_up = false
			mouse_cursor.hide()
		elif game_state == GameState.DRAWING:
			gui_control.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
			AudioControl.machine.stop()
			game_state = GameState.IDLE
			mouse_cursor.show()

func _update_score() -> void:
	var ink = 0
	for x in range(canvas_position.x, canvas_position.x + canvas_size.x):
		for y in range(canvas_position.y, canvas_position.y + canvas_size.y):
			var stencil_tile = drawing_canvas.stencil_layer.get_cell_atlas_coords(Vector2i(x,y))
			var draw_tile = drawing_canvas.drawing_layer.get_cell_atlas_coords(Vector2i(x,y))
			if draw_tile == Vector2i(1,0):
				image_data.append(Color.BLACK)
				if stencil_tile == Vector2i(2,0):
					ink += 1
			else:
				image_data.append(Color.WHITE)
	var result: float = float(ink) / float(stencil_ink) * 100
	GameData.tt_number += 1
	GameData.image_data.clear()
	GameData.image_data = image_data.duplicate()
	GameData.last_match = int(floor(result))
	AudioControl.machine.stop()
	AudioControl.game.stop()
	game_state = GameState.IDLE
	SceneControl.change_scene("stats")
	print("Match %: ", result)

func _on_match_button_pressed() -> void:
	SceneControl.change_scene("stats")
	_update_score()

func _start_drawing() -> void:
	start_text.hide()
	timer_hand.total_timer.set_wait_time(drawing_canvas.total_time)
	timer_hand.total_timer.start()
	timer_hand.timer_on = true

func _on_total_timer_timeout() -> void:
	_update_score()

func _out_of_ink() -> void:
	_update_score()
