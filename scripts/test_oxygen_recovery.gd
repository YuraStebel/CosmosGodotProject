# oxygen_zone.gd
extends Area3D

@export var recovery_multiplier: float = 1.0  # Множитель восстановления

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("enter_oxygen_zone"):
		body.enter_oxygen_zone()

func _on_body_exited(body):
	if body.has_method("exit_oxygen_zone"):
		body.exit_oxygen_zone()
