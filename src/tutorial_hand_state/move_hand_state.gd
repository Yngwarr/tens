class_name MoveHandState
extends TutorialHandState

var hidden_state: TutorialHandState

var tween: Tween
var start_scale: Vector2
var start_rotation: float

func setup(opts: Dictionary[String, Variant]) -> void:
	super(opts)

	if opts.has('hidden_state'):
		hidden_state = opts.hidden_state

	start_scale = hand.scale
	start_rotation = hand.rotation_degrees


func enter() -> void:
	super()

	var current_move := hand.next_move()

	hand.modulate = Color.TRANSPARENT
	hand.scale = start_scale
	hand.rotation_degrees = start_rotation
	hand.global_position = current_move.from
	hand.show()

	tween = hand.get_tree().create_tween()
	tween.tween_property(hand, "modulate", Color.WHITE, .5)
	tween.tween_property(hand, "rotation_degrees", start_rotation - 10, .5)
	tween.parallel().tween_property(hand, "scale", start_scale * .8, .5)
	tween.tween_property(hand, "global_position", current_move.to, 1)
	tween.tween_property(hand, "rotation_degrees", start_rotation, .5)
	tween.parallel().tween_property(hand, "scale", start_scale, .5)
	tween.tween_callback(on_tween_done)

func exit() -> void:
	super()

	tween = hand.get_tree().create_tween()
	tween.tween_property(hand, "modulate", Color.TRANSPARENT, .5)


func on_player_turn() -> void:
	super()

	tween.kill()
	transition(hidden_state)


func on_tween_done() -> void:
	transition(hidden_state)
