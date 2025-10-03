extends Node2D

#4 stations: ingredients, chop, cook, serve
var ingredient_station = {"type":"ingredients", "item":""}
var chop_station = {"type":"chop", "item":""}
var cook_station = {"type":"cook", "item":""}
var serve_station = {"type":"serve", "item":""}

func _ready():
	print("Demo Kitchen ready! Press Enter to run one step of the pipeline.")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		step_pipeline()

func step_pipeline():
	# 1) Ingredients station
	if ingredient_station["item"] == "":
		ingredient_station["item"] = "tomato"
		print("[Ingredients] Spawned:", ingredient_station["item"])

	# 2) Chopping station
	if ingredient_station["item"] != "" and chop_station["item"] == "":
		chop_station["item"] = "chopped_" + ingredient_station["item"]
		print("[Chop] Chopped:", chop_station["item"])
		ingredient_station["item"] = "" # item moved

	# 3) Cooking station
	if chop_station["item"] != "" and cook_station["item"] == "":
		cook_station["item"] = "cooked_" + chop_station["item"].replace("chopped_","")
		print("[Cook] Cooked:", cook_station["item"])
		chop_station["item"] = "" # item moved

	# 4) Serving station
	if cook_station["item"] != "" and serve_station["item"] == "":
		serve_station["item"] = cook_station["item"]
		print("[Serve] Served:", serve_station["item"], "✅")
		cook_station["item"] = "" # item moved
		serve_station["item"] = "" # reset for next round
