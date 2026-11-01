extends Control

var selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("controller_test"):
		Global.controller = true
	if Input.is_action_just_pressed("ui_up") && selected == false:
		$VBoxContainer/PlayButton.grab_focus()
		selected = true
	if Input.is_action_just_pressed("ui_down") && selected == false:
		$VBoxContainer/PlayButton.grab_focus()
		selected = true

func _on_play_pressed() -> void:
	$Press.play()
	await $Press.finished
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

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
