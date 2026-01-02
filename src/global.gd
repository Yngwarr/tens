class_name TheGlobal
extends Node

signal window_size_changed(size: Vector2)

const WALLPAPER_FOLDER := "res://img/backgrounds/"

var wallpaper_textures: Array[Texture2D]
var ad_break_countdown: int = 2
var game_board_seed: String = ""


func _ready() -> void:
	ConfigCtl.load_config()
	Stats.read_stats()

	var wallpaper_names := ResourceLoader.list_directory(WALLPAPER_FOLDER)
	wallpaper_names.sort()

	for n in wallpaper_names:
		wallpaper_textures.push_back(load(WALLPAPER_FOLDER + n))

	var bg_index: int = ConfigCtl.get_pref(&"background")
	Background.change_bg(Global.wallpaper_textures[bg_index])

	set_locale(ConfigCtl.get_pref(&"locale"))

	get_viewport().size_changed.connect(on_size_changed)


func wallpaper_cost(idx: int) -> int:
	if idx == 0:
		return 0
	if idx <= 3:
		return 2 * idx - 1
	if idx <= 6:
		return 3 * idx - 4
	return 5 * idx - 16


func on_size_changed() -> void:
	window_size_changed.emit(Tools.get_window_size(self))


func set_locale(locale: String) -> void:
	if locale == ConfigCtl.LOCALE_SYSTEM:
		var preferred_locale = OS.get_locale_language()
		TranslationServer.set_locale(preferred_locale)
	else:
		TranslationServer.set_locale(locale)
