extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var scenes = {
"main": "res://scenes/root/main.tscn",
"stats": "res://scenes/root/stats.tscn",
"menu": ""
}

func change_scene(scene_name: String) -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scenes[scene_name])
	await get_tree().scene_changed
	animation_player.play("fade_out")
