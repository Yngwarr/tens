extends PopupPanel

## Spawn this window wherever and whenever you want to change your game options.

## Grid container that will be populated with control elements.
@export var container: GridContainer
@export var music_texture: Texture2D
@export var sfx_texture: Texture2D
@export var locale_texture: Texture2D

var sliders: Array[VolumeSlider] = []
var locales: PackedStringArray = []


func _ready() -> void:
	visibility_changed.connect(on_toggle)

	locales = TranslationServer.get_loaded_locales()

	for bus in SoundCtl.adjustable_sound_buses():
		if bus != 0:
			sliders.append(add_bus_ctl(bus))

	add_locale_dropdown()


func on_toggle() -> void:
	ScreenFader.visible = visible

	if not visible:
		ConfigCtl.update_config()
		return

	for s in sliders:
		s.update_value()

	sliders[0].grab_focus()


## Adds bus control to the window.
func add_bus_ctl(bus_idx: int) -> VolumeSlider:
	var bus_name := AudioServer.get_bus_name(bus_idx)

	var rect := TextureRect.new()
	if bus_name == "Music":
		rect.texture = music_texture
	else:
		rect.texture = sfx_texture

	var slider := VolumeSlider.new(bus_idx)

	container.add_child(rect)
	container.add_child(slider)

	return slider


func add_locale_dropdown() -> void:
	var dropdown := OptionButton.new()
	dropdown.add_item("System")

	var current_locale: String = ConfigCtl.get_pref(&"locale")

	for locale in locales:
		dropdown.add_item(TranslationServer.get_language_name(locale))

		if locale == current_locale:
			dropdown.select(dropdown.item_count - 1)

	dropdown.item_selected.connect(on_locale_selected)

	var rect := TextureRect.new()
	rect.texture = locale_texture

	container.add_child(rect)
	container.add_child(dropdown)


func on_locale_selected(index: int) -> void:
	var locale = ConfigCtl.LOCALE_SYSTEM if index == 0 else locales[index - 1]

	Global.set_locale(locale)
	ConfigCtl.set_pref(&"locale", locale)
