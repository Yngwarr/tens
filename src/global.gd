class_name TheGlobal
extends Node

const WALLPAPER_FOLDER := "res://img/backgrounds/"

var wallpaper_textures: Array[Texture2D]


func _ready() -> void:
	var wallpaper_names := ResourceLoader.list_directory(WALLPAPER_FOLDER)
	wallpaper_names.sort()

	for n in wallpaper_names:
		wallpaper_textures.push_back(load(WALLPAPER_FOLDER + n))


func wallpaper_cost(idx: int) -> int:
	if idx == 0:
		return 0
	if idx <= 3:
		return 2 * idx - 1
	if idx <= 6:
		return 3 * idx - 4
	return 5 * idx - 16
