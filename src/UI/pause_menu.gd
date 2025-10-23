class_name PauseMenu
extends CanvasLayer

## Your average pause menu you can use to rage quit the game, go outside and
## touch some grass.

signal resume_pressed

@export var resume_button: Button
@export var fader: CanvasLayer
@export var pause_menu: VBoxContainer


func _ready() -> void:
	resume_button.pressed.connect(on_resume_pressed)

	resume_button.grab_focus()


func on_resume_pressed() -> void:
	resume_pressed.emit()


func pause() -> void:
	fader.visible = true
	show()
	resume_button.grab_focus()


func unpause() -> void:
	fader.visible = false
	hide()
