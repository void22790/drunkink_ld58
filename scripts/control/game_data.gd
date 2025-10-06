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

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
