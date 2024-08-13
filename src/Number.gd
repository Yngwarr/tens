class_name NumberCell
extends Node2D

signal pressed(target: NumberCell)
signal moved_to(target: NumberCell)

@export var label: Label
@export var area: Area2D
@export var view: Node2D
@export var anim: AnimationPlayer

var upper_limit: int = Game.TARGET_SUM - 1
var value: int
var selected := false
var velocity := Vector2.ZERO
var front_layer: CanvasLayer

func _ready() -> void:
	area.input_event.connect(on_input)
	area.area_entered.connect(on_area_entered)
	area.area_exited.connect(on_area_exited)

	value = randi_range(1, upper_limit)
	label.text = str(value)
	label.modulate = Palette.color(value)

func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		return
	if view.position.y >= 2000:
		return

	view.position += velocity * delta * 20
	velocity.y += 9.8 * delta * 20

func on_area_entered(other: Area2D) -> void:
	var parent := other.get_parent()
	if not parent is Highlight:
		return

	bounce()

func on_area_exited(other: Area2D) -> void:
	var parent := other.get_parent()
	if not parent is Highlight:
		return

	unbounce()

func on_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		if event.pressed:
			on_pressed()

	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			on_moved()

func on_pressed() -> void:
	pressed.emit(self)

func on_moved() -> void:
	moved_to.emit(self)

func remove() -> void:
	var pos := view.global_position
	remove_child(view)
	front_layer.add_child(view)
	view.global_position = pos
	value = 0

	velocity = Vector2(randi_range(-30, 30), -20 + randi_range(-10, 10))

func bounce() -> void:
	if selected:
		return

	anim.play(&"selected")
	selected = true

func unbounce() -> void:
	if not selected:
		return

	anim.play_backwards(&"selected")
	selected = false
