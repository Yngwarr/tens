class_name Grid
extends Node2D

signal highlight_changed(rect: Rect2)
signal grabbed
signal released

@export var inner_node: PackedScene
@export var front_layer: CanvasLayer
@export_range(0, 100) var width: int = 16
@export_range(0, 100) var height: int = 11
@export var appear_timer: Timer

var first_point := Vector2.ZERO
var second_point := Vector2.ZERO
var step: int = Game.CELL_SIZE
var appear_step: int = 0

func _ready() -> void:
    for y in range(height):
        for x in range(width):
            var node := inner_node.instantiate() as Node2D
            node.position.x = step * x - step * width / 2.
            node.position.y = step * y - step * height / 2.
            node.front_layer = front_layer
            node.pressed.connect(on_cell_pressed)
            node.moved_to.connect(on_cell_moved)
            add_child(node)

func _input(event: InputEvent) -> void:
    if not event is InputEventMouseButton:
        return
    if event.pressed:
        return

    on_released()

func on_cell_pressed(cell: NumberCell) -> void:
    var pos := cell.global_position
    first_point = pos
    second_point = pos
    update_highlight()
    grabbed.emit()

func on_released() -> void:
    released.emit()

func on_cell_moved(cell: NumberCell) -> void:
    var pos := cell.global_position
    second_point = pos
    update_highlight()

func update_highlight() -> void:
    var left_point: Vector2
    var right_point: Vector2

    if first_point.x <= second_point.x && first_point.y <= second_point.y:
        # print("2")
        left_point = first_point
        right_point = second_point
    elif first_point.x > second_point.x && first_point.y <= second_point.y:
        # print("3")
        left_point = Vector2(second_point.x, first_point.y)
        right_point = Vector2(first_point.x, second_point.y)
    elif first_point.x <= second_point.x && first_point.y > second_point.y:
        # print("1")
        left_point = Vector2(first_point.x, second_point.y)
        right_point = Vector2(second_point.x, first_point.y)
    else:
        # print("4")
        left_point = second_point
        right_point = first_point

    var x := left_point.x - Game.CELL_SIZE / 2.
    var y := left_point.y - Game.CELL_SIZE / 2.
    var w := right_point.x + Game.CELL_SIZE / 2. - x
    var h := right_point.y + Game.CELL_SIZE / 2. - y

    var rect := Rect2(x, y, abs(w), abs(h))

    highlight_changed.emit(rect)

func appear() -> void:
    appear_timer.timeout.connect([
        appear_down,
        appear_left
    ].pick_random())
    appear_timer.start()

func appear_down() -> void:
    if appear_step == height:
        appear_timer.stop()
        return

    var start := appear_step * width
    var end := start + width

    for i in range(start, end):
        get_child(i).appear()

    appear_step += 1

func appear_left() -> void:
    if appear_step == width:
        appear_timer.stop()
        return

    for i in range(appear_step, height * width, width):
        get_child(i).appear()

    appear_step += 1
