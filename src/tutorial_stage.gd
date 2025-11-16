class_name TutorialStage
extends Node2D

signal complete(index: int)

@export_group("Internal")
@export var grids: Array[Grid]
@export var highlight: Highlight
@export var solver: Solver

var index: int
var hand: TutorialHand


func _ready() -> void:
	if visible:
		on_visibility_changed()

	visibility_changed.connect(on_visibility_changed)


func init(p_index: int, p_hand: TutorialHand) -> void:
	index = p_index
	hand = p_hand


func on_visibility_changed() -> void:
	if not visible:
		return

	for grid in grids:
		grid.highlight_changed.connect(highlight.resize)
		grid.grabbed.connect(func(): highlight.toggle(true))
		grid.released.connect(on_release)

		grid.appear()
		await grid.fully_appeared

	var p0: Vector2 = grids[0].get_child(0).global_position
	var p1: Vector2 = grids[0].get_child(1).global_position
	hand.drag(p0, p1)


func on_release(_grid: Grid) -> void:
	highlight.toggle(false)

	if highlight.sum == Game.TARGET_SUM:
		highlight.clear()
		check_complete()


func check_complete() -> void:
	if solver:
		if solver.read() == 0:
			complete.emit(index)

		return

	for grid in grids:
		if not grid.is_empty():
			return

	complete.emit(index)
