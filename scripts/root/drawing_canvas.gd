extends Node2D

@onready var stencil_layer: TileMapLayer = $"Stencil Layer"
@onready var drawing_layer: TileMapLayer = $"Drawing Layer"
@onready var cursor_layer: TileMapLayer = $"Cursor Layer"

var canvas_size = Vector2i(200, 200)
var canvas_position: Vector2
var canvas_rect: Rect2i

var tt_path = "res://graphics/tattoo/tt_test.png"
var stencil_data: Array[Color]

var last_cursor_position : Vector2i

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var viewport_size = get_viewport().get_visible_rect().size
	canvas_position = Vector2((viewport_size.x - canvas_size.x) / 2, (viewport_size.y - canvas_size.y) / 2)
	canvas_rect = Rect2i(canvas_position, canvas_size)
	_get_stencil_data()
	_draw_stencil()

func _process(_delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var cursor_position = drawing_layer.local_to_map(mouse_position)
	#print("mouse position: ", mouse_position)
	#print("cursor position: ", cursor_position)
	
	_draw_cursor(cursor_position)
	
	if Input.is_action_pressed("select"):
		if canvas_rect.has_point(cursor_position):
			drawing_layer.set_cell(mouse_position, 0, Vector2i(1,0))

func _get_stencil_data() -> void:
	var texture: Texture2D = load(tt_path)
	var image: Image = texture.get_image()
	for x in image.get_width():
		for y in image.get_height():
			stencil_data.append(image.get_pixel(x,y))

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

func _draw_cursor(pos: Vector2i) -> void:
	cursor_layer.set_cell(pos, 0, Vector2i(1,0))
	if last_cursor_position != pos:
		cursor_layer.erase_cell(last_cursor_position)
	last_cursor_position = pos
