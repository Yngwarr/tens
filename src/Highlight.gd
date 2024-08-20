class_name Highlight
extends Panel

signal sum_changed(sum: int)

@export var area: Area2D
@export var collider: CollisionShape2D
@export var resize_sfx: AudioStreamPlayer
@export var clear_sfx: AudioStreamPlayer
@export var fail_sfx: AudioStreamPlayer

var sum: int = 0

func _physics_process(_delta: float) -> void:
    sum = 0

    for a in area.get_overlapping_areas():
        var parent = a.get_parent()
        if parent is NumberCell:
            sum += parent.value

    sum_changed.emit(sum)

func resize(rect: Rect2) -> void:
    if size == rect.size and position == rect.position:
        return

    size = rect.size
    position = rect.position

    collider.shape.size = rect.size - Vector2(8, 8)
    collider.position = rect.size / 2.

    resize_sfx.play()

func toggle(on: bool) -> void:
    visible = on
    if on:
        resize_sfx.play()
    else:
        collider.shape.size = Vector2.ZERO
        collider.global_position = Vector2.ZERO

func clear() -> int:
    var amount: int = 0

    for a in area.get_overlapping_areas():
        var parent = a.get_parent()

        if not parent is NumberCell:
            continue
        if parent.value == 0:
            continue

        parent.remove()
        amount += 1

    clear_sfx.play()

    return amount

func fail() -> void:
    fail_sfx.play()
