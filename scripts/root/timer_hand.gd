extends Node2D

@onready var drawing_canvas: Node2D = $"../Drawing Canvas"

@onready var total_timer: Timer = $"Total Timer"
@onready var cigarette: Sprite2D = $Cigarette
@onready var light: Sprite2D = $Light
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var init_light_posy: float
var timer_on: bool = false

func _ready() -> void:
	init_light_posy = light.position.y

func _process(_delta: float) -> void:
	if timer_on:
		animation_player.play("smoking")
		var time_progress = 1.0 - total_timer.time_left / drawing_canvas.total_time
		var delta = floor(time_progress * 28.0)
		cigarette.material.set("shader_parameter/cut_value", delta)
		light.position.y = init_light_posy + delta

func _on_start_button_pressed() -> void:
	total_timer.set_wait_time(drawing_canvas.total_time)
	total_timer.start()
	timer_on = true
