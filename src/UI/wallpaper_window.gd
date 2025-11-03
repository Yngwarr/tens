@tool
class_name WallpaperWindow
extends PopupPanel

const PAGE_SIZE: int = 6

@export_group("Internal")
@export var button_container: GridContainer

@export_group("Prefabs")
@export var grid_element: PackedScene


func _ready() -> void:
	spawn_page()


func spawn_page() -> void:
	clear()

	for i in PAGE_SIZE:
		spawn_element(i)


func spawn_element(index: int) -> void:
	assert(button_container != null)
	assert(grid_element != null)

	var wallpaper := grid_element.instantiate()
	if not Engine.is_editor_hint():
		wallpaper.init(Global.wallpaper_textures[index])
	button_container.add_child(wallpaper)


func clear() -> void:
	assert(button_container != null)

	for i in button_container.get_child_count():
		button_container.get_child(i).queue_free()
