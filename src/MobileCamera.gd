extends Camera2D

func _ready() -> void:
    enabled = OS.has_feature('mobile')
