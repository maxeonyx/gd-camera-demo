extends KinematicBody

export(float) var speed = 5.0
export(PackedScene) var bullet

signal update_position

func _physics_process(delta):
	var movement = Vector3(0, 0, 0)
	
	var camera_angle = get_node("/root/Game").get_camera_angle()
	
	if Input.is_key_pressed(KEY_W):
		movement += Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), camera_angle)
		
	if Input.is_key_pressed(KEY_S):
		movement += Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), camera_angle)
		
	if Input.is_key_pressed(KEY_D):
		movement += Vector3(1, 0, 0).rotated(Vector3(0, 1, 0), camera_angle)
		
	if Input.is_key_pressed(KEY_A):
		movement += Vector3(-1, 0, 0).rotated(Vector3(0, 1, 0), camera_angle)
		
	if Input.is_key_pressed(KEY_SPACE):
		var b_ins = bullet.instance()
		b_ins.transform = transform
		get_node("/root/Game").add_child(b_ins)
		
	move_and_slide(movement * speed)
	
	emit_signal("update_position", translation)
