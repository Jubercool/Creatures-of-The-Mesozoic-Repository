extends CharacterBody2D

#Health
var max_health
var health
var phealth
var bleed = []
var bleed_timers = []
var can_cure = false
var can_enter_homecave = false

#Movement
var acceleration = Vector2()
var pressed = [false,false]
var walk_max_vel
var max_vel
var sprint_max_vel
var acceleration_base
var acceleration_buff
var friction = 0.2
var sprint = false
var max_stamina
var stamina
var time_since_sprint = 0

#Animation
var new_anim = true
var hit_colour = 1
var should_hit_colour = false
var change_health
var animation_paused = false
var attacking_at_the_moment = false
var change_zoom = 100
var forest_zoom = 100
var forest_zoom2 = 100
var target_zoom = 100
var first_frame
#var walk_cycle = 1
#var bite_cycle = 0

#Attack
var attacks
var damage = []
var attack_cooldown = []
var attack_timer = []

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	acceleration = Vector2(0,0)
	first_frame = true
	if Global.creatures!=null:
		var stats = Global.creatures["player"]
		max_health = stats["max_health"]
		health = max_health
		phealth = health
		change_health = health
		max_stamina = stats["max_stamina"]
		stamina = max_stamina
		walk_max_vel = stats["walk_max_vel"]
		max_vel = walk_max_vel
		sprint_max_vel = stats["sprint_max_vel"]
		acceleration_base = stats["acceleration_base"]
		acceleration_buff = stats["acceleration_buff"]
		$AnimatedSprite2D.scale = stats["sprite_size"]
		$AnimatedSprite2D.position = stats["sprite_offset"]
		$PlayerCollisionHitbox.shape.radius = stats["collision_hitbox_size"][0]
		$PlayerCollisionHitbox.shape.height = stats["collision_hitbox_size"][1]
		$PlayerCollisionHitbox.position = stats["collision_hitbox_offset"]
		$PlayerHitbox/CollisionShape2D.shape.radius = stats["hitbox_size"][0]
		$PlayerHitbox/CollisionShape2D.shape.height = stats["hitbox_size"][1]
		$PlayerHitbox/CollisionShape2D.position = stats["hitbox_offset"]
		$ForestHitbox/CollisionShape2D.shape.radius = stats["forest_hitbox_size"][0]
		$ForestHitbox/CollisionShape2D.shape.height = stats["forest_hitbox_size"][1]
		$ForestHitbox/CollisionShape2D.position = stats["forest_hitbox_offset"]
		attacks = stats["attack_amount"]
		damage.resize(attacks)
		damage.fill(0)
		attack_cooldown.resize(attacks)
		attack_cooldown.fill(0)
		attack_timer.resize(attacks)
		attack_timer.fill(0)
		for i in attacks:
			damage[i] = stats["damage"][i]
			attack_cooldown[i] = stats["attack_cooldown"][i]
			attack_timer[i] = attack_cooldown[i]
		$Attack1/Attack1Hitbox.shape.radius = stats["attack_hitbox_size"][0][0]
		$Attack1/Attack1Hitbox.shape.height = stats["attack_hitbox_size"][0][1]
		$Attack1/Attack1Hitbox.position = stats["attack_hitbox_offset"][0]
		#$Attack2/Attack2Hitbox.shape.radius = stats["attack_hitbox_size"][1][0]
		#$Attack2/Attack2Hitbox.shape.height = stats["attack_hitbox_size"][1][1]
		#$Attack2/Attack2Hitbox.position = stats["attack_hitbox_offset"][1]

#Stops the animation playing when it ends
func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.stop()
	new_anim = true

#Moves the player
func move_player() -> void:
	pressed = [false,false]
	if Input.is_action_pressed("move_left"):
		if velocity.x>-max_vel:
			if velocity.x>0:
				acceleration.x=-acceleration_buff
			else:
				acceleration.x=-acceleration_base
		else:
			velocity.x=-max_vel
			acceleration.x=0
		pressed[0]=true
		$AnimatedSprite2D.flip_h=true
		$Attack1/Attack1Hitbox.position.x = -Global.creatures["player"]["attack_hitbox_offset"][0].x
		$Attack2/Attack2Hitbox.position.x = -Global.creatures["player"]["attack_hitbox_offset"][1].x
		$PlayerHitbox.position.x = -Global.creatures["player"]["hitbox_offset"].x
		$ForestHitbox/CollisionShape2D.position.x = -Global.creatures["player"]["forest_hitbox_offset"].x
	if Input.is_action_pressed("move_up"):
		if velocity.y>-max_vel:
			if velocity.y>0:
				acceleration.y=-acceleration_buff
			else:
				acceleration.y=-acceleration_base
		else:
			velocity.y=-max_vel
			acceleration.y=0
		pressed[1]=true
	if Input.is_action_pressed("move_right"):
		if velocity.x<max_vel:
			if velocity.x<0:
				acceleration.x=acceleration_buff
			else:
				acceleration.x=acceleration_base
		else:
			velocity.x=max_vel
			acceleration.x=0
		pressed[0]=true
		$AnimatedSprite2D.flip_h=false
		$Attack1/Attack1Hitbox.position.x = Global.creatures["player"]["attack_hitbox_offset"][0].x
		$Attack2/Attack2Hitbox.position.x = Global.creatures["player"]["attack_hitbox_offset"][1].x
		$PlayerHitbox.position.x = Global.creatures["player"]["hitbox_offset"].x
		$ForestHitbox/CollisionShape2D.position.x = Global.creatures["player"]["forest_hitbox_offset"].x
	if Input.is_action_pressed("move_down"):
		if velocity.y<max_vel:
			if velocity.y<0:
				acceleration.y=acceleration_buff
			else:
				acceleration.y=acceleration_base
		else:
			velocity.y=max_vel
			acceleration.y=0
		pressed[1]=true
	if not pressed[0]:
		acceleration.x=-friction*velocity.x
	if not pressed[1]:
		acceleration.y=-friction*velocity.y

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("controller_test"):
		Global.controller = true
	if first_frame:
		if Global.homecave:
			$CanvasLayer/Ui/HealthBar.visible = false
			$CanvasLayer/Ui/StaminaBar.visible = false
			scale = Vector2(0.5, 0.5)
			sprint_max_vel = Global.creatures["player"]["sprint_max_vel"]/2
			walk_max_vel = Global.creatures["player"]["walk_max_vel"]/2
			$Camera2D.zoom = Vector2(1, 1)
			$Camera2D.limit_left = 0
			$Camera2D.limit_top = 0
			$Camera2D.limit_right = 1152
			$Camera2D.limit_bottom = 648
		else:
			health = Global.player_health
			position = Global.player_pos
			if Global.sprint_hint:
				if Global.controller:
					$CanvasLayer/Ui/SprintController.visible = true
				else:
					$CanvasLayer/Ui/SprintKeyboard.visible = true
			$CanvasLayer/Ui/HealthBar.visible = true
			scale = Vector2(1, 1)
			sprint_max_vel = Global.creatures["player"]["sprint_max_vel"]
			walk_max_vel = Global.creatures["player"]["walk_max_vel"]
			$Camera2D.zoom = Vector2(0.25, 0.25)
			$Camera2D.limit_left = 6900
			$Camera2D.limit_top = -6000
			$Camera2D.limit_right = 93600
			$Camera2D.limit_bottom = 61200
		first_frame = false
	if Global.running:
		if animation_paused:
			animation_paused = false
			$AnimatedSprite2D.play()
		if health>0:
			if can_enter_homecave && Input.is_action_just_pressed("interact"):
				Global.homecave = true
				Global.player_pos = position
				Global.player_health = health
				get_tree().change_scene_to_file("res://Scenes/homecave.tscn")
			if Global.controller or Global.sprint_toggle:
				if Input.is_action_just_pressed("sprint"):
					$CanvasLayer/Ui/SprintController.visible = false
					Global.sprint_hint = false
					sprint = !sprint
			else:
				if Input.is_action_pressed("sprint"):
					$CanvasLayer/Ui/SprintKeyboard.visible = false
					Global.sprint_hint = false
					sprint = true
				else:
					sprint = false
			if sprint && stamina > 0:
				max_vel = sprint_max_vel
				if pressed[0] or pressed[1]:
					stamina -= delta * 5.0
					time_since_sprint = 0
					if $AnimatedSprite2D.animation != "Walk" and $AnimatedSprite2D.animation != "Idle":
						$AnimatedSprite2D.speed_scale = 1.0
					else:
						$AnimatedSprite2D.speed_scale = 1.25
			else:
				max_vel = walk_max_vel
				time_since_sprint += delta * 5.0
				stamina = min(stamina + delta * min(time_since_sprint, 10.0), max_stamina)
				$AnimatedSprite2D.speed_scale = 1.0
			velocity += acceleration
			move_and_slide()
			move_player()
			attacking_at_the_moment = false
			for i in attacks:
				attack_timer[i] += delta
				if Input.is_action_just_pressed("attack"+str(i+1)) && attack_timer[i]>=attack_cooldown[i]:
					attacking_at_the_moment = true
					attack_timer[i] = 0
					var enemies = get_tree().get_nodes_in_group("enemies")
					for enemy in enemies:
						if enemy.player_can_attack[i]:
							enemy.health -= damage[i]
							health = min(-min(max(enemy.health-max(damage[i],0),-enemy.max_health),0)+health,max_health)
					$AnimatedSprite2D.play("Attack"+str(i+1))
			if (pressed[0]||pressed[1])&&!attacking_at_the_moment:
				if new_anim:
					$AnimatedSprite2D.play("Walk")
					new_anim = false
			elif !attacking_at_the_moment:
				if new_anim:
					$AnimatedSprite2D.play("Idle")
					new_anim = false
				if $AnimatedSprite2D.animation == "Walk":
					$AnimatedSprite2D.play("Idle")
					new_anim = false
		if !Global.homecave:
			$CanvasLayer/Ui/Bleed.visible = false
			if can_cure && Input.is_action_just_pressed("interact"):
				for bled in range(len(bleed_timers)):
					bleed_timers[bled] = 0
			var i = 0
			while i < len(bleed):
				health -= bleed[i] * delta
				bleed_timers[i] -= delta
				if bleed_timers[i] <= 0:
					bleed.remove_at(i)
					bleed_timers.remove_at(i)
				else:
					$CanvasLayer/Ui/Bleed.visible = true
					i += 1
			$CanvasLayer/Ui/HealthBar/FullHealthBar.size.x = (max(health,0)*580)/max_health
			$CanvasLayer/Ui/StaminaBar/FullStaminaBar.size.x = (max(stamina,0)*580)/max_stamina
			$CanvasLayer/Ui/HealthBar/ChangeHealthBar.size.x = (max(change_health,0)*580)/max_health
			forest_zoom = $CanvasLayer/Ui/ForestZoom.get_theme_stylebox("panel")
			forest_zoom2 = $CanvasLayer/Ui/ForestZoom2.get_theme_stylebox("panel")
			forest_zoom.set_border_width_all(change_zoom)
			forest_zoom2.set_border_width_all(change_zoom / 2.0 - 90)
			walk_max_vel = (1 - (change_zoom - 100) / 1150.0) * 100 + 300
			sprint_max_vel = walk_max_vel * 2.25
			$CanvasLayer/Ui/ForestZoom.add_theme_stylebox_override("panel",forest_zoom)
			$CanvasLayer/Ui/ForestZoom2.add_theme_stylebox_override("panel",forest_zoom2)
			$CanvasLayer/Ui/ForestZoom.size = Vector2((1 - (change_zoom - 100) / 1150.0) * 1000 + 2000, (1 - (change_zoom - 100) / 1250.0) * 1000 + 2000)
			$CanvasLayer/Ui/ForestZoom.position = Vector2((1 - (change_zoom - 100) / 1150.0) * -500 - 1000, (1 - (change_zoom - 100) / 1250.0) * -500 - 1000)
			$Camera2D.zoom = Vector2(((change_zoom - 100) / 1150.0) * 0.15 + 0.25, ((change_zoom - 100) / 1150.0) * 0.15 + 0.25)
			if($"../Trees"):
				$"../Trees".modulate = Color(1,1,1,(1 - (change_zoom - 100) / 1150.0) * 0.7 + 0.3)
			if(change_zoom != target_zoom):
				change_zoom = (change_zoom - target_zoom) * 0.95 + target_zoom
			if(change_health != health):
				change_health = (change_health - health) * 0.95 + health
			$AnimatedSprite2D.modulate = Color(1,hit_colour,hit_colour)
			if(phealth != health && should_hit_colour):
				hit_colour = 0
			elif(hit_colour < 1):
				hit_colour += delta
			should_hit_colour = false
			phealth = health
		else:
			position.x = maxf(minf(position.x, 1052), 100)
			position.y = maxf(minf(position.y, 548), 200)
	elif not animation_paused:
		$AnimatedSprite2D.pause()
		animation_paused = true

func _on_forest_hitbox_body_entered(body: Node2D) -> void:
	target_zoom = 1250
	$CanvasLayer/Ui/ForestZoom.visible = true
	$CanvasLayer/Ui/ForestZoom2.visible = true

func _on_forest_hitbox_body_exited(body: Node2D) -> void:
	target_zoom = 100
	$CanvasLayer/Ui/ForestZoom.visible = false
	$CanvasLayer/Ui/ForestZoom2.visible = false

func _on_attack_1_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().player_can_attack[0] = true

func _on_attack_1_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().player_can_attack[0] = false

func _on_attack_2_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().player_can_attack[1] = true

func _on_attack_2_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().player_can_attack[1] = false


func _on_cycad_hitbox_body_entered(body: Node2D) -> void:
	can_cure = true
	if Global.controller:
		$CanvasLayer/Ui/CycadController.visible = true
	else:
		$CanvasLayer/Ui/CycadKeyboard.visible = true

func _on_cycad_hitbox_body_exited(body: Node2D) -> void:
	can_cure = false
	if Global.controller:
		$CanvasLayer/Ui/CycadController.visible = false
	else:
		$CanvasLayer/Ui/CycadKeyboard.visible = false

func _on_homecave_hitbox_area_entered(area: Area2D) -> void:
	can_enter_homecave = true
	if Global.controller:
		$CanvasLayer/Ui/HomecaveController.visible = true
	else:
		$CanvasLayer/Ui/HomecaveKeyboard.visible = true

func _on_homecave_hitbox_area_exited(area: Area2D) -> void:
	can_enter_homecave = false
	if Global.controller:
		$CanvasLayer/Ui/HomecaveController.visible = false
	else:
		$CanvasLayer/Ui/HomecaveKeyboard.visible = false
