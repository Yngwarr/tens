class_name TutorialHand
extends Sprite2D


func _ready() -> void:
	hide()


func drag(p1: Vector2, p2: Vector2) -> void:
	var start_scale := scale
	var start_rotation := rotation_degrees

	modulate = Color.TRANSPARENT
	global_position = p1
	show()

	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, .5)
	tween.tween_property(self, "rotation_degrees", start_rotation - 10, .5)
	tween.parallel().tween_property(self, "scale", start_scale * .8, .5)
	tween.tween_property(self, "global_position", p2, 1)
	tween.tween_property(self, "rotation_degrees", start_rotation, .5)
	tween.parallel().tween_property(self, "scale", start_scale, .5)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .5)
	tween.tween_callback(hide)
