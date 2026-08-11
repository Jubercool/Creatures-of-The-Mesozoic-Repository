# This is a comment from Jim
extends CharacterBody2D

#Health
var max_health = 100
var health = 100
var damage = [50]
var attacking_dist = 300

#Movement Variables
var acceleration = Vector2()
var pressed = [false,false]
var max_vel = 1000
var acceleration_base = 70
var acceleration_buff = 100
var friction = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	acceleration = Vector2(0,0)
	velocity = Vector2(0,0)
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

#Stops the animation playing when it ends
func _on_animation_finished() -> void:
	$AnimatedSprite2D.stop()

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health>0:
		velocity += acceleration
		move_and_slide()
		move_player()
	if Input.is_action_just_pressed("left_click"):
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			if sqrt((position.x-enemy.position.x)**2+(position.y-enemy.position.y)**2)<attacking_dist:
				enemy.health-=damage[0]
		if $AnimatedSprite2D.frame==0:
			$AnimatedSprite2D.play("Bite")
