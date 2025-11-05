@tool
class_name WallpaperWindow
extends PopupPanel

signal wallpaper_changed(texture: Texture2D)

const PAGE_SIZE: int = 6

@export_group("Internal")
@export var button_container: GridContainer

@export_group("Prefabs")
@export var grid_element: PackedScene


func _ready() -> void:
	if not Engine.is_editor_hint():
		visibility_changed.connect(on_visibility_changed)

	spawn_page()


func on_wallpaper_changed(texture: Texture2D) -> void:
	Background.change_bg(texture)
	update_selected(texture)
	wallpaper_changed.emit(texture)

func on_visibility_changed() -> void:
	if visible:
		update_selected(Background.get_texture())


func spawn_page() -> void:
	clear()

	for i in PAGE_SIZE:
		spawn_element(i)


func spawn_element(index: int) -> void:
	assert(button_container != null)
	assert(grid_element != null)

	var wallpaper: WallpaperElement = grid_element.instantiate()
	if not Engine.is_editor_hint():
		wallpaper.init(Global.wallpaper_textures[index])
		wallpaper.wallpaper_changed.connect(on_wallpaper_changed)
	button_container.add_child(wallpaper)


func clear() -> void:
	assert(button_container != null)

	for i in button_container.get_child_count():
		button_container.get_child(i).queue_free()


func update_selected(texture: Texture2D) -> void:
	for i in button_container.get_child_count():
		var button: WallpaperElement = button_container.get_child(i)
		button.set_selected(button.get_texture() == texture)
