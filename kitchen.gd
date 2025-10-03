extends Node2D
class_name KitchenEnv

var ingredient_station = {"type":"ingredients", "item":""}
var chop_station = {"type":"chop", "item":""}
var cook_station = {"type":"cook", "item":""}
var serve_station = {"type":"serve", "item":""}

# Return current state
func get_state():
	return {
		"ingredient": ingredient_station["item"],
		"chop": chop_station["item"],
		"cook": cook_station["item"],
		"serve": serve_station["item"]
	}

# Execute an action
func step(action: String):
	match action:
		"spawn":
			if ingredient_station["item"] == "":
				ingredient_station["item"] = "tomato"
				print("[Env] Spawned ingredient")
		"chop":
			if ingredient_station["item"] != "" and chop_station["item"] == "":
				chop_station["item"] = "chopped_" + ingredient_station["item"]
				ingredient_station["item"] = ""
				print("[Env] Chopped ingredient")
		"cook":
			if chop_station["item"] != "" and cook_station["item"] == "":
				cook_station["item"] = "cooked_" + chop_station["item"].replace("chopped_","")
				chop_station["item"] = ""
				print("[Env] Cooked ingredient")
		"serve":
			if cook_station["item"] != "" and serve_station["item"] == "":
				print("[Env] Served:", cook_station["item"])
				cook_station["item"] = ""
				serve_station["item"] = ""
