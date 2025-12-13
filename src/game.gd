@tool
class_name Game
extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

const DEFAULT_HINT_COUNT: int = 3
const REWARDED_AD_HINTS: int = 5

static var CELL_SIZE := 58
static var TARGET_SUM := 10

@export_group("Internal")
@export var highlight: Highlight
@export var hint: Hint
@export var grid: Grid
@export var solver: Solver
@export var sum_label: SumLabel
@export var score_label: Label
@export var final_score_label: Label
@export var hint_button: HintButton
@export var pause_button: BaseButton
@export var tutorial_button: TextureButton
@export var wallpaper_button: BaseButton
@export var star_path: Path2D
@export var anim: AnimationPlayer
@export var protection_layer: CanvasLayer
@export var hint_sound: AudioStreamPlayer
@export var game_over_sound: AudioStreamPlayer
@export var music_player: AudioStreamPlayer
@export var options_window: PopupPanel
@export var confirm_window: PopupPanel
@export var wallpaper_window: PopupPanel
@export var idle_timer: Timer

@export_group("Prefabs")
@export var tutorial_prefab: PackedScene

var score: int = 0
var hint_count := DEFAULT_HINT_COUNT
var gameplay_started := false


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	grid.highlight_changed.connect(highlight.resize)
	grid.grabbed.connect(on_grabbed)
	grid.released.connect(on_released)
	grid.fully_appeared.connect(on_grid_appeared)
	highlight.sum_changed.connect(update_sum)
	solver.none_left.connect(finish)
	hint_button.pressed.connect(show_hint)
	confirm_window.visibility_changed.connect(on_confirm_visibility)
	idle_timer.timeout.connect(on_idle_timeout)
	wallpaper_window.visibility_changed.connect(on_wallpaper_visibility)
	tutorial_button.pressed.connect(on_show_tutorial)
	Global.window_size_changed.connect(adjust_for_window_size)

	PokiSDK.rewarded_break_ended.connect(on_rewarded_ended)
	PokiSDK.commercial_break_ended.connect(on_ad_break_ended)
	PokiSDK.ad_started.connect(on_ad_started)
	PokiSDK.ad_ended.connect(on_ad_ended)

	adjust_for_window_size(Tools.get_window_size(self))
	hint_button.update_label(hint_count)

	start_ad_break()

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
	if not gameplay_started:
		gameplay_started = true
		PokiSDK.gameplayStart()

	highlight.toggle(true)


func on_released(_grid: Grid) -> void:
	highlight.toggle(false)

	if highlight.sum == TARGET_SUM:
		var amount_removed = highlight.clear()

		update_score(score + amount_removed)
		sum_label.play_effect()

		hint_button.calm_down()
		idle_timer.stop()
		idle_timer.start()

		hint.disappear()
		solver.read()
	else:
		highlight.fail()


func on_grid_appeared() -> void:
	protection_layer.hide()
	idle_timer.start()


func on_confirm_visibility() -> void:
	ScreenFader.visible = confirm_window.visible


func on_idle_timeout() -> void:
	hint_button.demand_attention()


func on_wallpaper_visibility() -> void:
	ScreenFader.visible = wallpaper_window.visible


func on_show_tutorial() -> void:
	var tutorial := tutorial_prefab.instantiate()
	add_child(tutorial)


func on_ad_started() -> void:
	SoundCtl.set_mute(true)


func on_ad_ended() -> void:
	SoundCtl.set_mute(false)


func on_rewarded_ended(success: bool) -> void:
	if not success:
		return

	hint_count = REWARDED_AD_HINTS
	hint_button.update_label(hint_count)


func on_ad_break_ended(_response) -> void:
	Pause.call_deferred(&"turn", false)


func show_hint() -> void:
	if not solver.get_hint():
		return

	if hint.visible:
		hint.bounce()
		return

	if hint_count > 0:
		hint_count -= 1
		hint_sound.play()
		hint.appear(solver.get_hint())
		hint_button.update_label(hint_count)
		hint_button.calm_down()
		idle_timer.stop()
	else:
		PokiSDK.rewardedBreak()


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

	var format_label = tr("WIN_SCORE")
	final_score_label.text = format_label % str(score)
	protection_layer.show()
	anim.play(&"game_over")


func adjust_for_window_size(size: Vector2) -> void:
	var is_portrait := size.y > size.x
	var diff: float = abs(size.y - size.x)
	var hint_offset := Vector2(
		(
			diff / 4 + 20 + hint_button.size.x / 2
			if diff / 2 > hint_button.size.x
			else hint_button.size.x
		),
		(
			diff / 4 + 20 + hint_button.size.y / 2
			if diff / 2 > hint_button.size.y
			else hint_button.size.y
		)
	)
	var sum_offset := diff / 4 + 20

	if is_portrait:
		hint_button.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER_BOTTOM)
		hint_button.position = Vector2(size.x / 2 - hint_button.size.x / 2, size.y - hint_offset.y)
		sum_label.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER_TOP)
		sum_label.position = Vector2(size.x / 2 - sum_label.size.x / 2, sum_offset)
	else:
		hint_button.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER_RIGHT)
		hint_button.position = Vector2(size.x - hint_offset.x, size.y / 2 - hint_button.size.y / 2)
		sum_label.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER_BOTTOM)
		sum_label.position = Vector2(sum_offset, size.y / 2 - sum_label.size.y / 2)


func move_wallpaper_button() -> void:
	var local_dest := star_path.curve.get_point_position(star_path.curve.point_count - 1)
	var global_dest := star_path.to_global(local_dest) - wallpaper_button.size / 2

	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(wallpaper_button, "position", global_dest, 2.0)


func start_ad_break() -> void:
	if Global.ad_break_countdown > 0:
		Global.ad_break_countdown -= 1
		return

	PokiSDK.commercialBreak()
	Pause.turn(true)
