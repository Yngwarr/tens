class_name State
extends RefCounted

signal transitioned(to: State)

var name: String

func setup(opts: Dictionary[String, Variant]) -> void:
	if opts.has("name"):
		name = opts.name


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func fixed_update(_delta: float) -> void:
	pass


func transition(to: State) -> void:
	transitioned.emit(to)
