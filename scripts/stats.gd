extends Node

#КИСЛОРОД
var max_oxygen: float = 2
var current_oxygen: float
var oxygen_decrease_rate: float = 1.0
var oxygen_reloading_rate: float = 10.0
var is_in_oxygen_zone = false

#ЗДОРОВЬЕ
var max_health: float = 50
var current_health: float
var health_decrease_by_oxygen_rate: float = 5
var is_alive = true

#HUD
@onready var control_node: Control = $"../HUD"
@onready var oxygen_bar = $"../HUD/HBoxContainer/OxygenBar"
@onready var health_bar = $"../HUD/VBoxContainer2/HealthBar"
@onready var vignette = $"../HUD/VignetteContainer"
@onready var low_oxygen_animationplayer = $"../HUD/HBoxContainer/AnimationPlayer"

#ЗВУКИ дыхание
@onready var soundplayer_breath = $"../Sounds/Breath"
var should_soundplayer_breath_play: bool = false
@export var breathing_normal = "res://sounds/player/breathing.mp3"
@export var breathing_no_oxygen = "res://sounds/player/breathing_no_oxygen.ogg"

#ЗВУКИ здоровье
@onready var soundplayer_heartbeat = $"../Sounds/Heart"
@onready var soundplayer_death = $"../Sounds/Death"
var should_soundplayer_heart_play: bool = false
var was_played_death_sound: bool = false


func _ready() -> void:
	if not is_multiplayer_authority():
		return
	
	control_node.show()
	current_oxygen = max_oxygen
	current_health = max_health


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	oxygen_bar.max_value = max_oxygen
	health_bar.max_value = max_health
	
	breathing_system(delta)
	health_system(delta)


#ДЫХАНИЕ
func breathing_system(delta):
	if !is_alive: return
	
	#отнимаем или пополняем кислород
	if is_in_oxygen_zone:
		current_oxygen = min(current_oxygen + oxygen_reloading_rate * delta, max_oxygen)
		should_soundplayer_breath_play = false
		low_oxygen_animationplayer.play("RESET")
	else:
		current_oxygen = max(current_oxygen - oxygen_decrease_rate * delta, 0)
		should_soundplayer_breath_play = true
	
	#скрываем полоску при полном кислороде
	if current_oxygen == max_oxygen:
		oxygen_bar.visible = false
	else:
		oxygen_bar.visible = true
	
	#отнимаем здоровье когда нет кислорода
	if current_oxygen <= 0:
		current_health = max(current_health - health_decrease_by_oxygen_rate * delta, 0)
	
	#анимация при низком количестве кислорода
	if current_oxygen <= (max_oxygen * 0.3) and current_oxygen > (max_oxygen * 0.15):
		low_oxygen_animationplayer.play("oxygen_warning_base")
	elif current_oxygen <= (max_oxygen * 0.15):
		low_oxygen_animationplayer.play("oxygen_warning_agressive")
	else:
		low_oxygen_animationplayer.play("RESET")
	
	#персонаж дышит тут
	if should_soundplayer_breath_play and not soundplayer_breath.playing:
		soundplayer_breath.play()
	elif not should_soundplayer_breath_play and soundplayer_breath.playing:
		soundplayer_breath.stop()
		
	#переключение звуков дыхания
	if current_oxygen > 0:
		if soundplayer_breath.stream != load(breathing_normal):
			soundplayer_breath.stream = load(breathing_normal)
	else:
		if soundplayer_breath.stream == load(breathing_normal):
			soundplayer_breath.stream = load(breathing_no_oxygen)
	
	oxygen_bar.value = current_oxygen


#ЗДОРОВЬЕ
func health_system(delta):
	if current_health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
	
	current_health = min(current_health, max_health)
	
	if current_health < 50:
		should_soundplayer_heart_play = true
	else:
		should_soundplayer_heart_play = false
	
	soundplayer_heartbeat.volume_db = remap(current_health, 50, 0, -20, 0)
	
	if is_alive:
		if should_soundplayer_heart_play and not soundplayer_heartbeat.playing:
			soundplayer_heartbeat.play()
		elif not should_soundplayer_heart_play and soundplayer_heartbeat.playing:
			soundplayer_breath.stop()
	
	if current_health == 0:
		is_alive = false
		soundplayer_heartbeat.stop()
		soundplayer_breath.stop()
		play_death_sound.rpc()
		
		
	
	vignette.modulate = Color(1,1,1, 1 - current_health / 100)
	
	
	health_bar.value = current_health

@rpc("call_local")
func play_death_sound():
	if not soundplayer_death.playing and not was_played_death_sound:
		soundplayer_death.play()
		was_played_death_sound = true
