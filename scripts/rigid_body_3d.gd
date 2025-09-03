extends RigidBody3D

@onready var camera = $Neck/Camera3D

var move_force: float = 250.0
var mouse_sens: float = 3.0
var roll_force: float = 50.0

@onready var stats = $Stats

@onready var interact_cast = $Neck/InteractionCast

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	
	$ChibinautModel.hide()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	if stats.is_alive:
		if event is InputEventMouseMotion:
			var local_torque = Vector3(
				-event.relative.y * mouse_sens,
				-event.relative.x * mouse_sens,
				0
			)
			
			var world_torque = transform.basis * local_torque
			apply_torque(world_torque)

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if stats.is_alive:
		var horizontal_dir := Input.get_vector("left", "righ", "forward", "backward")
		var vertical_dir := Input.get_axis("down", "up")
		var roll_dir := Input.get_axis("lean_left", "lean_right")
		#print(horizontal_dir)
		apply_central_force(transform.basis * Vector3(horizontal_dir.x, vertical_dir, horizontal_dir.y) * move_force)
		
		apply_torque(transform.basis * Vector3(0.0, 0.0, -roll_dir * roll_force))
		
	
		use()

func use():
	var get_collision = interact_cast.get_collider()
	
	if Input.is_action_just_pressed("use"):
		if get_collision and get_collision.is_in_group("pickable"):
			get_tree().current_scene.try_pickup_item.rpc(get_collision.get_path())
