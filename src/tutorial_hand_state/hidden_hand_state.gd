class_name HiddenHandState
extends TutorialHandState

var move_state: TutorialHandState
var cooldown: float = 5


func setup(opts: Dictionary[String, Variant]) -> void:
	super(opts)

	if opts.has("move_state"):
		move_state = opts.move_state

	if opts.has("cooldown"):
		cooldown = opts.cooldown


func enter() -> void:
	super()

	Tools.try_connect(hand.cooldown_timer.timeout, on_timeout)
	hand.cooldown_timer.start(cooldown)


func exit() -> void:
	super()

	Tools.try_disconnect(hand.cooldown_timer.timeout, on_timeout)


func on_player_turn() -> void:
	super()

	hand.cooldown_timer.stop()
	transition(self)


func on_timeout() -> void:
	transition(move_state)
