extends Node

#КИСЛОРОД
var max_oxygen: float = 5
var current_oxygen: float
var oxygen_decrease_rate: float = 1.0
var oxygen_reloading_rate: float = 10.0
var is_in_oxygen_zone = false

#ЗДОРОВЬЕ
var max_health: float = 100.0
var current_health: float
var health_decrease_by_oxygen_rate: float = 10.0
var is_alive = true
#HUD
@onready var control_node: Control = $"../HUD"
@onready var oxygen_bar = $"../HUD/VBoxContainer/OxygenBar"
@onready var health_bar = $"../HUD/VBoxContainer2/HealthBar"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_multiplayer_authority():
		return
	
	control_node.show()
	current_oxygen = max_oxygen
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
		
	if is_in_oxygen_zone:
		current_oxygen = min(current_oxygen + oxygen_reloading_rate * delta, max_oxygen)
	else:
		current_oxygen = max(current_oxygen - oxygen_decrease_rate * delta, 0)
	
	if current_oxygen == max_oxygen:
		oxygen_bar.visible = false
	else:
		oxygen_bar.visible = true
	if current_health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
	
	if current_oxygen <= 0:
		current_health = max(current_health - health_decrease_by_oxygen_rate * delta, 0)
	
	if current_health == 0:
		is_alive = false
	
	print(current_health)
	oxygen_bar.value = current_oxygen
	health_bar.value = current_health
