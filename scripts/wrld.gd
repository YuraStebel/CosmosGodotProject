extends Node3D

@onready var main_menu = $CanvasLayer
@onready var adress_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AdressEntry

const Player = preload("res://scenes/player.tscn")
const PORT = 9999 
var enet_peer = ENetMultiplayerPeer.new()

var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_button_pressed() -> void:
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
func _on_join_button_pressed() -> void:
	main_menu.hide()
	if adress_entry.text != null:
		enet_peer.create_client(adress_entry.text, PORT)
	else:
		enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	players.append(player)
	add_child(player)
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func find_player(id):
	for p in players:
		if p.name == str(id):
			return p

@rpc('any_peer', 'call_local')
func try_pickup_item(item_path):
	var sender_id = multiplayer.get_remote_sender_id()
	var requesting_player = find_player(sender_id)
	
	var item = get_node_or_null(item_path)
	if item and item is RigidBody3D:
		if multiplayer.is_server():
			give_item_to_player.rpc(requesting_player.get_path(), item_path)
			destroy_item.rpc(item_path)

@rpc('authority', 'call_local')
func give_item_to_player(player_path, item_path):
	var player = get_node_or_null(player_path)
	var item = get_node_or_null(item_path)
	
	if player and item and item is RigidBody3D:
		item.freeze = true
		item.reparent(player.get_node("Hand"))
		item.position = Vector3.ZERO
		print(item.position)

@rpc('authority', 'call_local')
func destroy_item(item_path):
	var item = get_node_or_null(item_path)
	if item:
		item.queue_free()
