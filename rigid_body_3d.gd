extends RigidBody3D


@onready var cam_holder: Node3D = $"../CameraHolder"
var move_force: float = 10.0
var mouse_sens: float = 0.00005


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#rotate_object_local(Vector3.UP, -event.relative.x * mouse_sens)
		#rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sens)
		apply_torque(transform.basis * Vector3(-event.relative.y, -event.relative.x, 0.0))
		print(event.relative)
		print("))")




func _physics_process(delta: float) -> void:
	var horizontal_dir := Input.get_vector("left", "righ", "forward", "backward")
	var vertical_dir := Input.get_axis("down", "up")
	#print(horizontal_dir)
	apply_central_force(transform.basis * Vector3(horizontal_dir.x, vertical_dir, horizontal_dir.y) * move_force)
	
	#print(angular_velocity)
