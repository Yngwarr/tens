@tool
class_name NumberCell
extends Node2D

signal pressed(target: NumberCell, pretend: bool)
signal moved_to(target: NumberCell, pretend: bool)

const FALL_SPEED_MULTIPLIER = 1
const BOUNCED_SCALE = .8

@export var frame: Sprite2D
@export var cell: Sprite2D
@export var label: Label
@export var area: Area2D
@export var view: Node2D
@export var anim: AnimationPlayer

var value: int
var selected := false
var velocity := Vector2.ZERO
var front_layer: CanvasLayer


func _ready() -> void:
	if not Engine.is_editor_hint():
		area.input_event.connect(on_input)
		area.area_entered.connect(on_area_entered)
		area.area_exited.connect(on_area_exited)
		hide()


func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		return

	if view.position.y >= 2000:
		view.hide()
		return

	view.position += velocity * delta * 20 * FALL_SPEED_MULTIPLIER
	velocity.y += 9.8 * delta * 20 * FALL_SPEED_MULTIPLIER


func on_area_entered(other: Area2D) -> void:
	var parent := other.get_parent()

	if not parent is Highlight:
		return

	if parent.silent:
		return

	bounce()


func on_area_exited(other: Area2D) -> void:
	var parent := other.get_parent()

	if not parent is Highlight:
		return

	if parent.silent:
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


func on_pressed(pretend := false) -> void:
	pressed.emit(self, pretend)


func on_moved(pretend := false) -> void:
	moved_to.emit(self, pretend)


func set_value(x: int) -> void:
	value = x

	if value == 0:
		view.visible = false
		return

	label.text = str(value)
	label.modulate = Palette.color(value)
	frame.modulate = Palette.color(value)


func remove() -> void:
	if value == 0:
		return

	var pos := view.global_position
	remove_child(view)
	front_layer.add_child(view)
	view.global_position = pos
	value = 0

	velocity = Vector2(randi_range(-30, 30), -20 + randi_range(-10, 10))


func bounce() -> void:
	if selected:
		return

	selected = true

	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(cell, "scale", Vector2.ONE * BOUNCED_SCALE, .2)


func unbounce() -> void:
	if not selected:
		return

	selected = false

	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(cell, "scale", Vector2.ONE, .2)


func appear() -> void:
	if visible:
		return

	anim.play(&"appear")


func reset(p_value: int) -> void:
	velocity = Vector2.ZERO
	set_value(p_value)

	front_layer.remove_child(view)
	add_child(view)

	view.position = Vector2.ZERO
	view.show()
	unbounce()
