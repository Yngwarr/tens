class_name Game
extends Node2D

## The game node, the beginning of all, the almighty entry point, the place,
## where your dreams come true! Adjust to your likings and may the code be with
## you.

static var CELL_SIZE := 48
static var TARGET_SUM := 10

@export var pause_ctl: Pause
@export var pause_menu: PauseMenu
@export var game_over_screen: CanvasLayer
@export var highlight: Highlight
@export var hint: Hint
@export var grid: Grid
@export var solver: Solver
@export var sum_label: Label
@export var score_label: Label
@export var hint_button: BaseButton

var score: int = 0

func _ready() -> void:
	pause_menu.modal_open.connect(pause_ctl.drop_next)
	pause_menu.resume_pressed.connect(pause_ctl.unpause)
	grid.highlight_changed.connect(highlight.resize)
	grid.grabbed.connect(on_grabbed)
	grid.released.connect(on_released)
	highlight.sum_changed.connect(update_sum)
	solver.none_left.connect(finish)
	hint_button.pressed.connect(show_hint)
	Global.sum_toggled.connect(toggle_sum)

	toggle_sum(Global.show_sum)

func toggle_sum(on: bool) -> void:
	sum_label.visible = on

func update_sum(value: int) -> void:
	sum_label.text = str(value)

func update_score(value: int) -> void:
	score = value
	score_label.text = "Score: %s" % score

func on_grabbed() -> void:
	highlight.toggle(true)

func on_released() -> void:
	highlight.toggle(false)
	hint.disappear()

	if highlight.sum == TARGET_SUM:
		var amount_removed = highlight.clear()
		update_score(score + amount_removed)
		solver.read()

func show_hint() -> void:
	if not solver.next_hint:
		return
	if hint.visible:
		return

	hint.appear(solver.next_hint)

func finish() -> void:
	game_over_screen.show()
