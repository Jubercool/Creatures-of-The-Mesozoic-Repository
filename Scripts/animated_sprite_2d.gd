extends AnimatedSprite2D
var acceleration = Vector2()
var velocity = Vector2()
var pressed = [false,false]
var max_vel = 10
var acceleration_base = 0.7
var acceleration_buff = 1
var friction = 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	acceleration = Vector2(0,0)
	velocity = Vector2(0,0)
	pressed = [false,false]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity += acceleration
	position += velocity
	pressed = [false,false]
	if Input.is_action_pressed("ui_left"):
		if velocity.x>-max_vel:
			if velocity.x>0:
				acceleration.x=-acceleration_buff
			else:
				acceleration.x=-acceleration_base
		else:
			acceleration.x=0
		pressed[0]=true
		flip_h=true
	if Input.is_action_pressed("ui_up"):
		if velocity.y>-max_vel:
			if velocity.y>0:
				acceleration.y=-acceleration_buff
			else:
				acceleration.y=-acceleration_base
		else:
			acceleration.y=0
		pressed[1]=true
	if Input.is_action_pressed("ui_right"):
		if velocity.x<max_vel:
			if velocity.x<0:
				acceleration.x=acceleration_buff
			else:
				acceleration.x=acceleration_base
		else:
			acceleration.x=0
		pressed[0]=true
		flip_h=false
	if Input.is_action_pressed("ui_down"):
		if velocity.y<max_vel:
			if velocity.y<0:
				acceleration.y=acceleration_buff
			else:
				acceleration.y=acceleration_base
		else:
			acceleration.y=0
		pressed[1]=true
	if not pressed[0]:
		acceleration.x=-friction*velocity.x
	if not pressed[1]:
		acceleration.y=-friction*velocity.y
	if Input.is_action_just_pressed("left_click"):
		play("bite")
		frame=1
	if frame==0:
		stop()
