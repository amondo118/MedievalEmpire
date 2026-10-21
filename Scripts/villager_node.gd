extends CharacterBody2D

class_name Villager_Node
const Classes = preload("uid://dersxqgqlkdbj")
const Models = preload("uid://bo0lqe2x4opmc")


@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
var anim
enum State {idle, walk, gather}
var current_state = State.idle

signal arrived


@export var walk_speed := 50.0
@export var wander_radius := 150.0

func _ready():  
	pass


func _physics_process(_delta):
	if current_state==State.walk:
			walk()


func animate():
	match current_state:
		State.idle:
			anim = "idle"
		State.walk:
			anim = "walk"
		State.gather:
			anim = "idle"
	animated_sprite_2d.animation=anim


func set_state(s:State):
	current_state = s 
	animate()

func go_to(t):
	navigation_agent_2d.target_position=t
	set_state(State.walk)

func gather():
	set_state(State.gather)

func wander():
	set_state(State.idle)

func walk():
	if navigation_agent_2d.is_navigation_finished():
		self.stop_walking()
		return
		
	var next_position = navigation_agent_2d.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	
	velocity=direction*walk_speed
	move_and_slide()

func stop_walking():
	set_state(State.idle)
	velocity = Vector2.ZERO 
	emit_signal("arrived")
