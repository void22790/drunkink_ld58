extends Node2D

@onready var drawing_canvas: Node2D = $"Drawing Canvas"

var canvas_position: Vector2i
var canvas_size: Vector2i
var stencil_ink: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_position = drawing_canvas.canvas_position
	canvas_size = drawing_canvas.canvas_size
	stencil_ink = drawing_canvas.stencil_ink

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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
