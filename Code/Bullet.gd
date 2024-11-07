extends Area2D

const SPEED = 800.0
var area_direction = Vector2(0, 0)
var debounce = false

var max_distance = 800

var distance_traveled: float

func _ready():
	get_node("Poof/Sound").play()

func _process(delta):
	$Node2D/MeshInstance2D.rotation = area_direction.angle()
	self.translate(area_direction * SPEED * delta)
	distance_traveled += SPEED * delta
	
	if distance_traveled >= max_distance:
		self.queue_free()

func _on_body_entered(body):
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	# make sure walls aren't destroyed!
	if body.is_in_group("Enemy"):
		body.hit()
		self.hit()
	else:
		poof()

# make the bullet disappear with a poof :D
func poof():
	get_node("Poof").set_emitting(true)
	get_node("Poof/Sound").play()
	await get_node('Poof').finished
	self.queue_free()

func hit():
	get_node("Hit").set_emitting(true)
	get_node("Hit/Sound").play()
	await get_node('Hit').finished
	self.queue_free()
