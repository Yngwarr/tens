@tool
class_name WallpaperWindow
extends PopupPanel

signal wallpaper_changed(texture: Texture2D)

const PAGE_SIZE: int = 6

var page_index = 0
var page_count = 3
var star_count = 10
var max_page_index = page_count - 1

@export_group("Internal")
@export var button_container: GridContainer
@export var prev_button: TextureButton
@export var next_button: TextureButton
@export var page_label: Label
@export var star_label: RichTextLabel

@export_group("Prefabs")
@export var grid_element: PackedScene


func _ready() -> void:
	if not Engine.is_editor_hint():
		visibility_changed.connect(on_visibility_changed)
	prev_button.pressed.connect(prev_button_pressed)
	next_button.pressed.connect(next_button_pressed)
	
	update_buttons()
	update_page_label()
	spawn_page()
	star_label.text = "[img]img/wallpapers-window/star_black.svg[/img]" + str(star_count)

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

func update_buttons() -> void:
	if page_index == 0:
		prev_button.disabled = true
		next_button.disabled = false
	elif page_index == max_page_index:
		prev_button.disabled = false
		next_button.disabled = true
	else:
		prev_button.disabled = false
		next_button.disabled = false

func update_page_label() -> void:
	page_label.text = str(page_index + 1)

func prev_button_pressed() -> void:
	page_index = page_index - 1
	update_page_label()
	update_buttons()
	
func next_button_pressed() -> void:
	page_index = page_index + 1
	update_page_label()
	update_buttons()
