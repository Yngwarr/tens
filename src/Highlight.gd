class_name Highlight
extends Panel

signal sum_changed(sum: int)

@export var area: Area2D
@export var collider: CollisionShape2D

var sum: int = 0

func _physics_process(_delta: float) -> void:
    sum = 0

    for a in area.get_overlapping_areas():
        var parent = a.get_parent()
        if parent is NumberCell:
            sum += parent.value

    sum_changed.emit(sum)

func resize(rect: Rect2) -> void:
    size = rect.size
    position = rect.position

    collider.shape.size = rect.size - Vector2(8, 8)
    collider.position = rect.size / 2.

func toggle(on: bool) -> void:
    visible = on
