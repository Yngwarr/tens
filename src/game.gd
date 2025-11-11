@tool
class_name Game
extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

static var CELL_SIZE := 58
static var TARGET_SUM := 10

@export var highlight: Highlight
@export var hint: Hint
@export var grid: Grid
@export var solver: Solver
@export var sum_label: SumLabel
@export var score_label: Label
@export var final_score_label: Label
@export var hint_button: HintButton
@export var pause_button: BaseButton
@export var anim: AnimationPlayer
@export var protection_layer: CanvasLayer
@export var hint_sound: AudioStreamPlayer
@export var game_over_sound: AudioStreamPlayer
@export var music_player: AudioStreamPlayer
@export var options_window: PopupPanel
@export var confirm_window: PopupPanel
@export var idle_timer: Timer
@export var wallpaper_window: PopupPanel
@export var tutorial_button: TextureButton

@export_group("Prefabs")
@export var tutorial_prefab: PackedScene

var score: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if not Storage.tutorial_watched:
		var tutorial := tutorial_prefab.instantiate()
		add_child(tutorial)
		Storage.tutorial_watched = true
		get_tree().paused = true

	grid.highlight_changed.connect(highlight.resize)
	grid.grabbed.connect(on_grabbed)
	grid.released.connect(on_released)
	grid.fully_appeared.connect(on_grid_appeared)
	highlight.sum_changed.connect(update_sum)
	solver.none_left.connect(finish)
	hint_button.pressed.connect(show_hint)
	options_window.visibility_changed.connect(on_options_visibility)
	confirm_window.visibility_changed.connect(on_confirm_visibility)
	idle_timer.timeout.connect(on_idle_timeout)
	wallpaper_window.visibility_changed.connect(on_wallpaper_visibility)
	tutorial_button.pressed.connect(on_show_tutorial)

	anim.play(&"start")


func _process(_delta: float) -> void:
	if OS.has_feature(&"editor_runtime") and Input.is_action_just_pressed(&"cheat_finish"):
		finish()


func update_sum(value: int) -> void:
	sum_label.update_text(value)


func update_score(value: int) -> void:
	score = value
	score_label.text = str(score)


func on_grabbed() -> void:
	highlight.toggle(true)


func on_released() -> void:
	highlight.toggle(false)
	hint.disappear()

	if highlight.sum == TARGET_SUM:
		var amount_removed = highlight.clear()

		update_score(score + amount_removed)
		sum_label.play_effect()

		hint_button.calm_down()
		idle_timer.stop()
		idle_timer.start()

		solver.read()

	else:
		highlight.fail()


func show_hint() -> void:
	if not solver.next_hint:
		return

	if hint.visible:
		hint.bounce()
		return

	hint_sound.play()
	hint.appear(solver.next_hint)
	hint_button.calm_down()
	idle_timer.stop()


func finish() -> void:
	PokiSDK.gameplayStop()

	Stats.increase_stat(&"games_played", 1)
	Stats.increase_stat(&"total_score", score)

	if Stats.get_stat(&"best_score") < score:
		Stats.set_stat(&"best_score", score)
		# TODO add an effect for the new record

	Stats.write_stats()

	music_player.stop()
	game_over_sound.play()
	final_score_label.text = "You scored " + str(score) + " points"
	protection_layer.show()
	anim.play(&"game_over")


func on_grid_appeared() -> void:
	protection_layer.hide()
	PokiSDK.gameplayStart()
	idle_timer.start()


func on_options_visibility() -> void:
	ScreenFader.visible = options_window.visible


func on_confirm_visibility() -> void:
	ScreenFader.visible = confirm_window.visible


func on_idle_timeout() -> void:
	hint_button.demand_attention()


func on_wallpaper_visibility() -> void:
	ScreenFader.visible = wallpaper_window.visible
	
func on_show_tutorial() -> void:
	var tutorial := tutorial_prefab.instantiate()
	add_child(tutorial)
