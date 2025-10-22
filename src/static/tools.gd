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
