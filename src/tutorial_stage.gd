class_name TutorialStage
extends Node2D

@export_group("Internal")
@export var grids: Array[Grid]
@export var highlight: Highlight


func _ready() -> void:
	if visible:
		on_visibility_changed()

	visibility_changed.connect(on_visibility_changed)


func on_visibility_changed() -> void:
	if not visible:
		return

	for grid in grids:
		grid.highlight_changed.connect(highlight.resize)
		grid.grabbed.connect(func(): highlight.toggle(true))
		grid.released.connect(func(): highlight.toggle(false))

		grid.appear()
		await grid.fully_appeared
