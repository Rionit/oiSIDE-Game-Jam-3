extends CharacterBody3D

const DOT = preload("uid://dr64yhqkp5nv")
const DOT_HOLE = preload("uid://t6mhgutjwtji")

#region Variables

@export_category("Movement")
##Speed of the character movement
@export var speed: float = 5.0
##Enable if you want your character to be able to walk
@export var can_walk: bool = true
##Enable if you want your character to be able to run
@export var can_run: bool = true
##Value to multiply on the current speed when character is running
@export var run_multiplier: float = 1.5

@export_category("Jump")
##Enable if you want your character to be able to jump
@export var can_jump: bool = true
##The force applied when jumping
@export var jump_force: float = 1.0

@export_category("Gravity")
##Use fall multiplier to make character fall more realistic
@export var use_fall_multiplier: bool = true
##The force applied to make more realistic the character fall
@export var fall_multiplier: float = 2.0
##limit force applied when fall multiplier is used
@export var max_fall_multiplier: float = 20.0

@export_category("Camera")
##Camera sensiblity
@export var camera_sensitivty: float = 0.01
@onready var camera_pivot: Node3D = $Camera

@export_category("Interaction")
@export var current_interaction: Interactable = null
@onready var crosshair: TextureRect = $Crosshair
@onready var interact_ray_cast_3d: RayCast3D = %InteractRayCast3D

var _current_speed: float
var _current_fall_multiplier: float
var _mouse_motion: Vector2

#endregion

func _ready() -> void:
	add_to_group("player")
	_current_fall_multiplier = fall_multiplier
	_current_speed = speed
	show_mouse(false)
	pass

func _physics_process(delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	# Move Camera
	move_camera()
	
	# Interact
	check_interactions()
	
	# Add the gravity.
	add_gravity(delta)
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# jump
	if can_jump:
		do_jump()
	
	#Make player movement
	if can_walk:
		do_movement(input_dir)

	move_and_slide()
	pass
	
func check_interactions():
	var collider = interact_ray_cast_3d.get_collider()
	
	# Check if we are looking at a new Interactable
	if collider is Interactable:
		if current_interaction != collider:
			# Unhighlight the previous one if it exists
			if current_interaction:
				current_interaction.unhighlight()
			
			# Highlight the new one
			current_interaction = collider
			current_interaction.highlight()
			
			crosshair.texture = DOT_HOLE
	else:
		# If we aren't looking at anything interactable, clear the old highlight
		if current_interaction:
			current_interaction.unhighlight()
			current_interaction = null
			
			crosshair.texture = DOT

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion = -event.relative * camera_sensitivty
		pass
	#Show or Hide mouse
	if event.is_action_pressed("escape"):
		show_mouse(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)
		var menu = $"../Menu"
		if menu:
			menu.visible = Input.mouse_mode != Input.MOUSE_MODE_CAPTURED
	#Run
	if event.is_action_pressed("run"):
		_current_speed = speed * run_multiplier
	elif event.is_action_released("run"):
		_current_speed = speed
	
	if event.is_action_pressed("interact") and current_interaction:
		current_interaction.interact()

#region Add Gravity

func add_gravity(delta: float):
	if use_fall_multiplier:
		if not is_on_floor():
			_current_fall_multiplier +=  delta if velocity.y >= 0.0 else delta * 3.0
			_current_fall_multiplier = clamp(_current_fall_multiplier, fall_multiplier, max_fall_multiplier)
			velocity += get_gravity() * delta * _current_fall_multiplier
		else:
			_current_fall_multiplier = fall_multiplier
			pass
		pass
	else:
		velocity += get_gravity() * delta
		pass 
	
#endregion

#region Movement and Jump

func do_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_force * 5.0 * abs(get_gravity().y))
		pass
	pass

func do_movement(input_dir: Vector2):
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * _current_speed
		velocity.z = direction.z * _current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _current_speed)
		velocity.z = move_toward(velocity.z, 0, _current_speed)
	pass
	
#endregion

#region Camera

func show_mouse(mouse_visiblity: bool):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if mouse_visiblity else Input.MOUSE_MODE_CAPTURED
	pass

func move_camera():
	#Rotate in Y axis on the character
	rotate_y(_mouse_motion.x)
	#Rotate in X on the camera pivot
	camera_pivot.rotate_x(_mouse_motion.y)
	#adding limit to rotation in X on the camera pivot
	camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, -90, 90)
	
	_mouse_motion = Vector2.ZERO
	pass

#endregion


func _on_health_component_is_dead() -> void:
	print("Is Dead")
	pass # Replace with function body.


func _on_health_component_on_life_change(amount: int) -> void:
	update_health_ui(amount)
	pass # Replace with function body.

func update_health_ui(amount: int):
	var health_control: HealthControl = $HealthControl
	if not health_control:
		return
	health_control.update_health_label(amount)
