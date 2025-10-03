extends Area2D

@export var station_type: String = "serve"
var current_item: String = ""

# We'll create these in code, so no @onready needed
var color_rect: ColorRect
var label: Label
var collision_shape: CollisionShape2D

var station_colors = {
	"ingredients": Color("6ab04c"),  # Green
	"chop": Color("f9ca24"),         # Yellow
	"cook": Color("eb4d4b"),         # Red
	"serve": Color("4834d4")         # Blue
}

func _ready():
	create_visual_components()  # Create the nodes first!
	setup_station_graphics()
	update_appearance()

func create_visual_components():
	# Create ColorRect if it doesn't exist
	if not has_node("ColorRect"):
		color_rect = ColorRect.new()
		color_rect.name = "ColorRect"
		color_rect.size = Vector2(120, 120)
		color_rect.position = Vector2(-60, -60)
		add_child(color_rect)
	else:
		color_rect = $ColorRect
	
	# Create Label if it doesn't exist
	if not has_node("Label"):
		label = Label.new()
		label.name = "Label"
		label.position = Vector2(-50, -80)
		label.size = Vector2(100, 160)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		add_child(label)
	else:
		label = $Label
	
	# Create CollisionShape2D if it doesn't exist
	if not has_node("CollisionShape2D"):
		collision_shape = CollisionShape2D.new()
		collision_shape.name = "CollisionShape2D"
		add_child(collision_shape)
	else:
		collision_shape = $CollisionShape2D
	
	# Setup collision shape
	var rectangle = RectangleShape2D.new()
	rectangle.size = Vector2(100, 100)
	collision_shape.shape = rectangle
	
	# Enable input
	input_pickable = true
	
func setup_station_graphics():
	if color_rect:
		var base_color = station_colors.get(station_type, Color.GRAY)
		color_rect.color = base_color
		color_rect.modulate = base_color.darkened(0.2)
			
func update_appearance():
	if label:
		if current_item == "":
			label.text = station_type + "\n[Empty]"
		else:
			label.text = station_type + "\n" + current_item
	
	if color_rect:
		if current_item != "":
			color_rect.color = color_rect.color.lightened(0.3)
			var tween = create_tween()
			tween.tween_property(color_rect, "scale", Vector2(1.1, 1.1), 0.2)
		else:
			var base_color = station_colors.get(station_type, Color.GRAY)
			color_rect.color = base_color
			var tween = create_tween()
			tween.tween_property(color_rect, "scale", Vector2(1.0, 1.0), 0.2)

func interact():
	match station_type:
		"ingredients":
			if current_item == "":
				current_item = "tomato"
				print("Spawned ingredient:", current_item)
			else:
				print("Station already has:", current_item)

		"chop":
			if current_item == "":
				print("Chop station empty - need ingredient")
			elif current_item == "tomato":
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

func can_take_item() -> bool:
	return current_item != ""

func take_item() -> String:
	var item = current_item
	current_item = ""
	update_appearance()
	return item

func can_place_item() -> bool:
	return current_item == ""

func place_item(item: String) -> bool:
	if can_place_item():
		current_item = item
		update_appearance()
		return true
	return false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			interact()

func _on_mouse_entered():
	if color_rect:
		color_rect.scale = Vector2(1.1, 1.1)

func _on_mouse_exited():
	if color_rect:
		color_rect.scale = Vector2(1.0, 1.0)
