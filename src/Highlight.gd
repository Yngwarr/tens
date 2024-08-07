class_name Highlight
extends Panel

@export var collider: CollisionShape2D

func resize(rect: Rect2) -> void:
    size = rect.size
    position = rect.position

    collider.shape.size = rect.size
    collider.position = rect.size / 2.
    # collider.position = rect.position
