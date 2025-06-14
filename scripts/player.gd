extends CharacterBody3D

@onready var marker: Marker3D = $Camera3D/gun_model/Marker3D
@onready var camera: Camera3D = $Camera3D
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const BULLET = preload("res://scenes/bullet_3d.tscn")

const Y_MOUSE_SPEED = 0.2
const X_MOUSE_SPEED = 0.01
var SPEED = 9.5 
const JUMP_SPEED = 10.0
const GRAV = 20.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #mouse cursor will be captured i.e disappear 

# function to rotate the camera and player according to mouse movement
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * Y_MOUSE_SPEED
		camera.rotation.x -= event.relative.y  * X_MOUSE_SPEED
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70.0), deg_to_rad(70.0))
	
	#ui_cancel is predefined action in Godot. can be mapped in project settings. 	
	elif event.is_action_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	var input_direction_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_direction_3d = Vector3(input_direction_2d.x, 0.0, input_direction_2d.y)
	
	#transform basis into 3d i.e move along the mouse direciton, the direction the character is facing
	var direction = transform.basis * input_direction_3d 
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	velocity.y -= GRAV * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_SPEED
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	move_and_slide();
	
	if Input.is_action_pressed("shoot") and timer.is_stopped():
		shoot_bullet()
		
	if Input.is_action_pressed("sprint"):
		SPEED += 0.5
	elif Input.is_action_just_released("sprint"):
		SPEED = 9.5

func shoot_bullet():
	var new_bullet = BULLET.instantiate()
	marker.add_child(new_bullet)
	
	# take position of marker and apply it to bullet
	new_bullet.global_transform = marker.global_transform
	
	timer.start()
	
	audio_stream_player.play()
