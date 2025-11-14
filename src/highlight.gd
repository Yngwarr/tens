class_name Highlight
extends Panel

signal sum_changed(sum: int)

@export var silent := false

@export_group("Internal")
@export var area: Area2D
@export var collider: CollisionShape2D
@export var resize_sfx: AudioStreamPlayer
@export var clear_sfx: AudioStreamPlayer
@export var fail_sfx: AudioStreamPlayer

var sum: int = 0
var resize_base_pitch: float


func _ready() -> void:
	resize_base_pitch = resize_sfx.pitch_scale


func _physics_process(_delta: float) -> void:
	var new_sum: int = 0

	for a in area.get_overlapping_areas():
		var parent = a.get_parent()
		if parent is NumberCell and parent.visible:
			new_sum += parent.value

	if new_sum != sum:
		sum = new_sum
		sum_changed.emit(sum)


func resize(rect: Rect2) -> void:
	if size == rect.size and position == rect.position:
		return

	size = rect.size
	position = rect.position

	collider.shape.size = rect.size - Vector2(8, 8)
	collider.position = rect.size / 2.

	resize_sfx.pitch_scale = Tools.random_pitch(resize_base_pitch, .1)
	play_sfx(resize_sfx)


func toggle(on: bool) -> void:
	visible = on
	if on:
		resize_sfx.pitch_scale = Tools.random_pitch(resize_base_pitch, .1)
		play_sfx(resize_sfx)
	else:
		collider.shape.size = Vector2.ZERO
		collider.global_position = Vector2.ZERO


func clear() -> int:
	var amount: int = 0

	for a in area.get_overlapping_areas():
		var parent = a.get_parent()

		if not parent is NumberCell:
			continue
		if not parent.visible:
			continue
		if parent.value == 0:
			continue

		parent.remove()
		amount += 1

	play_sfx(clear_sfx)

	return amount


func fail() -> void:
	play_sfx(fail_sfx)


func play_sfx(effect: AudioStreamPlayer) -> void:
	if silent:
		return

	effect.play()
