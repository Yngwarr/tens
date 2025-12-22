class_name InteractiveTutorial
extends Node2D

@export_file("*.tscn") var game_scene_name: String

@export_group("Internal")
@export var stages: Array[TutorialStage]
@export var highlight: Highlight
@export var sum_label: SumLabel
@export var hand: TutorialHand
@export var solver: Solver
@export var skip_button: Button
@export var start_button: Button

var current_stage: int = 0
var interaction_happened := false


func _ready() -> void:
	highlight.sum_changed.connect(sum_label.update_text)
	skip_button.pressed.connect(on_quit)
	start_button.pressed.connect(on_quit)

	for i in len(stages):
		var stage := stages[i]
		stage.init(i, hand, solver)
		stage.visible = i == 0
		stage.complete.connect(on_stage_complete)
		stage.grabbed.connect(on_stage_grabbed)

	hand.init(get_hand_move)

	ConfigCtl.set_pref(&"show_tutorial", false)


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


func on_stage_grabbed() -> void:
	if interaction_happened:
		return

	interaction_happened = true
	PokiSDK.gameplayStart()


func on_quit() -> void:
	if interaction_happened:
		PokiSDK.gameplayStop()

	get_tree().change_scene_to_file(game_scene_name)


func get_hand_move() -> Vector4:
	for grid in stages[current_stage].grids:
		if grid.is_empty():
			continue

		solver.grid = grid
		solver.read()
		return solver.get_hint()

	return Vector4.ZERO
