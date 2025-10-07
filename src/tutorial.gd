class_name Tutorial
extends CanvasLayer

@export_group("Internal")
@export var grid: Grid
@export var quit_button: Button


func _ready() -> void:
	if not visible:
		queue_free()
	else:
		quit_button.pressed.connect(close)
		get_tree().paused = true
		grid.appear()


func close() -> void:
	queue_free()
	get_tree().paused = false
