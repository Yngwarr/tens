class_name StateMachine
extends Node

@export_group('Debug')
@export var state_label: Label

var current_state: State:
	set(value):
		current_state = value
		if value != null and state_label != null:
			state_label.text = value.name

var states: Array[State] = []

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.fixed_update(delta)


func add_state(state: State) -> void:
	states.push_back(state)
	state.transitioned.connect(transition)


func transition(to: State) -> void:
	if not (to in states):
		push_error("Tried transitioning '%s' -> '%s', but '%s' is not a child of the current machine. This is strange, not doing it." \
				% [current_state.name, to.name, to.name])
		return

	if current_state:
		current_state.exit()
	to.enter()

	current_state = to
