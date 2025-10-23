class_name Hint
extends Panel

enum TweenDir { LEFT, RIGHT, UP, DOWN }

var initial_scale: Vector2

func _ready() -> void:
	initial_scale = scale

func appear(hint: Vector4) -> void:
	var x := hint.x - Game.CELL_SIZE / 2.
	var y := hint.y - Game.CELL_SIZE / 2.
	var w := hint.z + Game.CELL_SIZE / 2. - x
	var h := hint.w + Game.CELL_SIZE / 2. - y
	var rect := Rect2(x, y, w, h)

	var direction: TweenDir = (
		[TweenDir.LEFT, TweenDir.RIGHT, TweenDir.UP, TweenDir.DOWN].pick_random()
	)

	match direction:
		TweenDir.LEFT:
			size = Vector2(0, rect.size.y)
			position = Vector2(rect.position.x + rect.size.x, rect.position.y)
		TweenDir.RIGHT:
			size = Vector2(0, rect.size.y)
			position = rect.position
		TweenDir.UP:
			size = Vector2(rect.size.x, 0)
			position = Vector2(rect.position.x, rect.position.y + rect.size.y)
		TweenDir.DOWN:
			size = Vector2(rect.size.x, 0)
			position = rect.position

	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "size", rect.size, .5)
	tween.set_parallel(true)
	tween.tween_property(self, "position", rect.position, .5)
	tween.set_parallel(false)
	tween.tween_callback(update_pivot)

	show()


func disappear() -> void:
	hide()


func bounce() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), .25)
	tween.tween_property(self, "scale", initial_scale, .25)


func update_pivot() -> void:
	pivot_offset = size / 2
