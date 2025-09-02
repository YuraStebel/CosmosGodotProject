extends RigidBody3D

const ITEM_ID: int = 1
var is_using: bool = false
var heal_power = 20
var heal_charge = 100
 

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("use"):
		is_using = true
	else:
		is_using = false
	
	healing(delta)


func healing(delta):
	if get_parent().get_parent().is_in_group("player"):
		if is_using and heal_charge > 0:
			get_parent().get_parent().get_node("Stats").current_health += delta * heal_power
			heal_charge -= heal_power * delta
		
			
	
	if heal_charge <= 0:
		destroy_item.rpc()

@rpc('call_local')
func destroy_item():
	queue_free()
