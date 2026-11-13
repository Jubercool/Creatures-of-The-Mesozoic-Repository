extends Control
var can_exit = false
var can_shop = false
var tips = ["Eat the bodies of dinosaurs by pressing X: It will recover your hp!",
"Using a cycad located on the banks of a river can stop your bleeding!",
"Come back to the homecave whenever you feel overwhelmed and need a break!",
"Try to attack an enemy and then quickly fall back, letting you hit them without them hitting you!",
"The Saurosuchus does the most damage and bleed, be careful when fighting it!"]
var tip = -1
var avaliable_tips = []

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
			Global.running = false
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
		if can_shop:
			avaliable_tips = []
			if tip == -1:
				$Label.visible = true
			for i in range(len(Global.tips_seen)):
				if not Global.tips_seen[i]:
					avaliable_tips.append(i)
			if len(avaliable_tips) == 1:
				for i in range(len(Global.tips_seen)):
					Global.tips_seen[i] = false
			tip = randi_range(0,len(avaliable_tips)-1)
			$Label.text = tips[avaliable_tips[tip]]
			Global.tips_seen[avaliable_tips[tip]] = true

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
