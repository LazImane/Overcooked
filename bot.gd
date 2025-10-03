extends CharacterBody2D
# Agent loop: see -> next -> action -> act

enum Act { MOVE_TO_STATION, INTERACT, NONE }

@export var speed := 140.0
@export var accel := 800.0
@export var stop_distance := 12.0
@export var station_path: NodePath   # drag your Station (Area2D) here

var station: Area2D

# -------- internal state I (intentions, memory, flags) ----------
var I := {
	"target": Vector2.ZERO,   # where to go next
	"done": false
}

func _ready() -> void:
	station = get_node_or_null(station_path)
	if station == null:
		push_error("Bot: assign station_path (your single Station node).")
		set_physics_process(false)
		return

	I.target = station.position
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# --- see : E -> Per (build percept) ---
	var per := see()

	# --- next : I × Per -> I (update internal state) ---
	next(I, per)

	# --- action : I -> Ac (choose an action) ---
	var a: Act = action(I)

	# --- act (execute) ---
	act(a, delta)

	# character movement integration
	move_and_slide()

# ------------------- AGENT FUNCTIONS -------------------

func see() -> Dictionary:
	# Percept contains what we "sense" about environment
	return {
		"bot_pos": position,
		"station_pos": station.position,
		"near_station": position.distance_to(station.position) <= stop_distance
	}

func next(state: Dictionary, per: Dictionary) -> void:
	# With one station, our intention is always to be at the station unless done
	if not state.done:
		state.target = per.station_pos

func action(state: Dictionary) -> Act:
	if state.done:
		return Act.NONE
	var near_station := position.distance_to(station.position) <= stop_distance

	# Deductive-style priority rules:
	#  1) if near(station) -> INTERACT
	#  2) else -> MOVE_TO_STATION
	if near_station:
		return Act.INTERACT
	return Act.MOVE_TO_STATION

func act(a: Act, delta: float) -> void:
	match a:
		Act.MOVE_TO_STATION:
			var to_target: Vector2 = I.target - position
			var desired: Vector2 = to_target.normalized() * speed if to_target.length() > 0.001 else Vector2.ZERO
			velocity = velocity.move_toward(desired, accel * delta)
		Act.INTERACT:
			velocity = velocity.move_toward(Vector2.ZERO, accel * delta)
			if station and station.has_method("interact"):
				station.interact()
			I.done = true
		Act.NONE:
			velocity = velocity.move_toward(Vector2.ZERO, accel * delta)
