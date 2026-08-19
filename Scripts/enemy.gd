extends CharacterBody2D
@onready var player = $"../Player"

var type = ""

#Health
var max_health
var health

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
var keep_attacking = false

#Attack
var player_can_attack = false
var can_attack = false
var damage
var attack_cooldown
var attack_timer

#AI
var wander_range = 1000
var seen = player
var moving = [false,false,false,false]
var attacking = [false]
var intrest_timer_init = 1
var intrest_timer = intrest_timer_init

#Pathfinding
var target_position = null
var new_target = true
var target2 = Vector2i(0,0)

#Debug
var debug_id

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Creaturestats.creatures!=null:
		var stats = Creaturestats.creatures[type]
		max_health = stats["max_health"]
		health = max_health
		walk_max_vel = stats["walk_max_vel"]
		max_vel = walk_max_vel
		sprint_max_vel = stats["sprint_max_vel"]
		acceleration_base = stats["acceleration_base"]
		acceleration_buff = stats["acceleration_buff"]
		damage = stats["damage"]
		attack_cooldown = stats["attack_cooldown"]
		attack_timer = [attack_cooldown[0]/2]

#Runs when the enemy reaches the target
func _on_navigation_agent_2d_navigation_finished() -> void:
	new_target=true

#Runs every 0.1s and regenerates the path to the target
func _on_timer_timeout() -> void:
	if(is_node_ready() and target_position!=null):
		$Timer.start()
		$RayCast2D.target_position=player.position-position
		$NavigationAgent2D.target_position=target_position
		target2 = $NavigationAgent2D.get_next_path_position()

#Finds an "optimal" path from one position (current) to another (target)
func pathfind(current,target) -> Array:
	var first = [false,false,false,false]
	if(target2.x+25<current.x):
		first[0]=true
	if(target2.y+25<current.y):
		first[1]=true
	if(target2.x-25>current.x):
		first[2]=true
	if(target2.y-25>current.y):
		first[3]=true
	return first
	
#Logic for when the enemy is attacking a target
func fight(delta) -> Array:
	var attack = [false]
	var seens = null
	if($RayCast2D.get_collider()==$"../Player/Area2D" or intrest_timer>0):
		seens = player
		intrest_timer-=delta
	else:
		intrest_timer=intrest_timer_init
	max_vel=sprint_max_vel
	if(can_attack):
		if(attacking[0]==false&&attack_timer[0]>=attack_cooldown[0]):
			attack[0] = true
		attack_timer[0]+=delta
	return [pathfind(position,target_position),attack,seens]

#Logic for when an enemy is not attacking a target
func wander() -> Array:
	max_vel = walk_max_vel
	var seens = null
	if($RayCast2D.get_collider()==$"../Player/Area2D"):
		seens = player
	queue_redraw()
	if(new_target):
		#0 - wander, 1 - idle
		var target_type = 0#randi_range(0,1)
		if(target_type==0):
			target_position=Vector2i(randi_range(-wander_range,wander_range),randi_range(-wander_range,wander_range))
		new_target=false
	return [pathfind(position,target_position),[false],seens]

#Moves the enemy
func move_enemy() -> void:
	pressed = [false,false]
	if moving[0]:
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
	if moving[1]:
		if velocity.y>-max_vel:
			if velocity.y>0:
				acceleration.y=-acceleration_buff
			else:
				acceleration.y=-acceleration_base
		else:
			velocity.y=-max_vel
			acceleration.y=0
		pressed[1]=true
	if moving[2]:
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
	if moving[3]:
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
	var plans = [[false,false,false,false],[false],null]
	if seen!=null:
		target_position = seen.position
		plans = fight(delta)
	else:
		plans = wander()
	moving = plans[0]
	#if !plans[1][0]||attack_timer[0]>=attack_cooldown[0]:
	#	keep_attacking = true
	attacking = plans[1]
	seen = plans[2]
	if health>0:
		velocity += acceleration
		move_and_slide()
		move_enemy()
		#print("new_anim:",new_anim,
		#" keep_attacking:",keep_attacking,
		#" animation:",$AnimatedSprite2D.animation,
		#" frame:",$AnimatedSprite2D.frame,
		#" walk:",pressed[0]||pressed[1],
		#" attack:",attacking,
		#" attack_timer:",attack_timer)
		if attacking[0]||keep_attacking:
			if attack_timer[0]>=attack_cooldown[0]||keep_attacking:
				if attack_timer[0]>=attack_cooldown[0]:
					attack_timer[0]=0
					seen.health-=damage[0]
				if new_anim:
					$AnimatedSprite2D.play("Bite")
					new_anim=false
					keep_attacking=false
				else:
					keep_attacking=true
		elif pressed[0]||pressed[1]:
			if new_anim:
				$AnimatedSprite2D.play("Walk")
				new_anim=false
		else:
			if new_anim:
				$AnimatedSprite2D.play("Idle")
				new_anim=false
	else:
		$AnimatedSprite2D.flip_v=true
		$AnimatedSprite2D.stop()

#Runs when an animation finishes
func _on_animated_sprite_2d_animation_finished() -> void:
	new_anim = true
	$AnimatedSprite2D.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_attack = false
