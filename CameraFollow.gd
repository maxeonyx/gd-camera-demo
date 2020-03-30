extends Spatial

signal update_angle

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Make the camera follow the player
func _physics_process(delta):
    var player_position = get_node("/root/Game").get_player_position()
    translation = translation.linear_interpolate(player_position, 0.3)

# Move the camera angle with the mouse
func _input(event):
    if event is InputEventMouseMotion:
        var motion = event.relative
        
        $YRotation.rotate(Vector3(0, 1, 0), -motion.x * .01)
        $YRotation/XRotation.rotate(Vector3(1, 0, 0), -motion.y * .01)
    
    emit_signal("update_angle", $YRotation.rotation.y)
