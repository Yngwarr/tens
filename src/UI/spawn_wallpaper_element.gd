extends GridContainer

@export var grid_element: PackedScene

var page_index = 1 

func _ready() -> void:
	spawn_page(page_index)

func spawn_element(_index) -> void:
	var wallpaper := grid_element.instantiate()
	add_child(wallpaper)

func spawn_page(_index) -> void:
	for i in 6:
		spawn_element(i)
