class_name InteractiveTutorial
extends Node2D

@export_group("Internal")
@export var stages: Array[TutorialStage]
@export var highlight: Highlight
@export var sum_label: SumLabel


func _ready() -> void:
	highlight.sum_changed.connect(sum_label.update_text)

	for i in len(stages):
		var stage := stages[i]
		stage.init(i)
		stage.complete.connect(on_stage_complete)


func on_stage_complete(index: int) -> void:
	if index != len(stages) - 1:
		stages[index].hide()
		stages[index + 1].show()
