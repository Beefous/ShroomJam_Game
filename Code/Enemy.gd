extends CharacterBody2D

@export var effects_corruption = false
@export var drop: PackedScene
@export var navigation_agent: NavigationAgent2D
var direction
var dir_vec: Vector2

@export_group("Stats")
@export var speed = 100.0
@export var health: int = 1
# assigned on ready, this stops a flood of errors.
@export_group("Player Things")
@export var player_name = "Character"
var player
# In the main scene, this goes to the very very top node! one node down, there should
# be the character and the spawners
@onready var absolute_parent = get_parent()
# Used to increase the score (Spawners should be the child of a "scene" node)
@export var score_value = 1

func _ready():
	if effects_corruption:
		CorruptionStats.enemies += 1
	#print(CorruptionStats.enemies)
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)


func _process(delta):
	navigation_agent.target_position = player.global_position
	if not navigation_agent.is_navigation_finished():
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var new_velocity: Vector2 = position.direction_to(next_path_position) * speed
		dir_vec = position.direction_to(next_path_position)
		navigation_agent.velocity = new_velocity
		
		# Directly set velocity and move
		velocity = new_velocity
		
	else:
		velocity = Vector2.ZERO
	
	# These 3 little lines of code handle movement! Don't ask me why velocity has to be set this way.
	if player != null:
		self.look_at(player.get("position"))
		#self.velocity = Vector2(0, 0)
		#self.position.x = move_toward(self.position.x, player.get("position").x, speed * delta)
		#self.position.y = move_toward(self.position.y, player.get("position").y, speed * delta)
	
	move_and_slide()

#do nothing for now
func _on_area_detector_body_entered(body):
	pass

# Get hit, or die.
func hit():
	health -= 1
	if health == 0:
		
		absolute_parent.Score += score_value
		
		get_node("Kill").set_emitting(true)
		get_node("Kill/Sound").play()
		$MeshInstance2D.hide()
		$CollisionShape2D.set.call_deferred('disabled', true)
		if not effects_corruption and randf() < .6:
			var temp = drop.instantiate()
			temp.global_position = global_position
			absolute_parent.add_child.call_deferred(temp)
		
		await $Kill.finished
		self.queue_free()

func _exit_tree():
	if effects_corruption:
		CorruptionStats.enemies -= 1
