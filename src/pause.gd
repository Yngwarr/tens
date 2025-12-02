class_name ThePause
extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func turn(on: bool) -> void:
	get_tree().paused = on
