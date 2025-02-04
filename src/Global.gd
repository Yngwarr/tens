extends Node

signal sum_toggled(on: bool)

var show_sum := false
# level_desc: { type: "puzzle" | "arcade", width: int, height: int, level?: string }
var level_desc := {
    "type": &"arcade",
    "width": 16,
    "height": 11
}

func toggle_sum(on: bool) -> void:
    show_sum = on
    sum_toggled.emit(on)

func change_scene(next_scene_name: String) -> void:
    # one expects a newly loaded scene to be unpaused
    get_tree().paused = false
    get_tree().change_scene_to_file(next_scene_name)
