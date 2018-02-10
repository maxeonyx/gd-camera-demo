extends Spatial

signal update_angle

func _physics_process(delta):
	
	# Make the camera follow the player
	var player_position = get_node("/root/Game").get_player_position()
	print(player_position)
	translation = translation.linear_interpolate(player_position, 0.3)
	
	# make the camera rotate with ui controls
	var angle = 0
	
	if Input.is_action_pressed("ui_left"):
		angle += TAU/120
		
	if Input.is_action_pressed("ui_right"):
		angle -= TAU/120
		
	rotate(Vector3(0, 1, 0), angle)
	
	emit_signal("update_angle", rotation.y)
