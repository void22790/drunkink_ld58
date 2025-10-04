extends Node2D

@onready var stencil_layer: TileMapLayer = $"Stencil Layer"
@onready var drawing_layer: TileMapLayer = $"Drawing Layer"
@onready var cursor_layer: TileMapLayer = $"Cursor Layer"

var time: float

var canvas_size = Vector2i(128, 128)
var canvas_position: Vector2
var canvas_rect: Rect2i

var tt_path = "res://graphics/tattoo/tt_test.png"
var stencil_data: Array[Color]
var stencil_ink: int

var ink_amount: int = 10

var cursor_raw_pos: Vector2
var cursor_pos: Vector2i
var base_pos: Vector2
@export var cursor_reversed = true
@export var cursor_random = true
var horiz_speed = 1.5
var vert_speed = 1.2
var cursor_amp = 20.0
var cursor_weight = 0.1

var last_cursor_position : Vector2i

func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	base_pos = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	canvas_position = Vector2((viewport_size.x - canvas_size.x) / 2, (viewport_size.y - canvas_size.y) / 2)
	canvas_rect = Rect2i(canvas_position, canvas_size)
	_get_stencil_data()
	_draw_stencil()

func _process(delta: float) -> void:
	time += delta
	var mouse_position = get_viewport().get_mouse_position()
	
	cursor_pos = _update_cursor(mouse_position, time)
	
	if Main.game_state == Main.GameState.DRAWING:
		#_draw_cursor(cursor_pos)
		if Input.is_action_pressed("select"):
			if canvas_rect.has_point(cursor_pos) and ink_amount > 0:
				drawing_layer.set_cell(cursor_pos, 0, Vector2i(1,0))
				ink_amount -= 1

func _get_stencil_data() -> void:
	var texture: Texture2D = load(tt_path)
	var image: Image = texture.get_image()
	var ink = 0
	for x in image.get_width():
		for y in image.get_height():
			var color = image.get_pixel(x,y)
			stencil_data.append(color)
			if color == Color.BLACK:
				ink += 1
	stencil_ink = ink
	ink_amount = (10 * ink) + (ink * 10 * Main.difficulty)

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
