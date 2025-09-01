extends Node

#КИСЛОРОД
var max_oxygen: float = 100
var current_oxygen: float
var oxygen_decrease_rate: float = 1.0
var oxygen_reloading_rate: float = 10.0
var is_in_oxygen_zone = false

#HUD
@onready var control_node: Control = $"../Control"
@onready var oxygen_bar = $"../Control/HUD/OxygenBar"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_multiplayer_authority():
		return
	
	control_node.show()
	current_oxygen = max_oxygen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
		
	if is_in_oxygen_zone:
		current_oxygen = min(current_oxygen + oxygen_reloading_rate * delta, max_oxygen)
	else:
		current_oxygen = max(current_oxygen - oxygen_decrease_rate * delta, 0)
	print(current_oxygen)
	
	oxygen_bar.value = current_oxygen
