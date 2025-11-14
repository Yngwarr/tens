class_name BoardData
extends RefCounted

var size: Vector2i = Vector2i.ZERO
var data: Array[int] = []


func _init(p_size: Vector2i = Vector2i.ZERO, p_data: Array[int] = []) -> void:
	assert(p_data.is_empty() or p_size.x * p_size.y == len(p_data))

	size = p_size
	data = p_data
