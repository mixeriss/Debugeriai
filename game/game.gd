extends Node2D

var map
var peer = ENetMultiplayerPeer.new()

@export var player_scene: PackedScene

func _ready():
	load_world()
	pass

func load_world():
	map = preload("res://world/world.tscn").instantiate()
	add_child(map)
	pass

func load_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.position = map.find_spawn_point()
	player.config_player_camera(map.get_pixelSize())
	add_child(player)
	pass

func _on_join_pressed():
	peer.create_client("127.0.0.1",135)
	multiplayer.multiplayer_peer = peer
	$Camera2D.enabled = false
	pass


func _on_host_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(load_player)
	load_player()
	$Camera2D.enabled = false
	pass

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()
