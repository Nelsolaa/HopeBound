extends Control

func _ready():
	$VBoxContainer/terminar_jogo.grab_focus()



func _on_terminar_jogo_pressed() -> void:
	get_tree().quit()
