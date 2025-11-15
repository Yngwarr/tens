extends Node2D

## Main menu scene's main script.

## The node that will grab focus on ready. Usually, the top button on the
## screen.
@export var first_to_focus: Control
@export var credits_window: PopupPanel
@export var stats_window: PopupPanel
@export var options_window: PopupPanel
@export var wallpaper_window: PopupPanel
@export var tutorial_button: BaseButton
@export_file("*.tscn") var tutorial_scene_name: String

func _ready() -> void:
	if OS.has_feature(&"editor_runtime"):
		print("User data is located at %s" % OS.get_data_dir())

	ConfigCtl.load_config()
	Stats.read_stats()

	var bg_index: int = ConfigCtl.get_pref(&"background")
	Background.change_bg(Global.wallpaper_textures[bg_index])

	first_to_focus.grab_focus()

	credits_window.visibility_changed.connect(on_credits_visibility)
	stats_window.visibility_changed.connect(on_stats_visibility)
	options_window.visibility_changed.connect(on_options_visibility)
	wallpaper_window.visibility_changed.connect(on_wallpaper_visibility)
	tutorial_button.pressed.connect(on_show_tutorial)
	ScreenFader.hide()


func on_credits_visibility() -> void:
	ScreenFader.visible = credits_window.visible


func on_stats_visibility() -> void:
	ScreenFader.visible = stats_window.visible


func on_options_visibility() -> void:
	ScreenFader.visible = options_window.visible


func on_wallpaper_visibility() -> void:
	ScreenFader.visible = wallpaper_window.visible


func on_show_tutorial() -> void:
	get_tree().change_scene_to_file(tutorial_scene_name)
