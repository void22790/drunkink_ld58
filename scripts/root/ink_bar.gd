extends Control

@onready var drawing_canvas: Node2D = $"../../Drawing Canvas"

@onready var progress_bar: ProgressBar = $ProgressBar

func _process(_delta: float) -> void:
	var amount: float = float(drawing_canvas.ink_amount) / float(drawing_canvas.max_ink_amount) * 100.0
	progress_bar.value = amount
