extends Node

var sound_on: bool = true
var music_on: bool = true

var difficulty: Main.GameDifficulty

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
	"res://graphics/tattoo/tt_star.png"
]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
