extends CharacterBody2D

class_name Player

@export var walk_speed = 4.0

@onready var animation_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

const TILE_SIZE = 16

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_tree.active = true
	initial_position = position
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)

func _on_spawn(position: Vector2, direction: String):
	global_position = position
	animation_player.play("Walk" + direction)
	animation_player.stop()

func _physics_process(delta):
	#if player_state == PlayerState.TURNING or stop_input:
		#return
	if is_moving == false:
		process_player_movement_input() # Verifique se essa função está implementada corretamente
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta) # Verifique se essa função move() existe e está implementada corretamente
	else:
		anim_state.travel("Idle")
		is_moving = false

func process_player_movement_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		initial_position = position
		is_moving = true
	else:
		anim_state.travel("Idle")


		
func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (TILE_SIZE * input_direction)
		percent_moved_to_next_tile = 0.0
		is_moving = false
	else:
		position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)

func _on_collision_area_entered(area):
	is_moving = false
