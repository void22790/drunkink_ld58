extends Node2D

@onready var description: Label = $Control/Description

func _on_ink_button_mouse_entered() -> void:
	description.text = "Increase ink amount"

func _on_ink_button_mouse_exited() -> void:
	description.text = ""

func _on_time_button_mouse_entered() -> void:
	description.text = "Increase time amount"

func _on_time_button_mouse_exited() -> void:
	description.text = ""

func _on_steady_button_mouse_entered() -> void:
	description.text = "Stabilize the cursor"

func _on_steady_button_mouse_exited() -> void:
	description.text = ""

func _on_speed_button_mouse_entered() -> void:
	description.text = "Increase cursor speed"

func _on_speed_button_mouse_exited() -> void:
	description.text = ""

func _on_ink_button_pressed() -> void:
	AudioControl.button.play()
	GameData.ink_mp += 200
	AudioControl.stats.stop()
	SceneControl.change_scene("main")

func _on_time_button_pressed() -> void:
	AudioControl.button.play()
	GameData.time_mp += 200
	AudioControl.stats.stop()
	SceneControl.change_scene("main")

func _on_steady_button_pressed() -> void:
	AudioControl.button.play()
	var amp = GameData.cursor_amp
	amp += 0.05
	amp = clamp(amp, 0.05, 0.2)
	GameData.cursor_amp = amp
	AudioControl.stats.stop()
	SceneControl.change_scene("main")

func _on_speed_button_pressed() -> void:
	AudioControl.button.play()
	var weight = GameData.cursor_weight
	weight -= 4.0
	weight = clamp(weight, 0.0, 20.0)
	GameData.cursor_weight = weight
	AudioControl.stats.stop()
	SceneControl.change_scene("main")
