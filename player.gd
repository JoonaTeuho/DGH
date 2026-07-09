extends Area2D
signal hit

var can_move = false
var HP = 3

@export var speed = 400 # Pelaajan liikkumisnopeus (pikseliä/s)
var screen_size # Peliruudun koko

# Tämä kutsutaan, kun solmu luodaan ensimmäistä kertaa
func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos
	$CollisionShape2D.disabled = false

# Kutsutaan kerran per frame. 'delta' viittaa aikaan, joka on kulunut.
func _process(delta):
	
	var velocity = Vector2.ZERO # Pelaajan liikkumisvektori
	
	if can_move:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(_body):
	HP = HP - 1
	hit.emit()
	_body.queue_free()
	print(HP)
	if (HP == 0):
		hide() # Piilottaa pelaajan hahmon osumistilanteessa
		# Hahmo poistetaan käytöstä, jotta osumasignaali toimii vain kerran
		$CollisionShape2D.set_deferred("disabled", true)
