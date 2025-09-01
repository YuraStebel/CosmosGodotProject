extends Node

var max_oxygen: float = 100
var current_oxygen: float
var oxygen_decrease_rate: float = 1.0
var oxygen_reloading_rate: float = 10.0


var is_in_oxygen_zone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_oxygen = max_oxygen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_in_oxygen_zone:
		current_oxygen = min(current_oxygen + oxygen_reloading_rate * delta, max_oxygen)
	else:
		current_oxygen = max(current_oxygen - oxygen_decrease_rate * delta, 0)
	print(current_oxygen)
