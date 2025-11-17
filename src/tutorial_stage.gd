class_name TutorialStage
extends Node2D

signal complete(index: int)

@export_group("Internal")
@export var grids: Array[Grid]
@export var highlight: Highlight

var index: int
var hand: TutorialHand
var solver: Solver


func _ready() -> void:
	if visible:
		on_visibility_changed()

	visibility_changed.connect(on_visibility_changed)


func init(p_index: int, p_hand: TutorialHand, p_solver: Solver) -> void:
	index = p_index
	hand = p_hand
	solver = p_solver


func on_visibility_changed() -> void:
	if not visible:
		return

	for grid in grids:
		grid.highlight_changed.connect(highlight.resize)
		grid.grabbed.connect(func(): highlight.toggle(true))
		grid.released.connect(on_release)

		grid.appear()
		await grid.fully_appeared


func on_release(_grid: Grid) -> void:
	highlight.toggle(false)

	if highlight.sum == Game.TARGET_SUM:
		highlight.clear()
		check_complete()


func check_complete() -> void:
	if len(grids) == 1:
		solver.grid = grids[0]

		if solver.read() == 0:
			complete.emit(index)

	elif len(grids) > 1:
		for grid in grids:
			if not grid.is_empty():
				return

		complete.emit(index)
