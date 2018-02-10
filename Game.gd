extends Node

var camera_angle = 0
var player_position = Vector3(0, 0, 0)

func get_camera_angle():
	return camera_angle

func get_player_position():
	return player_position

func _on_Player_update_position(position):
	player_position = position

func _on_Spatial_update_angle(angle):
	camera_angle = angle
