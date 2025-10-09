extends CheckButton

func _toggled(toggled_on: bool) -> void:
    Global.toggle_sum(toggled_on)
