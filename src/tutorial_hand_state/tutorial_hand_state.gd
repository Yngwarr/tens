class_name TutorialHandState
extends State

var hand: TutorialHand


func setup(opts: Dictionary[String, Variant]) -> void:
	super(opts)

	if opts.has("hand"):
		hand = opts.hand


func on_moves_added() -> void:
	pass


func on_player_turn() -> void:
	pass
