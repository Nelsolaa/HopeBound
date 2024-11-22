extends CharacterBody2D

@export var walk_speed = 4.0
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
#@onready var ray = $BlockingRayCast2D
@onready var ray = $RayCast2D


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

	

func _physics_process(delta):
	#print("player state is right now: " + str(player_state))
	if player_state == PlayerState.TURNING:
#		PROBLEMA NESSA LINHA DE CODIGO, GERANDO UM LOOP INFINITO
		return
	elif is_moving == false:
		#print("is_moving == false")
		process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		#print("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		#print("Idle")
		is_moving = false

func process_player_movement_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		#print(input_direction.x)
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		#print(input_direction.y)
		

	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		
		if need_to_turn():
			#print("turning")
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
			
		else:
			#print("walking")
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")

func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
		
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false

func finished_turning():
	player_state = PlayerState.IDLE

		
func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
		else:
			position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
	else:
		is_moving = false
