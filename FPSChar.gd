extends KinematicBody

var speed = 10
var h_acceleration = 6
var mouse_sensitivity = 0.06
var gravity = 20
var jump = 10
var air_acceleration = 1
var normal_acceleration = 6

var full_contact = false

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() and ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	if Input.is_action_pressed("sprint"):
		speed = 30
	else:
		speed = 10
		
	if Input.is_action_just_pressed("screenshot"):
		var image = get_viewport().get_texture().get_data()
		print(get_viewport().size)
		image.flip_y()
		var timestamp = Time.get_datetime_string_from_system(true,true).replace(" ","_").replace(":","-")
		print("taken ss: "+timestamp)
		image.save_png("./screenshots/UTC_"+str(timestamp)+".png")
	
	#DEBUG
	#if Input.is_action_just_pressed("DEBUG_reset"):
	#	translate(Vector3(-translation[0],16,-translation[2]))
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
