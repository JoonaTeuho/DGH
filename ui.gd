extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$StartButton.text = "Replay"
	
func update_score(score):
	$ScoreLabel.text = str('Score: ' + str(score))
	
func update_HP(HP):
	$HP.text = str('HP:' + str(HP))
	
func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
