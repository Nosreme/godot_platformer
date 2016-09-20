
extends KinematicBody2D

const GRAV = 500
const WALK_SPEED = 40
const JUMP_SPEED = 200
const DUB_JUMP_SPEED = 150
var velocity = Vector2()
var jumping = false
var dub_jumping = false
var air_time = 100
var feet
var anim
var falling = false
var dub_jump_rdy = false

func _ready():
	feet = get_node("feet")
	anim = get_node("Sprite/anim")
	feet.add_exception(self)
	set_fixed_process(true)
	set_process_input(true)
	anim.play("walk")
	anim.stop(true)
	anim.seek(0.0, true)
	
func _input(event):
	#If feet ray is detecting collision, allow a jump.
	if (event.is_action_pressed("ui_up") and feet.is_colliding()):
		velocity.y = -JUMP_SPEED
		print("jumping!")
		jumping = true
		anim.stop(true)
		anim.play("jump")
	#If feet ray isn't colliding, but double jump is false, allow a double jump.
	if (event.is_action_pressed("ui_up") and not feet.is_colliding() and not dub_jumping):
		velocity.y = -DUB_JUMP_SPEED
		print("Dub Jumping!")
		anim.stop(true)
		anim.play("jump")
		dub_jumping = true
	#Don't play "walk" animation while jumping.
	if (event.is_action_pressed("ui_right") and jumping):
		pass
	#Otherwise play walk animation.
	elif (event.is_action_pressed("ui_right")):
		anim.stop(true)
		anim.play("walk")
	#Stop walk animation when "ui_right" released.
	if event.is_action_released("ui_right"):
		anim.stop(true)
		anim.seek(0.0, true)
	
func _fixed_process(delta):
	velocity.y += delta * GRAV

	if (Input.is_action_pressed("ui_left")):
		velocity.x = -WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
		velocity.x = WALK_SPEED
	else:
		velocity.x = 0
		
	var motion = velocity * delta
	move(motion)
	
	if(is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	if feet.is_colliding():
		print("Colliding!")
		jumping = false
		dub_jumping = false
	


