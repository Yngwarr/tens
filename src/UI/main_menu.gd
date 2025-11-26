extends Node2D

## Main menu scene's main script.

const HIDE_TIME := .3

@export_file("*.tscn") var tutorial_scene_name: String
@export_file("*.tscn") var game_scene_name: String
@export var first_to_focus: Control
@export var credits_window: PopupPanel
@export var stats_window: PopupPanel
@export var options_window: PopupPanel
@export var wallpaper_window: PopupPanel
@export var tutorial_button: BaseButton
@export var start_button: Button
@export var anim: AnimationPlayer
@export var elements_leaving_up: Array[Control]
@export var elements_leaving_down: Array[Control]


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
	start_button.pressed.connect(on_start_pressed)
	anim.animation_finished.connect(on_anim_finished)
	ScreenFader.hide()


func on_start_pressed() -> void:
	anim.play(&"hide")
	hide_everything()


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


func on_anim_finished(anim_name: StringName) -> void:
	if anim_name != &"hide":
		return

	var next_scene := game_scene_name

	if ConfigCtl.get_pref(&"show_tutorial"):
		next_scene = tutorial_scene_name
		ConfigCtl.set_pref(&"show_tutorial", false)

	get_tree().change_scene_to_file(next_scene)


func hide_everything() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.set_parallel()

	for el in elements_leaving_up:
		tween.tween_property(el, "position:y", el.position.y - 100, HIDE_TIME)
		tween.tween_property(el, "modulate:a", 0, HIDE_TIME)

	for el in elements_leaving_down:
		tween.tween_property(el, "position:y", el.position.y + 100, HIDE_TIME)
		tween.tween_property(el, "modulate:a", 0, HIDE_TIME)
