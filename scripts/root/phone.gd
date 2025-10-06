extends Control

@onready var phone_time: Label = $"Phone Time"
@onready var music_label: Label = $MusicButton/Label
@onready var sound_label: Label = $SoundButton/Label

func _process(_delta: float) -> void:
	var st = Time.get_time_string_from_system()
	phone_time.text = st.substr(0, 5)

func _on_sound_button_toggled(toggled_on: bool) -> void:
	var sound = AudioServer.get_bus_index("Sound")
	AudioServer.set_bus_mute(sound, toggled_on)
	if toggled_on:
		sound_label.add_theme_color_override("font_color", Color("#d1bfb0"))
		sound_label.text = "Sound off"
	else:
		sound_label.add_theme_color_override("font_color", Color("#7a9c96"))
		sound_label.text = "Sound on"

func _on_music_button_toggled(toggled_on: bool) -> void:
	var music = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music, toggled_on)
	if toggled_on:
		music_label.add_theme_color_override("font_color", Color("#d1bfb0"))
		music_label.text = "Music off"
	else:
		music_label.add_theme_color_override("font_color", Color("#7a9c96"))
		music_label.text = "Music on"
