extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	$Press.play()
	await $Press.finished
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_play_mouse_entered() -> void:
	$Hover.play()

func _on_options_pressed() -> void:
	$Press.play()
	await $Press.finished
	print("Options pressed")

func _on_Options_mouse_entered() -> void:
	$Hover.play()

func _on_exit_pressed() -> void:
	$Press.play()
	await $Press.finished
	get_tree().quit()

func _on_exit_mouse_entered() -> void:
	$Hover.play()
