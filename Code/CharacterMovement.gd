extends CharacterBody2D

const SPEED = 150.0
var speed_mult = 1.0
@export var Bullet: PackedScene
@onready var Camera = get_node_or_null("Camera2D")
@export var fire_rate = 0.2
var actual_rate = 0.2
var timer = 0

var power = false
var power_timer = 0

@export var Bit: PackedScene
var bits = 0
var temp_rate = 0.5
var bit_rate = 0.5
var max_bits = 10

@onready var absolute_parent = get_parent()

#health variables
@export var health_max = 50
var health_current


# blocks the player's movement when they die.
var is_dead: bool = false

var is_dodging: bool = false
var dodge_cd = .2
var dodge_timer = 0.0

func _ready():
	health_current = health_max
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta):
	timer += delta
	
	bits = min(bits, max_bits)
	# Power up that you can get :D
	if power == true:
		power_timer += delta
		#actual_rate = fire_rate / 2
		temp_rate = bit_rate / 2.5
		bits = max_bits
		if power_timer >= 10:
			power = false
	else:
		actual_rate = fire_rate
		temp_rate = bit_rate
		power_timer = 0
	
	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("Left", "Right")
	var direction_y = Input.get_axis("Up", "Down")
	velocity.x = 0
	velocity.y = 0
	
	# Stop doing things if you are dead, Respawn on 
	if is_dead == true:
		if Input.get_action_raw_strength("Respawn"):
			Respawn()
		if Input.is_action_just_pressed("enter"):
			get_tree().quit()
		return
	
	# if the player isn't dead...
	var overlapping_bodies = $hitbox.get_overlapping_bodies()
	var damage_rate = 15.0
	
	if overlapping_bodies.size() > 0 and not is_dodging: 
		health_current -= damage_rate * overlapping_bodies.size() * delta
		if health_current <= 0:
			Die()
	
	if dodge_timer < dodge_cd:
		dodge_timer += delta
	else: is_dodging = false
	
	if Input.get_action_raw_strength("Shoot") && timer >= actual_rate and not Input.is_action_pressed('alt shoot'):
		var temp = Bullet.instantiate()
		add_sibling(temp)
		temp.global_position = get_node("Sprite/Sprite/BulletSpawn").get("global_position")
		# this sets the rotation as to where it will fire
		temp.set("area_direction", (get_global_mouse_position() - self.global_position).normalized())
		# These statements below handle camera shake
		Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
		timer = 0
	if Input.is_action_pressed('alt shoot') && timer >= temp_rate and bits > 0 and not Input.get_action_raw_strength("Shoot"):
		bits -= 1
		var temp = Bit.instantiate()
		add_sibling(temp)
		temp.bullet = true
		temp.global_position = get_node("Sprite/Sprite/BulletSpawn").get("global_position")
		# this sets the rotation as to where it will fire
		temp.set("area_direction", (get_global_mouse_position() - self.global_position).normalized())
		# These statements below handle camera shake
		Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
		timer = 0
	
	if Input.is_action_just_pressed("dodge") and is_dodging == false:
		is_dodging = true
		dodge_timer = 0
		print('dodgeing')
	
	else:
		Camera.set("offset", Vector2(0, 0))
	# movement is handled like this
	
	speed_mult = 3.0 if is_dodging == true else 1.0
	
	if direction_x:
		velocity.x = direction_x * SPEED * speed_mult
	if direction_y:
		velocity.y = direction_y * SPEED * speed_mult
	
	
	# look at mouse
	$Sprite.look_at(get_global_mouse_position())
	
	move_and_slide()

# all the things that it do when you die.
func Die():
	get_node("Explosive").set_emitting(true)
	get_node("Explosive/Sound").play()
	self.get_node("Sprite").set("visible", false)
	#Stop Camera and set player to death
	Camera.set("position", Vector2(0, 0))
	is_dead = true
	#Wait 1.5 seconds before showing retry screen
	await get_tree().create_timer(1.5).timeout
	#Move Camera to center
	position = Vector2(383,397)
	#Show Retry Background over whole screen
	$"../BlueScreen/Retry".show()
	$"../Wobble".hide()
	
# Reload Scene
func Respawn():
	get_tree().reload_current_scene()
	CorruptionStats._ready()
