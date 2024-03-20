extends Control

@export var address = "127.0.0.1"
@export var port = 80
var peer

func _ready():
	$VBoxContainer/StartButton.grab_focus()
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass

func _on_start_button_pressed():
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true
	$VBoxContainer2/HostButton.grab_focus()
	pass

func _on_options_button_pressed():
	pass

func _on_quit_button_pressed():
	get_tree().quit()
	pass

func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		print("could not host: " + str(error))
		return
	multiplayer.set_multiplayer_peer(peer)
	$VBoxContainer2/HostButton.disabled = true
	$VBoxContainer2/JoinButton.disabled = true
	print("hosting successful")
	pass

func _on_join_button_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.set_multiplayer_peer(peer)
	$VBoxContainer2/HostButton.disabled = true
	$VBoxContainer2/JoinButton.disabled = true
	$VBoxContainer2/StartGameButton.disabled = true
	pass

# on server and client
func peer_connected(id):
	print("peer connected: " + str(id))
	pass

# on server and client
func peer_disconnected(id):
	print("peer disconnected " + str(id))
	pass

# on clients
func connected_to_server():
	print("connection successful")
	pass

# on clients
func connection_failed():
	print("connection failed")
	pass

func _on_start_game_button_pressed():
	load_game()
	pass

func load_game():
	var scene = load("res://game/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.generate_map()
	self.hide()
	rpc("sync_game", scene.get_map_data())
	pass

@rpc
func sync_game(map_data_array):
	var scene = load("res://game/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.load_map(map_data_array)
	self.hide()
	pass
