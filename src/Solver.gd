class_name Solver
extends Node

@export var grid: Grid

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
	var all: int = 0
	var tens: int = 0

	for x0 in range(grid.width):
		for y0 in range(grid.height):
			for x1 in range(x0, grid.width):
				for y1 in range(y0, grid.height):
					all += 1
					if is_ten(x0, y0, x1, y1):
						tens += 1

	print("%s out of %s" % [tens, all])

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

func num_on(x: int, y: int) -> int:
	return grid.get_child(x + y * grid.width).value

func print_num_on(x: int, y: int) -> void:
	print("num_on(%s, %s) = %s" % [x, y, num_on(x, y)])

func print_sum(x0: int, y0: int, x1: int, y1: int) -> void:
	print("rect_sum(%s, %s, %s, %s) = %s" % [x0, y0, x1, y1, rect_sum(x0, y0, x1, y1)])
