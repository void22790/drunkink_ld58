extends Node2D

var total_score: int
var image: Image
@onready var score_amount: Label = $"Control/HBoxContainer/Score Amount"
@onready var result_sprite: Sprite2D = $"Result Sprite"
@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	_create_image()
	total_score = 0

func _process(_delta: float) -> void:
	if total_score != GameData.last_match:
		total_score += 1
	score_amount.text = str(total_score).pad_zeros(8)

func _on_next_button_pressed() -> void:
	SceneControl.change_scene("main")

func _create_image() -> void:
	image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	
	for y in 128:
		for x in 128:
			var index = y * 128 + x
			image.set_pixel(x,y, GameData.image_data[index])
	
	image.rotate_90(ClockDirection.CLOCKWISE)
	image.flip_x()
	
	var texture = ImageTexture.create_from_image(image)
	result_sprite.texture = texture

func _on_collect_button_pressed() -> void:
	pass
