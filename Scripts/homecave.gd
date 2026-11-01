extends Control
var can_exit = false
var can_shop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.homecave = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("controller_test"):
		Global.controller = true
	if Input.is_action_just_pressed("interact"):
		if can_exit:
			Global.homecave = false
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
		if can_shop:
			$ShopMenu.visible = !$ShopMenu.visible

func _on_area_2d_body_entered(body: Node2D) -> void:
	if Global.controller:
		$ControllerLabel.visible = true
	else:
		$KeyboardLabel.visible = true
	can_exit = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	$KeyboardLabel.visible = false
	$ControllerLabel.visible = false
	can_exit = false

func _on_shop_body_entered(body: Node2D) -> void:
	if Global.controller:
		$ControllerLabel2.visible = true
	else:
		$KeyboardLabel2.visible = true
	can_shop = true

func _on_shop_body_exited(body: Node2D) -> void:
	$KeyboardLabel2.visible = false
	$ControllerLabel2.visible = false
	can_shop = false
