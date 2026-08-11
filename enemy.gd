extends CharacterBody2D
@onready var player = $"../Player"

#Health
var health = 100
var damage = [25]

#Movement Variables
var acceleration = Vector2()
var pressed = [false,false]
var walk_max_vel = 400
var max_vel = walk_max_vel
var sprint_max_vel = 800
var acceleration_base = 70
var acceleration_buff = 100
var friction = 0.2
var new_anim = true
var keep_attacking = false

#AI variables
var wander_range = 1000
var new_target = true
var seen = player
var moving = [false,false,false,false]
var attacking = [false]
var attack_cooldown = [200]
var attack_timer = [attack_cooldown[0]/2]
var canattack = true
var attacking_dist = 300
var intrest_timer_init = 1000
var intrest_timer = intrest_timer_init
var target2 = Vector2i(0,0)

#Other
var target_position = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_navigation_agent_2d_navigation_finished() -> void:
	new_target=true

func _on_timer_timeout() -> void:
	if(is_node_ready() and target_position!=null):
		$Timer.start()
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
func fight() -> Array:
	var attack = [false]
	seen = player
	max_vel=sprint_max_vel
	#Checks if the distance to the target is less than attacking_dist
	if(sqrt((position.x-target_position.x)**2+(position.y-target_position.y)**2)<attacking_dist):
		attack[0] = true
		attack_timer[0]+=1
	return [pathfind(position,target_position),attack,player]

#Logic for when an enemy is not attacking a target
func wander() -> Array:
	max_vel = walk_max_vel
	if(new_target):
		var target_type = 0#randi_range(0,3)
		if(target_type==0):
			target_position=Vector2i(randi_range(-wander_range,wander_range),randi_range(-wander_range,wander_range))
		new_target=false
	return [pathfind(position,target_position),[false],player]

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var plans = [[false,false,false,false],[false],null]
	if seen!=null:
		target_position = seen.position
		plans = fight()
	else:
		plans = wander()
	moving = plans[0]
	if !plans[1][0]||attack_timer[0]==attack_cooldown[0]:
		keep_attacking = true
	attacking = plans[1]
	seen = plans[2]
	if health>0:
		velocity += acceleration
		move_and_slide()
		move_enemy()
		if attacking[0]:
			if attack_timer[0]==attack_cooldown[0]:
				attack_timer[0]=0
				seen.health-=damage[0]
			if new_anim && keep_attacking:
				$AnimatedSprite2D.play("Bite")
				keep_attacking = false
				new_anim=false
		elif pressed[0]||pressed[1]:
			if new_anim:
				$AnimatedSprite2D.play("Walk")
				new_anim=false
		else:
			if new_anim:
				$AnimatedSprite2D.play("Idle")
				new_anim=false
		if !keep_attacking:
			if new_anim:
				$AnimatedSprite2D.play("Walk")
				new_anim=false
	else:
		$AnimatedSprite2D.flip_v=true
		$AnimatedSprite2D.stop()


func _on_animated_sprite_2d_animation_finished() -> void:
	new_anim = true
	$AnimatedSprite2D.stop()
