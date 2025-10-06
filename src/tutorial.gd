class_name Tutorial
extends CanvasLayer

@export_group("Internal")
@export var grid: Grid


func _ready() -> void:
	if not visible:
		queue_free()
	else:
		get_tree().paused = true
		grid.appear()
