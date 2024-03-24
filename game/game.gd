extends Node2D

var peer = ENetMultiplayerPeer.new()
var port = 135
var generated = false

func generate_map():
	$World.generate_map()
	return $World.get_data_array()
	pass

func load_map(data_array):
	$World.load_map_from_data_array(data_array)
	pass

func get_map_data():
	return $World.get_data_array()

func find_spawn_point():
	return $World.find_spawn_point()


func _on_join_pressed():
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer
	$Camera2D.enabled = false
	pass


func _on_host_pressed():
	generate_map()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(spawn_player)
	spawn_player()
	$Camera2D.enabled = false
	pass

@rpc
func receive_map_data(data_array):
	var scene = load("res://game/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.load_map(data_array)
	pass

func spawn_player(player_id=1):
	var scene = get_tree().root.get_node("Game")
	var player = load("res://player/player.tscn").instantiate()  # Instantiate player scene
	player.name = str(player_id)  # Set player name to player_id
	add_child(player)  # Add player to the scene
	rpc("receive_map_data", scene.get_map_data())
	pass

