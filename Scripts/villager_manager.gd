extends Node

const Classes = preload("uid://dersxqgqlkdbj")
const Models = preload("uid://bo0lqe2x4opmc")




@onready var timer_temp = $"../../Timers/Timer-TEMP"
@onready var tick = $"../../Timers/Tick"





var state = 0

var npcs: Array[Models.Villager] =[]

var loggingcamp : Models.Building
var homelesscamp: Models.Building



func _ready():
	#loggingcamp = Models.Building.new("loggingcamp",Vector2(200.0,200.0))
	#var l = LOGGING_CAMP.instantiate()
	#l.position = loggingcamp.position
	#add_child(l)
	#homelesscamp = Models.Building.new("homelesscamp",Vector2(100.0,-20.0))
	#var h = CAMP.instantiate()
	#h.position=homelesscamp.position
	#add_child(h)
	
	add_npc()
	

func _process(_delta):
	pass

func add_npc():
	var villager = Models.Villager.new("James Smith",self,homelesscamp)
	villager.assignWorkBuilding(loggingcamp)
	npcs.append(villager)


func _on_timer():#controller
	#work_npc(npcs[0],treenode)
	pass


func _on_tick():#ticker
	#tick_npcs()
	pass



func work_npc(npc,target):
	npc.work_queue(loggingcamp.gather(target))

func tick_npcs():
	for npc in npcs:
		npc.tick()
