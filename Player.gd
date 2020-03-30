extends KinematicBody

export(float) var speed = 5.0
export(PackedScene) var bullet

signal update_position

# gravity is a constant: 20 feet per second per second
var gravity = 20
# This is the speed at which the player falls. It increases the longer the
# player is falling.
var vertical_velocity = 0

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
    
    # this line makes diagonal movement the same speed as forward and sideways
    movement = movement.normalized()
    movement *= speed

    # Increase the downward velocity
    vertical_velocity -= gravity * delta
    movement.y += vertical_velocity
    
    # do the movement. the vector parameter is the UP direction (a.k.a floor normal vector)
    movement = move_and_slide(movement, Vector3(0, 1, 0))
    
    # if we just hit the ground, the vertical velocity is now 0
    vertical_velocity = movement.y
    
    # We only allow the player to jump if they are on the ground. is_on_floor
    # must be called *after* calling move_and_slide
    if Input.is_key_pressed(KEY_SPACE):
        if is_on_floor():
            # jumping is just an immediate boost to vertical velocity
            vertical_velocity += 20
    
    emit_signal("update_position", translation)


