extends Node2D

var current_page = -1
var current_level = -1
var close_timer
var close_cooldown = 1

func _ready() -> void:
	close_timer = 0.1
	$PauseMenu.visible = false
	$InfoScreen.visible = false
	$Dinopedia.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.menu == "none":
		if Input.is_action_just_pressed("ui_cancel"):
			Global.menu = "menu"
			$PauseMenu.visible = true
	elif Global.menu == "info":
		if current_level != Global.level:
			$InfoScreen.visible = true
			$InfoScreen/Title.text = Global.info_screens[Global.level]["title"]
			$"InfoScreen/FloraInfo".text = Global.info_screens[Global.level]["flora"]
			#we gotta add the dino info stuff
		if close_timer < close_cooldown:
			close_timer += delta
		$InfoScreen/CloseButton.modulate = Color(close_timer/close_cooldown, close_timer/close_cooldown, close_timer/close_cooldown)
	elif Global.menu == "menu":
		if Input.is_action_just_pressed("ui_cancel"):
			$PauseMenu.visible = false
			Global.menu = "none"
	elif Global.menu == "dinopedia":
		if Input.is_action_just_pressed("ui_left") && Global.page > 0:
			Global.page -= 1
		if Input.is_action_just_pressed("ui_right") && Global.page + 1 < Global.dinopedia.size():
			Global.page += 1
		if current_page != Global.page:
			current_page = Global.page
			$Dinopedia/SubViewport/DinopediaDino.play(Global.dinopedia[Global.page]["name"]+"_idle")
			$Dinopedia/SubViewport/DinopediaDino.offset = Global.dinopedia[Global.page]["offset"]
			$Dinopedia/SubViewport/DinopediaDino.scale = Global.dinopedia[Global.page]["size"]
			if Global.dinopedia[Global.page]["dinopedia_unlocked"]:
				$Dinopedia/SubViewport/LeftPage.text = Global.dinopedia[Global.page]["dinopedia_left_page"]
				$Dinopedia/SubViewport/RightPage.text = Global.dinopedia[Global.page]["dinopedia_right_page"]
				$Dinopedia/SubViewport/DinopediaDino.modulate = Color(1,1,1)
			else:
				$Dinopedia/SubViewport/LeftPage.text = "???"
				$Dinopedia/SubViewport/RightPage.text = ""
				$Dinopedia/SubViewport/DinopediaDino.modulate = Color(0,0,0)
			#0.8 scale idk
		if Input.is_action_just_pressed("ui_cancel"):
			$PauseMenu.visible = true
			$Dinopedia.visible = false
			Global.menu = "menu"
	if Global.menu != "none":
		if Global.running:
			Global.running = false
	else:
		if not Global.running:
			Global.running = true
			$InfoScreen.visible = false
			$PauseMenu.visible = false
			$Dinopedia.visible = false

func _on_close_button_pressed() -> void:
	if close_timer >= close_cooldown:
		$InfoScreen.visible = false
		Global.menu = "none"

func _on_dinopedia_button_pressed() -> void:
	$PauseMenu.visible = false
	$Dinopedia.visible = true
	Global.menu = "dinopedia"

func _on_menu_button_pressed() -> void:
	Global.menu = "none"
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")


func _on_pause_menu_back_button_pressed() -> void:
	$PauseMenu.visible = false
	Global.menu = "none"


func _on_pause_menu_info_button_pressed() -> void:
	$PauseMenu.visible = false
	$InfoScreen.visible = true
	Global.menu = "info"
