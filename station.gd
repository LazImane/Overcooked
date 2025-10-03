extends Area2D

@export var station_type: String = "ingredients"
var current_item: String = ""

func interact():
	match station_type:
		"ingredients":
			current_item = "tomato"
			print("Spawned ingredient:", current_item)

		"chop":
			if current_item == "tomato":
				current_item = "chopped_tomato"
				print("Chopped into:", current_item)

		"cook":
			if current_item == "chopped_tomato":
				current_item = "cooked_tomato"
				print("Cooked into:", current_item)

		"serve":
			if current_item == "cooked_tomato":
				print("Served dish! +1 point")
				current_item = ""
