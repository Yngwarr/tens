@tool
class_name Boards
extends RefCounted

enum Name {
	RANDOM,
	TUTORIAL,
	PAGE_1_1,
	PAGE_1_2,
	PAGE_1_3,
	PAGE_2,
	PAGE_3
}

static var bs: Dictionary[Name, BoardData] = {
	Name.RANDOM: BoardData.new(Vector2i(10, 10), []),
	Name.TUTORIAL: BoardData.new(Vector2i(4, 4), [
		1, 3, 9, 9,
		2, 4, 6, 9,
		4, 5, 3, 2,
		9, 9, 9, 9
	]),
	Name.PAGE_1_1: BoardData.new(Vector2i(1, 2), [6, 4]),
	Name.PAGE_1_2: BoardData.new(Vector2i(1, 3), [2, 7, 1]),
	Name.PAGE_1_3: BoardData.new(Vector2i(2, 2), [1, 2, 5, 2]),
	Name.PAGE_2: BoardData.new(Vector2i(3, 3), [
		0, 0, 5,
		8, 1, 1,
		5, 0, 0
	]),
	Name.PAGE_3: BoardData.new(Vector2i(3, 3), [
		5, 9, 5,
		8, 2, 1,
		5, 4, 5
	])
}

static func is_random(name: Name) -> bool:
	return get_board(name).data.is_empty()


static func get_board(name: Name) -> BoardData:
	return bs[name]
