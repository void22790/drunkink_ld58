extends Node2D

@onready var main_menu: Control = $MainMenu
@onready var drunk_mode: Control = $"Drunk Mode"
@onready var options: Control = $Options
@onready var sound_button: Button = $"Options/VBoxContainer/Sound Button"
@onready var music_button: Button = $"Options/VBoxContainer/Music Button"

func _ready() -> void:
	AudioControl.menu.play()
	if GameData.sound_on == false:
		sound_button.button_pressed = true
	if GameData.music_on == false:
		music_button.button_pressed = true

func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("end"):
		get_tree().quit()

func _on_drunk_mode_button_pressed() -> void:
	AudioControl.button.play()
	main_menu.hide()
	drunk_mode.show()

func _on_back_from_dm_button_pressed() -> void:
	AudioControl.button.play()
	main_menu.show()
	drunk_mode.hide()

func _on_easy_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.menu.stop()
	GameData.difficulty = Main.GameDifficulty.EASY
	GameData.type = Main.GameType.DRUNK
	GameData.cursor_amp = 10.0
	GameData.cursor_weight = 0.1
	SceneControl.change_scene("main")

func _on_medium_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.menu.stop()
	GameData.difficulty = Main.GameDifficulty.MEDIUM
	GameData.type = Main.GameType.DRUNK
	GameData.cursor_amp = 15.0
	GameData.cursor_weight = 0.05
	SceneControl.change_scene("main")

func _on_hard_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.menu.stop()
	GameData.difficulty = Main.GameDifficulty.HARD
	GameData.type = Main.GameType.DRUNK
	GameData.cursor_amp = 20.0
	GameData.cursor_weight = 0.05
	SceneControl.change_scene("main")

func _on_options_button_pressed() -> void:
	AudioControl.button.play()
	main_menu.hide()
	options.show()

func _on_back_options_button_pressed() -> void:
	AudioControl.button.play()
	main_menu.show()
	options.hide()

func _on_sound_button_toggled(toggled_on: bool) -> void:
	var sound = AudioServer.get_bus_index("Sound")
	AudioServer.set_bus_mute(sound, toggled_on)
	if toggled_on:
		GameData.sound_on = false
		sound_button.text = "Sound Off"
	else:
		GameData.sound_on = true
		sound_button.text = "Sound On"
	AudioControl.button.play()

func _on_music_button_toggled(toggled_on: bool) -> void:
	var music = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music, toggled_on)
	if toggled_on:
		GameData.music_on = false
		music_button.text = "Music Off"
	else:
		GameData.music_on = true
		music_button.text = "Music On"
	AudioControl.button.play()

func _on_quit_button_pressed() -> void:
	GameData.save_game()
	get_tree().quit()

func _on_freestyle_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.menu.stop()
	GameData.type = Main.GameType.FREE
	SceneControl.change_scene("main")

func _on_score_button_pressed() -> void:
	AudioControl.button.play()
	GameData.tt_number = 0

func _on_upgrades_button_pressed() -> void:
	AudioControl.button.play()
	GameData.cursor_amp = 20.0
	GameData.cursor_weight = 0.05
	GameData.time_mp = 0.0
	GameData.ink_mp = 0.0
