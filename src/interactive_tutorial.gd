class_name InteractiveTutorial
extends Node2D

@export_group("Internal")
@export var stages: Array[TutorialStage]
@export var highlight: Highlight
@export var sum_label: SumLabel
@export var hand: TutorialHand
@export var solver: Solver
@export var skip_button: Button

var current_stage: int = 0


func _ready() -> void:
	highlight.sum_changed.connect(sum_label.update_text)

	for i in len(stages):
		var stage := stages[i]
		stage.init(i, hand, solver)
		stage.visible = i == 0
		stage.complete.connect(on_stage_complete)

	hand.init(get_hand_move)


func on_stage_complete(index: int) -> void:
	if index != len(stages) - 1:
		current_stage = index + 1
		stages[index].hide()
		stages[current_stage].show()

	if current_stage == len(stages) - 1:
		var tween := get_tree().create_tween()
		tween.tween_property(skip_button, "modulate", Color.TRANSPARENT, .2)
		tween.parallel().tween_property(
			skip_button, "position", skip_button.position + Vector2.DOWN * 100, .2
		)


func get_hand_move() -> Vector4:
	for grid in stages[current_stage].grids:
		if grid.is_empty():
			continue

		solver.grid = grid
		solver.read()
		return solver.next_hint

	return Vector4.ZERO
