extends Node3D
#
#@onready var neck: Node3D = $"../RigidBody3D/Neck"
#var mouse_sens: float = 0.005
#
#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#
##
#func _process(delta: float) -> void:
	#global_position = neck.global_position
#
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotate_object_local(Vector3.UP, -event.relative.x * mouse_sens)
		#rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sens)
	#
#
#func _physics_process(delta: float) -> void:
	#if Input.is_action_pressed("lean_left"):
		#rotate_object_local(Vector3.BACK, mouse_sens)
	#if Input.is_action_pressed("lean_righ"):
		#rotate_object_local(Vector3.BACK, -mouse_sens)
