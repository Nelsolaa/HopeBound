extends Node2D

class_name Level_test

const _DIALOG_SCREEN:PackedScene = preload("res://scenes/dialog_screen.tscn") 
var _dialog_data: Dictionary = {
	0:{
		"title": "Mago",
		"dialog": "Testando!"
	}
}
@export_category("Objects")
@export var _hud: CanvasLayer = null
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("ui_accept"):
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instanciate
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)
		
