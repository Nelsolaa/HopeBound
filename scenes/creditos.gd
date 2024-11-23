extends Control

func _ready():
	$VBoxContainer/terminar_jogo.grab_focus()



func _on_terminar_jogo_pressed() -> void:
	get_tree().quit()

func _on_reniciar_jogo_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/introdutory_text.tscn")
