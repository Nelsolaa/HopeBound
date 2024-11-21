extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var transition_fx = preload("res://Assets/Music/retro-coin-4-236671.mp3")

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false

func transition():
	color_rect.visible = true
	GlobalAudioStreamPlayer.play_FX(transition_fx, -12.0)
	animation_player.play("fade_to_black")
