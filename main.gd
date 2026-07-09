extends Node

@export var projectile_scene: PackedScene
var score
var HP

func _on_player_hit() -> void:
	$UI.update_HP($Player.HP)
	if ($Player.HP == 0):
		game_over()

func game_over():
	$Player.can_move = false
	$ScoreTimer.stop()
	$ProjectileTimer.stop()
	$UI.show_game_over()

func new_game():
	$Player.show()
	$Player.can_move = true
	score = 0
	$Player.HP = 3
	HP = $Player.HP
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$UI.update_score(score)
	$UI.update_HP(HP)
	$UI.show_message("Get Ready")


func _on_projectile_timer_timeout() -> void:
	
	if ($ProjectileTimer.wait_time >= 0.1):
		$ProjectileTimer.wait_time = 1 - 0.01 * score 
		print($ProjectileTimer.wait_time)
	
	# Luo uuden ammuksen skeneen
	var projectile = projectile_scene.instantiate()

	# Valitsee satunnaisen sijainnin ammukselle
	var projectile_spawn_location = $ProjectilePath/ProjectileSpawnLocation
	projectile_spawn_location.progress_ratio = randf()
	projectile.position = projectile_spawn_location.position

	# Asettaa ammuksen suunnan pelikentän keskustaa kohti pienellä satunnaisuudella
	var direction = projectile_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	projectile.rotation = direction

	# Asettaa ammuksen nopeuden
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	projectile.linear_velocity = velocity.rotated(direction)

	# Luo ammuksen näkymään
	add_child(projectile)


func _on_score_timer_timeout() -> void:
	score += 1
	$UI.update_score(score)


func _on_start_timer_timeout() -> void:
	$ProjectileTimer.start()
	$ScoreTimer.start()
