class_name NumberCell
extends Node2D

signal pressed(target: NumberCell)
signal moved_to(target: NumberCell)

@export var label: Label
@export var area: Area2D
@export var upper_limit: int = 9

var value: int

func _ready() -> void:
	area.input_event.connect(on_input)

	value = randi_range(1, upper_limit)
	label.text = str(value)
	label.modulate = Palette.color(value)

func on_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		if not event.pressed:
			return

		on_pressed()
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			on_moved()

func on_pressed() -> void:
	pressed.emit(self)

func on_moved() -> void:
	moved_to.emit(self)
