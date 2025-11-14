class_name InteractiveTutorial
extends Node2D

@export_group("Internal")
@export var stages: Array[TutorialStage]
@export var highlight: Highlight
@export var sum_label: SumLabel

func _ready() -> void:
	highlight.sum_changed.connect(sum_label.update_text)
