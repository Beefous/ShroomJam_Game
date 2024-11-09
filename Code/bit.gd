extends Area2D

var bullet = false

const SPEED = 400.0
var area_direction = Vector2(0, 0)
var debounce = false

var max_distance = 800

var distance_traveled: float

func _ready():
	get_node("Poof/Sound").play()
	$AnimatedSprite2D.play("new_animation")

func _process(delta):
	self.translate(area_direction * SPEED * delta)
	distance_traveled += SPEED * delta
	
	if distance_traveled >= max_distance and bullet:
		self.queue_free()

func _on_body_entered(body):
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	
	if body.is_in_group("Enemy"):
		if body.effects_corruption:
			body.hit()
			self.hit()
	else:
		poof()

# make the bullet disappear with a poof :D
func poof():
	$AnimatedSprite2D.hide()
	get_node("Poof").set_emitting(true)
	#get_node("Poof/Sound").play()
	await get_node('Poof').finished
	self.queue_free()

func hit():
	$AnimatedSprite2D.hide()
	get_node("Hit").set_emitting(true)
	get_node("Hit/Sound").play()
	await get_node('Hit').finished
	self.queue_free()
