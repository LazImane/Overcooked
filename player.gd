extends CharacterBody2D

@export var speed = 200
var current_station: Node = null
var env=null # reference to the kitchen

func _init(kitchen_node = null):
	env = kitchen_node
func act():
	var state = env.get_state()
	
	# Loop through pipeline: spawn → chop → cook → serve
	if state["ingredient"] == "":
		env.step("spawn")
	elif state["chop"] == "" and state["ingredient"] != "":
		env.step("chop")
	elif state["cook"] == "" and state["chop"] != "":
		env.step("cook")
	elif state["serve"] == "" and state["cook"] != "":
		env.step("serve")
func _input(event):
	if current_station:
		current_station.interact()

func set_current_station(station):
	current_station = station
	
	
func _process(delta):
	act()
