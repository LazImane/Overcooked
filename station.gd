extends Area2D

@export var station_type: String = "chop"
var current_item: String = ""
#adding graphics
@onready var sprite = $Sprite2D
@onready var label = $Label

func _ready() :
	setup_station_graphics()
	update_appearance()
	
func setup_station_graphics():
	if sprite :
		match station_type:
			"ingredients":
				sprite.texture = load("res://assets/stations/ingredients.png")
			"chop":
				sprite.texture = load("res://assets/stations/chop.png")
			"cook":
				sprite.texture = load("res://assets/stations/cook.png")
			"serve":
				sprite.texture = load("res://assets/stations/serve.png")
				
func update_appearance():
	if label:
		if current_item == "":
			label.text = station_type + "\n[Empty]"
		else :
			label.text = station_type + "\n" + current_item
	if sprite :
		if current_item != "" :
			sprite.modulate = Color(0.8,1.0,0.8)
		else :
			sprite.modulate = Color(1,1,1)

func interact():
	match station_type:
		"ingredients":
			if current_item == "":
				current_item = "tomato"
				print("Spawned ingredient:", current_item)
			else :
				print("Station already has:", current_item)
		"chop":
			if current_item == "":
				print("Chop station empty - need ingredient")
			elif current_item == "tomato": #we will later make this more complicated than an if-case scenario trust 
				current_item = "chopped_tomato"
				print("Chopped into:", current_item)
			else:
				print("Can't chop ", current_item)
		"cook":
			if current_item == "":
				print("Cook station empty - need chopped ingredient")
			elif current_item == "chopped_tomato":
				current_item = "cooked_tomato"
				print("Cooked into:", current_item)
			else:
				print("Can't cook ", current_item)
		"serve":
			if current_item == "cooked_tomato":
				print("Served dish! +1 point")
				current_item = ""
			else:
				print("Need cooked meal to serve, got: ", current_item)
	update_appearance()
	
#LATER ON ADD PLAYER INTERACTION with the stations HERE

#debugging for later
func _input_event(viewport, event, shape_idx):
	# Allow clicking on stations for testing
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			interact()

func _on_mouse_entered():
	# Visual feedback when hovering
	if sprite:
		sprite.scale = Vector2(1.1, 1.1)

func _on_mouse_exited():
	# Reset scale when not hovering
	if sprite:
		sprite.scale = Vector2(1.0, 1.0)
