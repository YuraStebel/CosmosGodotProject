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

@rpc('any_peer', 'call_local')
func drop_item_request():
	var sender_id = multiplayer.get_remote_sender_id()
	print(sender_id)
	for p in players:
		if p.name == str(sender_id):
			var obj = p.get_node("Hand").get_child(0)
			if obj:
				var obj_path = obj.get_path()
				drop_item.rpc(obj_path)
				#obj.freeze = false

@rpc('authority', 'call_local')
func drop_item(item_path):
	var obj = get_node_or_null(item_path)
	if obj:
		obj.queue_free()
	
