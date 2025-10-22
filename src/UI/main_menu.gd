extends Node2D

## Main menu scene's main script.

## The node that will grab focus on ready. Usually, the top button on the
## screen.
@export var first_to_focus: Control
@export var credits_window: PopupPanel
@export var stats_window: PopupPanel
@export var fader: CanvasLayer

func _ready() -> void:
	ConfigCtl.load_config()
	Stats.read_stats()
	first_to_focus.grab_focus()
	credits_window.visibility_changed.connect(on_credits_visibility)
	stats_window.visibility_changed.connect(on_stats_visibility)

func on_credits_visibility() -> void:
	fader.visible = credits_window.visible
	
func on_stats_visibility() -> void:
	fader.visible = stats_window.visible
