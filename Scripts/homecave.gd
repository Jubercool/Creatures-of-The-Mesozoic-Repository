extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_leave_homecave_pressed() -> void:
	$Press.play()
	await $Press.finished
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")


func _on_leave_homecave_mouse_entered() -> void:
	$Hover.play()
	await $Hover.finished
