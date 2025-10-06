extends Node2D

@onready var stencil_layer: TileMapLayer = $"Stencil Layer"
@onready var drawing_layer: TileMapLayer = $"Drawing Layer"
@onready var cursor_layer: TileMapLayer = $"Cursor Layer"

signal out_of_ink
var has_ink:bool = true

var time: float

var viewport_size
var canvas_size = Vector2i(128, 128)
var canvas_position: Vector2
var canvas_rect: Rect2i

var tt_path: String
var stencil_data: Array[Color]
var stencil_ink: int

var ink_amount: int = 10
var max_ink_amount: int
var total_time: float
var time_factor: float = 50.0

var cursor_raw_pos: Vector2
var cursor_pos: Vector2i
var base_pos: Vector2
@export var cursor_reversed = true
@export var cursor_random = true
var horiz_speed = 1.5
var vert_speed = 1.2
var cursor_amp = GameData.cursor_amp
var cursor_weight = 0.2

var last_cursor_position : Vector2i

func _ready() -> void:
	tt_path = GameData.tattoos[randi_range(0,GameData.tattoos.size() - 1)]
	viewport_size = get_viewport().get_visible_rect().size
	base_pos = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	canvas_position = Vector2((viewport_size.x - canvas_size.x) / 2, (viewport_size.y - canvas_size.y) / 2)
	canvas_rect = Rect2i(canvas_position, canvas_size)
	if GameData.type == Main.GameType.DRUNK:
		_get_stencil_data()
		_draw_stencil()
	if GameData.type == Main.GameType.FREE:
		_draw_empty_canvas()

func _process(delta: float) -> void:
	time += delta
	if ink_amount <= 0 and has_ink:
		has_ink = false
		out_of_ink.emit()
	var mouse_position = get_viewport().get_mouse_position()
	if Main.game_state == Main.GameState.DRAWING:
		if mouse_position.x < 85.0:
			mouse_position.x = 85.0
		elif mouse_position.x > 235.0:
			mouse_position.x = 235.0
		if mouse_position.y < 14.0:
			mouse_position.y = 14.0
		elif mouse_position.y > 163.0:
			mouse_position.y = 163.0
	cursor_pos = _update_cursor(mouse_position, time)
	AudioControl.machine.pitch_scale = 1.0
	if Main.game_state == Main.GameState.DRAWING:
		#_draw_cursor(cursor_pos)
		if Input.is_action_pressed("select"):
			if canvas_rect.has_point(cursor_pos) and ink_amount > 0:
				AudioControl.machine.pitch_scale = 0.95
				drawing_layer.set_cell(cursor_pos, 0, Vector2i(1,0))
				if GameData.type == Main.GameType.DRUNK:
					ink_amount -= 1

func _get_stencil_data() -> void:
	var texture: Texture2D = load(tt_path)
	var image: Image = texture.get_image()
	var ink: float = 0
	for x in image.get_width():
		for y in image.get_height():
			var color = image.get_pixel(x,y)
			stencil_data.append(color)
			if color == Color.BLACK:
				ink += 1
	stencil_ink = int(ink)
	ink_amount = (int(ink) * GameData.difficulty) / 3 + int(ink) + GameData.ink_mp
	total_time = (ink * GameData.difficulty + ink * 2 + GameData.time_mp) / time_factor
	max_ink_amount = ink_amount
	print(ink_amount)

func _draw_empty_canvas() -> void:
	for x in range(canvas_position.x, canvas_position.x + canvas_size.x):
		for y in range(canvas_position.y, canvas_position.y + canvas_size.y):
			stencil_layer.set_cell(Vector2i(x,y), 0, Vector2i(0,0))

func _draw_stencil() -> void:
	if stencil_data.is_empty():
		return
	var count = 0
	for x in range(canvas_position.x, canvas_position.x + canvas_size.x):
		for y in range(canvas_position.y, canvas_position.y + canvas_size.y):
			if stencil_data[count] == Color.BLACK:
				stencil_layer.set_cell(Vector2i(x,y), 0, Vector2i(2,0))
			elif stencil_data[count] == Color.WHITE:
				stencil_layer.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
			count += 1

func _update_cursor(pos: Vector2, t: float) -> Vector2i:
	var offset: Vector2 = pos - base_pos
	if cursor_random:
		var rand_x = sin(t * horiz_speed) * cursor_amp
		var rand_y = cos(t * vert_speed) * cursor_amp
		offset += Vector2(rand_x, rand_y)
	if cursor_reversed:
		offset *= -1
	cursor_raw_pos = lerp(cursor_raw_pos, base_pos + offset, cursor_weight)
	var cursor_position = drawing_layer.local_to_map(cursor_raw_pos)
	return cursor_position

func _draw_cursor(pos: Vector2i) -> void:
	cursor_layer.set_cell(pos, 0, Vector2i(1,0))
	if last_cursor_position != pos:
		cursor_layer.erase_cell(last_cursor_position)
	last_cursor_position = pos
