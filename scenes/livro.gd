extends Area2D


class_name Book

var points = 1
static var total = 0
#print("oi")

func _on_body_entered(body):
	visible = false
	total += 1
	print("Total: "+ str(total))
	numero_livros()

func numero_livros():
	if total >= 4:
		print("terminou")
		get_tree().change_scene_to_file("res://scenes/creditos.tscn")
