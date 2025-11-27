@tool
class_name Stats
extends Object

const STATS_FILE := &"user://stats.ini"
const STATS_SECTION := &"Stats"

static var data := {
	games_played = {name = "STATS_GAMES", value = 0},
	best_score = {name = "STATS_BEST", value = 0},
	total_score = {name = "STATS_TOTAL", value = 0}
}


static func get_stat(stat_name: StringName) -> int:
	return data[stat_name].value


static func set_stat(stat_name: StringName, value: int) -> void:
	data[stat_name].value = value


static func reset_stats() -> void:
	data.games_played.value = 0
	data.best_score.value = 0
	data.total_score.value = 0

	write_stats()

static func increase_stat(stat_name: StringName, inc_value: int) -> void:
	data[stat_name].value += inc_value


static func read_stats() -> void:
	var file := ConfigFile.new()
	var err := file.load(STATS_FILE)

	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			write_stats()
		else:
			print("Error when parsing stats: %s" % err)
		return

	for x in data:
		data[x].value = file.get_value(STATS_SECTION, x, 0)


static func write_stats() -> void:
	var file := ConfigFile.new()
	var err := file.load(STATS_FILE)

	if err != OK and err != ERR_FILE_NOT_FOUND:
		print("Can't write stats file, errcode = %s" % err)
		return

	for x in data:
		file.set_value(STATS_SECTION, x, data[x].value)

	file.save(STATS_FILE)
