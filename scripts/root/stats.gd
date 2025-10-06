extends Node2D

var image: Image
var stars_to_show: int = 0
var count: int = 0

@onready var result_sprite: Sprite2D = $"Result Sprite"
@onready var level_up_timer: Timer = $"Level Up Timer"

@onready var star: Sprite2D = $Stars/Star
@onready var star_2: Sprite2D = $Stars/Star2
@onready var star_3: Sprite2D = $Stars/Star3

func _ready() -> void:
	AudioControl.stats.play()
	_create_image()
	if GameData.last_match > 0 and GameData.last_match <= 20:
		stars_to_show = 1
	elif GameData.last_match > 20 and GameData.last_match <= 50:
		stars_to_show = 2
	elif GameData.last_match > 50:
		stars_to_show = 3

func _on_next_button_pressed() -> void:
	AudioControl.button.play()
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

func _on_level_up_timer_timeout() -> void:
	match stars_to_show:
		1:
			star.show()
		2:
			if count == 0:
				star.show()
				count += 1
				level_up_timer.start(0.5)
			elif count == 1:
				star_2.show()
		3:
			if count == 0:
				star.show()
				count += 1
				level_up_timer.start(0.5)
			elif count == 1:
				star_2.show()
				count += 1
				level_up_timer.start(0.5)
			elif count == 2:
				star_3.show()

func _on_end_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.stats.stop()
	SceneControl.change_scene("menu")
