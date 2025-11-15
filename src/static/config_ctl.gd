class_name ConfigCtl
extends Object

## Static helpers for config file handling.

const CONFIG_FILE: StringName = &"user://config.ini"

# Section names.
const SOUND_VOLUME: StringName = &"SoundVolume"
const PREFS: StringName = &"Prefs"

static var prefs := {background = 0, show_tutorial = true}


static func get_pref(pref_name: StringName) -> Variant:
	return prefs[pref_name]


static func set_pref(pref_name: StringName, value: Variant) -> void:
	prefs[pref_name] = value
	update_config()


## Loads a global config file and sets values described there.
static func load_config() -> void:
	var config := ConfigFile.new()
	var err := config.load(CONFIG_FILE)

	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			update_config(config)
		return

	# sound levels
	for bus in SoundCtl.adjustable_sound_buses():
		var value = config.get_value(
			SOUND_VOLUME, AudioServer.get_bus_name(bus), AudioServer.get_bus_volume_db(bus)
		)

		SoundCtl.set_volume(bus, clamp(value, SoundCtl.MIN_VOLUME, SoundCtl.MAX_VOLUME))

	# prefs
	for x in prefs:
		var new_pref = config.get_value(PREFS, x)
		prefs[x] = prefs[x] if new_pref == null else new_pref


## Actualizes values and stores them in the global config file. Opens a file if
## [code]config[/code] not provided.
static func update_config(config: ConfigFile = null) -> void:
	if config == null:
		config = ConfigFile.new()
		if config.load(CONFIG_FILE) != OK:
			return

	# sound levels
	for bus in SoundCtl.adjustable_sound_buses():
		config.set_value(
			SOUND_VOLUME, AudioServer.get_bus_name(bus), AudioServer.get_bus_volume_db(bus)
		)

	# prefs
	for x in prefs:
		config.set_value(PREFS, x, prefs[x])

	config.save(CONFIG_FILE)
