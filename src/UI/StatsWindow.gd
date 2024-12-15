@tool
class_name StatsWindow
extends PopupPanel

@export var label_container: Node

func _ready() -> void:
    for x in Stats.data:
        var label := Label.new()
        label.text = "%s: %s" % [Stats.data[x].name, Stats.data[x].value]
        label_container.add_child(label)
