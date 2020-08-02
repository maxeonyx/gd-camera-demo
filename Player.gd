extends KinematicBody

export(float) var speed = 5.0
export(float) var jump_height = 5.0
export(float) var mouse_x_gain = .007
export(float) var mouse_y_gain = .005

# gravity is a constant: 20 feet per second per second
var gravity = 20
# This is the speed at which the player falls. It increases the longer the
# player is falling.
var vertical_velocity = 0

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
    var camera_angle = get_node("/root/Game").get_camera_angle()
    
    var forward_movement = Input.get_action_strength("forward") - Input.get_action_strength("back")
    var rightward_movement = Input.get_action_strength("right") - Input.get_action_strength("left")
    # Forward is the negative z direction, this comes from OpenGL camera conventions.
    var movement = Vector3(rightward_movement, 0, -forward_movement).rotated(Vector3(0, 1, 0), rotation.y)
    
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

# Move the camera angle with the mouse
func _input(event):
    if event is InputEventMouseMotion:
        var motion = event.relative
        
        rotate(Vector3(0, 1, 0), -motion.x * mouse_x_gain)
        $Camera.rotate(Vector3(1, 0, 0), -motion.y * mouse_y_gain)
        if $Camera.rotation.x < -TAU/4:
            $Camera.rotation.x = -TAU/4
        elif $Camera.rotation.x > TAU/4:
            $Camera.rotation.x = TAU/4
    
    if event.is_action_pressed("quit"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            get_tree().quit()
