class_name Solver
extends Node

signal none_left

@export var grid: Grid

var hints: Array[Vector4]
var next_hint: Vector4

func _ready() -> void:
	read()
	# print_num_on(0, 0)
	# print_num_on(1, 0)
	# print_num_on(0, 1)
	# print_num_on(3, 3)
	# print_sum(0, 0, 0, 0)
	# print_sum(0, 0, 0, 1)
	# print_sum(0, 0, 2, 0)
	# print_sum(0, 0, 1, 1)
	# print_sum(0, 0, 2, 2)

func read() -> void:
	hints.clear()
	next_hint = Vector4.ZERO

	for x0 in range(grid.width):
		for y0 in range(grid.height):
			for x1 in range(x0, grid.width):
				for y1 in range(y0, grid.height):
					if is_ten(x0, y0, x1, y1):
						hints.push_back(make_hint(x0, y0, x1, y1))

	print("%s tens left" % len(hints))
	if len(hints) == 0:
		none_left.emit()
	else:
		next_hint = hints.pick_random()

func is_ten(x0: int, y0: int, x1: int, y1: int) -> bool:
	var sum: int = 0

	for x in range(x0, x1 + 1):
		for y in range(y0, y1 + 1):
			sum += num_on(x, y)
			if sum > 10:
				return false

	return sum == 10

func rect_sum(x0: int, y0: int, x1: int, y1: int) -> int:
	var sum: int = 0

	for x in range(x0, x1 + 1):
		for y in range(y0, y1 + 1):
			sum += num_on(x, y)

	return sum

func cell_on(x: int, y: int) -> NumberCell:
	return grid.get_child(x + y * grid.width)

func num_on(x: int, y: int) -> int:
	return cell_on(x, y).value

func make_hint(x0, y0, x1, y1) -> Vector4:
	var first_point := cell_on(x0, y0).global_position
	var second_point := cell_on(x1, y1).global_position
	return Vector4(first_point.x, first_point.y, second_point.x, second_point.y)

func print_num_on(x: int, y: int) -> void:
	print("num_on(%s, %s) = %s" % [x, y, num_on(x, y)])

func print_sum(x0: int, y0: int, x1: int, y1: int) -> void:
	print("rect_sum(%s, %s, %s, %s) = %s" % [x0, y0, x1, y1, rect_sum(x0, y0, x1, y1)])
