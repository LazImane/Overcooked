extends CharacterBody2D

@export var speed = 200
var current_station: Node = null

func _process(delta):
	var input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	
	# Set velocity and call move_and_slide
	velocity = input_dir.normalized() * speed
	move_and_slide()
	
func _input(event):
	if current_station:
		current_station.interact()

func set_current_station(station):
	current_station = station
