class_name Tutorial
extends CanvasLayer

const GRID_TIMEOUT := .2

const BOARD_SIZE := Vector2i(4, 4)
const BOARD: Array[int] = [
	1, 3, 9, 9,
	2, 4, 6, 9,
	4, 5, 3, 2,
	9, 9, 9, 9
]

@export_group("External")
@export var front_layer: CanvasLayer

@export_group("Internal")
@export var grid: Grid
@export var quit_button: Button
@export var ok_button: Button
@export var highlight: Highlight
@export var anim: AnimationPlayer


func _ready() -> void:
	if Storage.tutorial_watched:
		queue_free()
	else:
		Storage.tutorial_watched = true
		show()
		quit_button.pressed.connect(close)
		ok_button.pressed.connect(close)
		grid.highlight_changed.connect(on_highlight_changed)
		grid.grabbed.connect(on_grabbed)
		grid.released.connect(on_released)
		grid.fully_appeared.connect(on_grid_appeared)

		get_tree().paused = true
		grid.appear()


func close() -> void:
	for i in front_layer.get_child_count():
		front_layer.get_child(i).queue_free()

	queue_free()
	get_tree().paused = false


func on_highlight_changed(rect: Rect2) -> void:
	highlight.resize(rect)


func on_grabbed() -> void:
	highlight.toggle(true)


func on_released() -> void:
	highlight.toggle(false)
	highlight.clear()


func on_grid_appeared() -> void:
	quit_button.grab_focus()

	while true:
		anim.play("tutorial_appear")
		await get_tree().create_timer(1).timeout
		
		anim.play("tutorial_1")
		await select_cells([5, 6])

		for x in [5, 6]:
			grid.get_child(x).remove()

		anim.play("tutorial_move_to_2")
		await get_tree().create_timer(1).timeout
		anim.play("tutorial_2")
		await select_cells([9, 10, 11])

		for x in [9, 10, 11]:
			grid.get_child(x).remove()
			
		anim.play("tutorial_move_to_3")
		await get_tree().create_timer(1).timeout
		anim.play("tutorial_3")
		await select_cells([0, 5, 9])

		for x in [0, 1, 4, 8]:
			grid.get_child(x).remove()
			
		anim.play("tutorial_disappear")
		await get_tree().create_timer(1).timeout

		grid.fall_apart()

		await get_tree().create_timer(1).timeout

		for i in grid.get_child_count():
			grid.get_child(i).reset(BOARD[i])


func select_cells(cell_nums: Array[int]) -> void:
	if len(cell_nums) == 0:
		push_error("tried selecting an empty array of cell_nums")
		return

	var n: int = cell_nums.pop_front()
	var cell: NumberCell = grid.get_child(n)
	cell.on_pressed()

	await get_tree().create_timer(GRID_TIMEOUT).timeout

	while not cell_nums.is_empty():
		n = cell_nums.pop_front()
		cell = grid.get_child(n)
		cell.on_moved()
		await get_tree().create_timer(GRID_TIMEOUT).timeout

	await get_tree().create_timer(1).timeout

	grid.on_released()
