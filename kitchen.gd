extends Node2D

@onready var tilemap = $TileMap

func _ready():
	# Position all station nodes in a row
	var x = 100
	for station in get_children():
		if station is Area2D:
			station.position = Vector2(x, 200)
			x += 200
	print("Kitchen ready! Click stations to test.")
	print("Stations: Ingredients -> Chop -> Cook -> Serve")
	
