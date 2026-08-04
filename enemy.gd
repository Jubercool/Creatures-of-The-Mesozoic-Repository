extends CharacterBody2D

#Health
var health = 100
var damage = [25]

#Movement Variables
var acceleration = Vector2()
var pressed = [false,false]
var max_vel = 8
var acceleration_base = 0.7
var acceleration_buff = 1
var friction = 0.2

#AI variables
var seen = false
var moving = [false,false,false,false]
var attacking = [false]
var attack_timer = [0]
var attack_cooldown = [20]
var attacking_dist = 300
var intrest_timer_init = 1000
var intrest_timer = intrest_timer_init
var target2 = Vector2i(0,0)

#Other
@onready var player = $"../Player"
var target = player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	acceleration = Vector2(0,0)
	velocity = Vector2(0,0)
	pressed = [false,false]
	seen = false
	moving = [true,false,false,false]
	attacking = [false]
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

func _on_timer_timeout() -> void:
	if(is_node_ready()):
		$Timer.start()
		$NavigationAgent2D.target_position=target.position
		target2 = $NavigationAgent2D.get_next_path_position()

#Stops the animation playing when it ends
func _on_animation_finished() -> void:
	$AnimatedSprite2D.stop()

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
	var seen = true
	
	#Checks if the distance to the target is less than attacking_dist
	if(sqrt((position.x-target.position.x)**2+(position.y-target.position.y)**2)<attacking_dist):
		attack[0] = true
		attack_timer[0]+=1
		if(attack_timer[0]==attack_cooldown[0]):
			attack_timer[0]=0
			target.health-=damage[0]
	return [pathfind(position,target.position),attack,true]

#Logic for when an enemy is not attacking a target
func wander() -> Array:
	var target_type = randi_range(0,4)
	return [pathfind(position,player.position),[false],true]

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
		$AnimatedSprite2D.flip_h=false
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
		$AnimatedSprite2D.flip_h=true
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
	var plans = [[false,false,false,false],[false],false]
	if seen:
		target = player
		plans = fight()
	else:
		plans = wander()
	moving = plans[0]
	attacking = plans[1]
	seen = plans[2]
	if health>0:
		velocity += acceleration
		position += velocity
		move_enemy()
	if attacking[0]:
		if $AnimatedSprite2D.frame==0:
			$AnimatedSprite2D.play("Bite")
	elif pressed[0]||pressed[1]:
		if $AnimatedSprite2D.frame==0:
			$AnimatedSprite2D.play("Walk")
	else:
		if $AnimatedSprite2D.frame==0:
			$AnimatedSprite2D.play("Idle")
