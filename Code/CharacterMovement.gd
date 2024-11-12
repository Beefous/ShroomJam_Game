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
var bits = 5
var temp_rate = 0.5
var bit_rate = 0.5
var max_bits = 10
var is_redeeming = false

@onready var absolute_parent = get_parent()

#health variables
@export var health_max = 50
var health_current


# blocks the player's movement when they die.
var is_dead: bool = false

var is_dodging: bool = false
var dodge_cd = .4
var dodge_timer = 0.0

func _ready():
	health_current = health_max
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _physics_process(delta):
	timer += delta
	
	bits = min(bits, max_bits)
	# Power up that you can get :D
	if power == true:
		power_timer += delta
		actual_rate = fire_rate / 2
		temp_rate = bit_rate / 2.5
		#bits = max_bits
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
	
	shoot()
	
	if Input.is_action_just_pressed("dodge") and is_dodging == false and (bits > 0 or power):
		if not power:
			bits -= 1
		is_dodging = true
		dodge_timer = 0
		#print('dodgeing')
	
	if Input.is_action_just_pressed("Respawn"):
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Engine.time_scale = 0
			#print('esc pressed')
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			Engine.time_scale = 1
			#print('esc pressed')
	
	# movement is handled like this
	
	speed_mult = 3.0 if is_dodging == true and dodge_timer < dodge_cd / 3 else 1.0
	
	if direction_x:
		velocity.x = direction_x * SPEED * speed_mult
	if direction_y:
		velocity.y = direction_y * SPEED * speed_mult
	
	
	# look at mouse
	if Engine.time_scale > 0:
		$Sprite.look_at(get_global_mouse_position())
	
	move_and_slide()


func shoot():
	if Engine.time_scale == 0:
		return
	
	if Input.get_action_raw_strength("Shoot") && timer >= actual_rate and not Input.is_action_pressed('alt shoot'):
		var temp = Bullet.instantiate()
		add_sibling(temp)
		temp.global_position = get_node("Sprite/Sprite/BulletSpawn").get("global_position")
		# this sets the rotation as to where it will fire
		temp.set("area_direction", (get_global_mouse_position() - self.global_position).normalized())
		# These statements below handle camera shake
		Camera.set("offset", Vector2(randf_range(-2, 2), randf_range(-2, 2)))
		timer = 0
	elif Input.is_action_pressed('alt shoot') && timer >= temp_rate and (bits > 0 or power):
		if not power:
			bits -= 1
		if is_redeeming and not power:
			CorruptionStats.bits_redeemed += 1
			return
		var temp = Bit.instantiate()
		add_sibling(temp)
		temp.bullet = true
		temp.global_position = get_node("Sprite/Sprite/BulletSpawn").get("global_position")
		# this sets the rotation as to where it will fire
		temp.set("area_direction", (get_global_mouse_position() - self.global_position).normalized())
		# These statements below handle camera shake
		Camera.set("offset", Vector2(randf_range(-2, 2), randf_range(-2, 2)))
		timer = 0
	else:
		Camera.set("offset", Vector2(0, 0))


# all the things that it do when you die.
func Die():
	get_node("Explosive").set_emitting(true)
	get_node("Explosive/Sound").play()
	self.get_node("Sprite").set("visible", false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#Stop Camera and set player to death
	Camera.set("position", Vector2(0, 0))
	#Wait 1.5 seconds before showing retry screen
	is_dead = true
	await get_tree().create_timer(1.5).timeout
	Engine.time_scale = 0
	#Move Camera to center
	position = Vector2(383,397)
	$"../Wobble".hide()
	if CorruptionStats.bits_redeemed >= 100:
		$"../BlueScreen/Winner".show()
	else:
		#Show Retry Background over whole screen
		$"../BlueScreen/Retry".show()
	
# Reload Scene
func Respawn():
	get_tree().reload_current_scene()
	CorruptionStats._ready()
