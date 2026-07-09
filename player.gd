extends Area2D
signal hit

var can_move = false
var HP = 3

@export var speed = 400 # Players movement speed in pixels/sec
var screen_size

func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos
	$CollisionShape2D.disabled = false

# Called once per frame. Delta refers to amount of time passed
func _process(delta):
	
	var velocity = Vector2.ZERO # Players movement vector
	
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
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
