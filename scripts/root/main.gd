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
@onready var ink_bar: Control = $"GUI Control/Ink Bar"
@onready var end_run_button: Button = $"GUI Control/End Run Button"
@onready var clear_button: Button = $"GUI Control/Clear Button"

var canvas_position: Vector2i
var canvas_size: Vector2i
var stencil_ink: int

var image_data: Array[Color] = []

var init_drawing: bool = false

enum GameDifficulty {EASY = 2, MEDIUM = 1, HARD = 0}
enum GameState {IDLE, DRAWING}
enum GameType {DRUNK, FREE}

static var game_type = GameType.DRUNK
static var game_state = GameState.IDLE
static var difficulty = GameDifficulty.EASY

func _ready() -> void:
	_setup_type()
	difficulty = GameData.difficulty
	AudioControl.game.play()
	canvas_position = drawing_canvas.canvas_position
	canvas_size = drawing_canvas.canvas_size
	stencil_ink = drawing_canvas.stencil_ink
	drawing_canvas.out_of_ink.connect(_out_of_ink)
	number_shadow.text = str(GameData.tt_number)
	number_text.text = str(GameData.tt_number)

func _setup_type() -> void:
	game_type = GameData.type
	if game_type == GameType.FREE:
		ink_bar.hide()
		timer_hand.hide()
		drawing_canvas.cursor_reversed = false
		drawing_canvas.cursor_random = false
		drawing_canvas.cursor_weight = 0.2
		end_run_button.show()
		clear_button.show()
	if game_type == GameType.DRUNK:
		ink_bar.show()
		timer_hand.show()
		drawing_canvas.cursor_reversed = false
		drawing_canvas.cursor_random = true
		drawing_canvas.cursor_weight = GameData.cursor_weight
		end_run_button.hide()
		clear_button.hide()

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
	if Input.is_action_just_pressed("end"):
		AudioControl.game.stop()
		AudioControl.machine.stop()
		SceneControl.change_scene("menu")
		GameData.save_game()

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
	#print("Match %: ", result)

func _on_match_button_pressed() -> void:
	_update_score()

func _start_drawing() -> void:
	start_text.hide()
	if game_type == GameType.DRUNK:
		timer_hand.total_timer.set_wait_time(drawing_canvas.total_time)
		timer_hand.total_timer.start()
		timer_hand.timer_on = true

func _on_total_timer_timeout() -> void:
	_update_score()

func _out_of_ink() -> void:
	_update_score()

func _on_end_run_button_pressed() -> void:
	AudioControl.button.play()
	_update_score()
	GameData.save_game()

func _on_clear_button_pressed() -> void:
	AudioControl.button.play()
	drawing_canvas.clear_canvas()

func _on_ashtray_quit_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.game.stop()
	SceneControl.change_scene("menu")
