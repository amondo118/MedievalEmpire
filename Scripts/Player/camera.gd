extends Node2D
@onready var camera_2d = $Camera2D


var zoom =1.0
@export var speed = 4 
var max_zoom = [0.5,2.5] 
var velocity : Vector2
func _input(_event):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	var z =0.0
	if Input.is_action_pressed("zoom_in") and max_zoom[1] >= zoom:
		z += 0.1
	elif Input.is_action_pressed("zoom_out") and  zoom >= max_zoom[0]:
		z-= 0.1

	zoom+=z
	
func _physics_process(_delta):
	move_local_x(velocity.x)
	move_local_y(velocity.y)
	camera_2d.zoom = Vector2(zoom,zoom)
