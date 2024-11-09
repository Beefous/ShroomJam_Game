extends Area2D

@export var Coin: PackedScene
var coinage
@export var PowerUp: PackedScene
@export var power_spawn_rate = 15
var power_timer = 0
# This is found in the debug shape of CollisionShape2D for a representation
@onready var SquareSizeX = get_node("CollisionShape2D").get_shape().get_rect().size.x / 2
@onready var SquareSizeY = get_node("CollisionShape2D").get_shape().get_rect().size.y / 2

@export var coin_rate = 2
var coin_timer = 0

func _ready():
	var temp = Coin.instantiate()
	temp.position = self.position + (Vector2(randi_range(-(SquareSizeX), SquareSizeX), randi_range(-(SquareSizeY), SquareSizeY)))
	add_sibling.call_deferred(temp)
	coinage = temp
	
func _process(delta):
	power_timer += delta
	
	if power_timer >= power_spawn_rate:
		power_timer = 0
		power_spawn_rate = 30 + randi_range(-10, 10)
		var temp = PowerUp.instantiate()
		temp.position = self.position + (Vector2(randi_range(-(SquareSizeX), SquareSizeX), randi_range(-(SquareSizeY), SquareSizeY)))
		add_sibling.call_deferred(temp)
	
	if coinage == null:
		coin_timer += delta
		if coin_timer >= coin_rate:
			coin_timer = 0
			_ready()
