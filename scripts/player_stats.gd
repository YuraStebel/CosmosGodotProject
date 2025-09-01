extends Node

# Настройки кислорода
@export var max_oxygen: float = 100.0
@export var oxygen_consumption_rate: float = 1.0  # Потребление в секунду
@export var oxygen_recovery_rate: float = 5.0     # Восстановление в секунду

var current_oxygen: float
var is_in_oxygen_zone: bool = false

@onready var oxygen_bar = $"../HUD/OxygenBar"

func _ready():
	current_oxygen = max_oxygen

func _process(delta):
	if is_multiplayer_authority():
		update_oxygen(delta)
		sync_oxygen_state()

# Обновление уровня кислорода
func update_oxygen(delta):
	if is_in_oxygen_zone:
		# Восстановление кислорода
		current_oxygen = min(current_oxygen + oxygen_recovery_rate * delta, max_oxygen)
	else:
		# Потребление кислорода
		current_oxygen = max(current_oxygen - oxygen_consumption_rate * delta, 0)
	
	if current_oxygen == 100:
		oxygen_bar.visible = false
	else:
		oxygen_bar.visible = true
	oxygen_bar.value = current_oxygen
	
	# Проверка на смерть от удушья
	if current_oxygen <= 0:
		handle_oxygen_depletion()

func handle_oxygen_depletion():
	# Здесь реализуйте логику смерти/урона от нехватки кислорода
	print("Игрок задыхается!")
	# Например: get_parent().take_damage(10)

# Синхронизация состояния кислорода
func sync_oxygen_state():
	if multiplayer.is_server():
		rpc("update_oxygen_on_clients", current_oxygen)

@rpc("any_peer", "reliable")
func update_oxygen_on_clients(oxygen_level):
	current_oxygen = oxygen_level

# Методы для входа/выхода из кислородной зоны
func enter_oxygen_zone():
	is_in_oxygen_zone = true
	if multiplayer.is_server():
		rpc("set_oxygen_zone_state", true)

func exit_oxygen_zone():
	is_in_oxygen_zone = false
	if multiplayer.is_server():
		rpc("set_oxygen_zone_state", false)

@rpc("any_peer", "reliable")
func set_oxygen_zone_state(state):
	is_in_oxygen_zone = state

# Получение текущего уровня кислорода (для UI)
func get_oxygen_percentage() -> float:
	return current_oxygen / max_oxygen
