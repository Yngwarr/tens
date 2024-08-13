extends Node

signal sum_toggled(on: bool)

var show_sum := false

func toggle_sum(on: bool) -> void:
    show_sum = on
    sum_toggled.emit(on)
