class_name Hint
extends Panel

func appear(hint: Vector4) -> void:
    var x := hint.x - Game.CELL_SIZE / 2.
    var y := hint.y - Game.CELL_SIZE / 2.
    var w := hint.z + Game.CELL_SIZE / 2. - x
    var h := hint.w + Game.CELL_SIZE / 2. - y
    var rect := Rect2(x, y, w, h)

    size = rect.size
    position = rect.position

    show()

func disappear() -> void:
    hide()
