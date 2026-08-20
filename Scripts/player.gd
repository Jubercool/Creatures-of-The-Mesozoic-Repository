extends CharacterBody2D

#Health
var max_health
var health
var phealth

#Movement
var acceleration = Vector2()
var pressed = [false,false]
var walk_max_vel
var max_vel
var sprint_max_vel
var acceleration_base
var acceleration_buff
var friction = 0.2

#Animation
var new_anim = true
var hit_colour = 1

#Attack
var damage
var attack_cooldown
var attack_timer

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	acceleration = Vector2(0,0)
	if Creaturestats.creatures!=null:
		var stats = Creaturestats.creatures["player"]
		max_health = stats["max_health"]
		health = max_health
		phealth = health
		walk_max_vel = stats["walk_max_vel"]
		max_vel = walk_max_vel
		sprint_max_vel = stats["sprint_max_vel"]
		acceleration_base = stats["acceleration_base"]
		acceleration_buff = stats["acceleration_buff"]
		damage = stats["damage"]
		attack_cooldown = stats["attack_cooldown"]
		attack_timer = [attack_cooldown[0]]

#Stops the animation playing when it ends
func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.stop()
	new_anim = true

#Moves the player
func move_player() -> void:
	pressed = [false,false]
	if Input.is_action_pressed("ui_left"):
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
	if Input.is_action_pressed("ui_up"):
		if velocity.y>-max_vel:
			if velocity.y>0:
				acceleration.y=-acceleration_buff
			else:
				acceleration.y=-acceleration_base
		else:
			velocity.y=-max_vel
			acceleration.y=0
		pressed[1]=true
	if Input.is_action_pressed("ui_right"):
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
	if Input.is_action_pressed("ui_down"):
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
	if Creaturestats.running:
		if health>0:
			max_vel = sprint_max_vel
			velocity += acceleration
			move_and_slide()
			move_player()
			attack_timer[0] += delta
			if Input.is_action_just_pressed("left_click") && attack_timer[0]>=attack_cooldown[0]:
				attack_timer[0] = 0
				var enemies = get_tree().get_nodes_in_group("enemies")
				for enemy in enemies:
					if enemy.player_can_attack:
						enemy.health-=damage[0]
				$AnimatedSprite2D.play("Bite")
			elif pressed[0]||pressed[1]:
				if new_anim:
					$AnimatedSprite2D.play("Walk")
					new_anim = false
			else:
				if new_anim:
					$AnimatedSprite2D.play("Idle")
					new_anim = false
		$AnimatedSprite2D.modulate=Color(1,hit_colour,hit_colour)
		if(phealth!=health):
			hit_colour=0
		elif(hit_colour<1):
			hit_colour+=delta
		phealth = health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.player_can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.player_can_attack = false
