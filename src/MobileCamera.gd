extends Camera2D

func _ready() -> void:
    enabled = Tools.is_mobile()
