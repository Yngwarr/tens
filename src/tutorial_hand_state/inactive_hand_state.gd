class_name InactiveHandState
extends TutorialHandState

var hidden_state: TutorialHandState


func setup(opts: Dictionary[String, Variant]) -> void:
	super(opts)

	if opts.has("hidden_state"):
		hidden_state = opts.hidden_state


func enter() -> void:
	super()

	hand.hide()


func on_moves_added() -> void:
	transition(hidden_state)
