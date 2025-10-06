extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var save_button: Button = $"Control/HBoxContainer/Save Button"
@onready var image_name: LineEdit = $ImageName

func _on_end_button_pressed() -> void:
	AudioControl.button.play()
	AudioControl.stats.stop()
	SceneControl.change_scene("menu")

func _on_save_button_pressed() -> void:
	AudioControl.button.play()
	if line_edit.text == "":
		return
	if image_name.text == "":
		return
	if not GameData.image:
		return
	var path = line_edit.text.strip_edges()
	var iname = image_name.text.strip_edges()
	path += "/"+ iname + ".png"
	GameData.image.save_png(path)

func _on_next_button_pressed() -> void:
	AudioControl.button.play()
	if GameData.type == Main.GameType.FREE:
		AudioControl.stats.stop()
		SceneControl.change_scene("main")
	if GameData.type == Main.GameType.DRUNK:
		SceneControl.change_scene("upgrade")
