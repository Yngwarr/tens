extends Node2D

## Main menu scene's main script.

## The node that will grab focus on ready. Usually, the top button on the
## screen.
@export var first_to_focus: Control
@export var credits_window: PopupPanel
@export var stats_window: PopupPanel
#@export var tutorial_button: BaseButton
@export var options_window: PopupPanel
@export var wallpaper_window: PopupPanel

@export_group("Prefabs")
@export var tutorial_prefab: PackedScene


func _ready() -> void:
	ConfigCtl.load_config()
	Stats.read_stats()
	first_to_focus.grab_focus()

	credits_window.visibility_changed.connect(on_credits_visibility)
	stats_window.visibility_changed.connect(on_stats_visibility)
	#tutorial_button.pressed.connect(on_show_tutorial)
	options_window.visibility_changed.connect(on_options_visibility)
	wallpaper_window.visibility_changed.connect(on_wallpaper_visibility)
	ScreenFader.hide()


func on_credits_visibility() -> void:
	ScreenFader.visible = credits_window.visible


func on_stats_visibility() -> void:
	ScreenFader.visible = stats_window.visible


#func on_show_tutorial() -> void:
#	var tutorial := tutorial_prefab.instantiate()
#	add_child(tutorial)


func on_options_visibility() -> void:
	ScreenFader.visible = options_window.visible
	
func on_wallpaper_visibility() -> void:
	ScreenFader.visible = wallpaper_window.visible
