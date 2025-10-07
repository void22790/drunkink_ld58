extends Node

var image: Image

var sound_on: bool = true
var music_on: bool = true

var difficulty: Main.GameDifficulty
var type: Main.GameType

var last_match: int = 0
var tt_number: int = 0

var cursor_amp: float = 20.0
var cursor_weight: float = 0.05

var time_mp: float = 0.0
var ink_mp: float = 0.0

var image_data: Array[Color] = []

var tattoos: PackedStringArray = [
	"res://graphics/tattoo/tt_bee.png",
	"res://graphics/tattoo/tt_bunny.png",
	"res://graphics/tattoo/tt_cat.png",
	"res://graphics/tattoo/tt_fish.png",
	"res://graphics/tattoo/tt_heart.png",
	"res://graphics/tattoo/tt_star.png",
	"res://graphics/tattoo/tt_beer.png",
	"res://graphics/tattoo/tt_candy.png",
	"res://graphics/tattoo/tt_cherry.png",
	"res://graphics/tattoo/tt_crystal.png",
	"res://graphics/tattoo/tt_dice.png",
	"res://graphics/tattoo/tt_eye.png",
	"res://graphics/tattoo/tt_gamer.png",
	"res://graphics/tattoo/tt_ghost.png",
	"res://graphics/tattoo/tt_girl.png",
	"res://graphics/tattoo/tt_love.png",
	"res://graphics/tattoo/tt_milk.png",
	"res://graphics/tattoo/tt_patch.png",
	"res://graphics/tattoo/tt_pattern.png",
	"res://graphics/tattoo/tt_piglet.png",
	"res://graphics/tattoo/tt_rose.png"
]

var save_path: String = "user://drunkink_save.json"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_game()

func save_game():
	var save_data = {
	"tattoos": tt_number,
	"music": music_on,
	"sound": sound_on,
	"amp": cursor_amp,
	"weight": cursor_weight,
	"time": time_mp,
	"ink": ink_mp
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved: ", save_data)
	else:
		push_error("Unable to open a save file.")

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var text = file.get_as_text()
			var data = JSON.parse_string(text)
			file.close()
			if typeof(data) == TYPE_DICTIONARY:
				tt_number = data.get("tattoos", 0)
				music_on = data.get("music", true)
				sound_on = data.get("sound", true)
				cursor_amp = data.get("amp", 20.0)
				cursor_weight = data.get("weight", 0.05)
				time_mp = data.get("time", 0.0)
				ink_mp = data.get("ink", 0.0)
			else:
				push_error("Unable to read save data. Wrong save format.")
		else:
			push_error("Unable to read save data. Can't open save file.")
