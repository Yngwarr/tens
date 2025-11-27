class_name Tutorial
extends CanvasLayer

const GRID_TIMEOUT := .2

@export_group("Internal")
@export var grid: Grid
@export var quit_button: Button
@export var ok_button: Button
@export var highlight: Highlight
@export var fader_button: Button
@export var tutorial_hand: TutorialHand

var board := Boards.get_board(Boards.Name.TUTORIAL)
var hand_move := Vector4.ZERO


func _ready() -> void:
	grid.set_front_layer(self)

	quit_button.pressed.connect(close)
	ok_button.pressed.connect(close)
	fader_button.pressed.connect(close)
	grid.highlight_changed.connect(on_highlight_changed)
	grid.grabbed.connect(on_grabbed)
	grid.released.connect(on_released)
	grid.fully_appeared.connect(on_grid_appeared)

	if tutorial_hand:
		tutorial_hand.init(hand_next_move)
	grid.appear()
	ScreenFader.show()


func hand_next_move() -> Vector4:
	return hand_move


func close() -> void:
	ScreenFader.hide()
	queue_free()
	get_tree().paused = false


func on_highlight_changed(rect: Rect2) -> void:
	highlight.resize(rect)


func on_grabbed() -> void:
	highlight.toggle(true)


func on_released(_grid: Grid) -> void:
	highlight.toggle(false)


func on_grid_appeared() -> void:
	quit_button.grab_focus()

	while true:
		await get_tree().create_timer(1.4).timeout
		hand_move = make_move(5, 6)
		await select_cells([5, 6])

		for x in [5, 6]:
			grid.get_child(x).remove()

		await get_tree().create_timer(1).timeout
		hand_move = make_move(9, 11)
		await select_cells([9, 10, 11])

		for x in [9, 10, 11]:
			grid.get_child(x).remove()

		await get_tree().create_timer(1).timeout
		hand_move = make_move(0, 9)
		await select_cells([0, 5, 9])

		for x in [0, 1, 4, 8]:
			grid.get_child(x).remove()

		await get_tree().create_timer(1).timeout

		grid.fall_apart()

		await get_tree().create_timer(1).timeout

		for i in grid.get_child_count():
			grid.get_child(i).reset(board.data[i])


func make_move(from_idx: int, to_idx: int) -> Vector4:
	var from := (grid.get_child(from_idx) as Node2D).global_position
	var to := (grid.get_child(to_idx) as Node2D).global_position
	return Vector4(from.x, from.y, to.x, to.y)


func select_cells(cell_nums: Array[int]) -> void:
	if len(cell_nums) == 0:
		push_error("tried selecting an empty array of cell_nums")
		return

	var n: int = cell_nums.pop_front()
	var cell: NumberCell = grid.get_child(n)
	cell.on_pressed(true)

	await get_tree().create_timer(GRID_TIMEOUT).timeout

	while not cell_nums.is_empty():
		n = cell_nums.pop_front()
		cell = grid.get_child(n)
		cell.on_moved(true)
		await get_tree().create_timer(GRID_TIMEOUT).timeout

	await get_tree().create_timer(1).timeout

	grid.on_released()
