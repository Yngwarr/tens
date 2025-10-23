extends PopupPanel

@export var button_no: Button

func _ready() -> void:
	button_no.pressed.connect(on_pressed)
	
func on_pressed() -> void:
	hide()
