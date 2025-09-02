extends RigidBody3D

var ITEM_ID: int = 1
var is_using: bool = false
var heal_power = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	healing(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("use"):
		is_using = true
	else:
		is_using = false

func healing(delta):
	if get_parent().get_parent().is_in_group("player"):
		if is_using:
			get_parent().get_parent().get_node("Stats").current_health += delta * heal_power
