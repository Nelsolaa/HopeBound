extends Node

const scene_town = preload("res://scenes/town.tscn")
const scene_left_town = preload("res://scenes/left_town.tscn")
const scene_up_town = preload("res://scenes/up_town - Copia.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"town":
			scene_to_load = scene_town
		"lef_twon":
			scene_to_load = scene_left_town
		"up_town":
			scene_to_load = scene_up_town
	if scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
