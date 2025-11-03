# Global
extends Node

const WALLPAPER_FOLDER := "res://img/backgrounds/"

var wallpaper_textures: Array[Texture2D]


func _ready() -> void:
	var wallpaper_names := ResourceLoader.list_directory(WALLPAPER_FOLDER)
	wallpaper_names.sort()

	for n in wallpaper_names:
		wallpaper_textures.push_back(load(WALLPAPER_FOLDER + n))

	print(wallpaper_textures)
