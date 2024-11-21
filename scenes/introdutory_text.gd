extends Control

func _ready():
	$VBoxContainer/continuar.grab_focus()

func _on_continuar_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/town.tscn")
