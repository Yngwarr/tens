class_name Game
extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

static var CELL_SIZE := 48

@export var pause_ctl: Pause
@export var pause_menu: PauseMenu
@export var highlight: Highlight
@export var grid: Grid
@export var sum_label: Label

func _ready() -> void:
	pause_menu.modal_open.connect(pause_ctl.drop_next)
	pause_menu.resume_pressed.connect(pause_ctl.unpause)
	grid.highlight_changed.connect(highlight.resize)
	highlight.sum_changed.connect(update_sum)

func update_sum(value: int) -> void:
	sum_label.text = str(value)
