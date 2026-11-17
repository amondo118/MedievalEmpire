class_name KinController

const KIN_RES = preload("uid://c5cja1iwxlrvd")

signal need_work(kin:KinController)

var view : CharacterBody2D
var model : Kin
var currentState: String = "idle"
var States:Array[String]=["idle","work","returning_home"]
var task_queue:Array[Task]=[]
var work_template: Array[Task] = []
var id : String

var currentTask = null
var idleForTick = 0

func get_name():
	return model.name

func _init(view_layer: Node,id_num) -> void:
	id = ("k"+String.num_int64(id_num))
	model = Kin.new(KIN_RES.names[randi_range(0,3)],KIN_RES,id)
	view = KIN_RES.scene.instantiate()
	view.position = model.position
	view.id = id
	view.connect("arrived",_villager_arrived)
	view_layer.add_child(view)
	state_change("idle")
	
	
func state_change(state_to: String): 
	match state_to:
		"idle":
			pass
			
		"work":
			pass
		"returning_home":
			pass

	currentState = state_to
	print(currentState)

func work_queue(queue:Array[Task]):
	work_template = queue.duplicate()
	task_queue=queue.duplicate()
	state_change("work")

func do_task(task:Task):
	match task.type:
		Task.Type.GO_TO:
			view.go_to(task.target)
			#print("Going")
		Task.Type.GET_FROM:
			model.inventory.get_from(task.target,task.resource,task.amount)
			#print("Getting",task.amount)
			currentTask=null
		Task.Type.DEPOSIT_TO:
			model.inventory.transfer_to(task.target,task.resource,task.amount)
			#print("Depositing",task.amount)
			currentTask=null



func tick():
	if currentTask != null:
		return

	# Repeat the saved work loop when the queue runs out
	if task_queue.is_empty() and currentState == "work":
		need_work.emit(self)

	if task_queue.is_empty():
		if currentState == "idle" and idleForTick >= 5 and model.homeBuilding != null \
				and view.position.distance_to(model.homeMarker) > 10:
			state_change("returning_home")
			task_queue = [Task.go_to(model.homeMarker)]
			print("Returning Home")
		else:
			if currentState != "idle":
				state_change("idle")
				view.wander()
			idleForTick += 1
			return

	currentTask = task_queue.pop_front()
	do_task(currentTask)
	
func assignBuilding(b_:String,type:String,marker:Vector2):
	match type:
		"work":
			model.workBuilding=b_
			model.workMarker=marker
		"home":
			model.homeBuilding=b_
			model.homeMarker=marker

func select_info():
	return {"name":model.name,"home":model.homeBuilding,
	"work":model.workBuilding,"Task":currentTask}

func get_pos():
	model.position=view.position
	return model.position

func _villager_arrived():
	model.position=view.position
	currentTask=null
