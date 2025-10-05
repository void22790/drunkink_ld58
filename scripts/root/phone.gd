extends Control

@onready var phone_time: Label = $"Phone Time"

func _process(_delta: float) -> void:
	var st = Time.get_time_string_from_system()
	phone_time.text = st.substr(0, 5)
