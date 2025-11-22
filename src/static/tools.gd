class_name Tools
extends Object


static func is_mobile() -> bool:
	return OS.has_feature("mobile")


static func try_connect(p_signal: Signal, p_func: Callable) -> void:
	if not p_signal.is_connected(p_func):
		p_signal.connect(p_func)


static func try_disconnect(p_signal: Signal, p_func: Callable) -> void:
	if p_signal.is_connected(p_func):
		p_signal.disconnect(p_func)


static func eerp(a: float, b: float, t: float) -> float:
	return a * exp(t * log(b / a))


static func random_pitch(base: float, offset := .1) -> float:
	assert(offset <= base)

	return eerp(base - offset, base + offset, randf())


static func get_window_size(node: Node) -> Vector2:
	return node.get_viewport().get_visible_rect().size
