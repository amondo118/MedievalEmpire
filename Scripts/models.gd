#models.gd
const Classes = preload("uid://dersxqgqlkdbj")
const VillagerNode = preload("uid://bv677ayaxufad")
const VILLAGER = preload("uid://ca2vpnuvlw2tk")




class Entity:
	var kind: String
	var position : Vector2
	var inventory : Classes.Inventory

	func _init(kind_:String,position_:Vector2=Vector2(0.0,0.0)):
		kind = kind_
		position = position_
		match kind:# TEMP
			"treenode":
				inventory = Classes.Inventory.new({0:100},100)






class Villager extends Entity:
	var name
	var workBuilding : Building
	var homeBuilding : Building
	var target : Entity
	var manager : Node
	var node : CharacterBody2D
	var currentState: String = "idle"
	var States:Array[String]=["idle","work","returning_home"]
	var task_queue:Array[Dictionary]=[]
	var currentTask = null
	var idleForTick = 0

	#var priorities

	func _init(name_:String,manager_:Node,home_:Building=null,position_:Vector2=Vector2(0.0,0.0)):
		inventory = Classes.Inventory.new({0:0},1)
		homeBuilding=home_
		name = name_
		position=position_
		manager = manager_
		
		currentState = "idle"
		
		var n = VILLAGER.instantiate()
		manager.add_child(n)
		n.arrived.connect(_villager_arrived.bind())
		node=n

	func assignWorkBuilding(work_:Building):
		workBuilding=work_

	

	func _villager_arrived():
		position=node.position
		currentTask=null

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

	func work_queue(queue:Array[Dictionary]):
		task_queue=queue.duplicate()
		state_change("work")

	func do_task(task:Dictionary):
		match task.get("type"):
			"go_to":
				node.go_to(task.get("target"))
			"get_from":
				inventory.get_from(task.get("target"),task.get("resource"),task.get("amount"))
				currentTask=null
			"deposit_to":
				inventory.transfer_to(task.get("target"),task.get("resource"),task.get("amount"))
				currentTask=null

	

	func tick():
		if currentTask!=null:
			return
			
		if currentState == "idle":
			if idleForTick >= 5 and node.position.distance_to(homeBuilding.position) > 10:
				state_change("returning_home")
				task_queue=[{	"type": "go_to",
								"target": homeBuilding.position}]
				print("Returning Home")
			else:
				
				idleForTick+=1
				return
		
		if task_queue.is_empty():
			state_change("idle")
			node.wander()
			idleForTick=0
			return
		
			
		currentTask = task_queue.pop_front()
		do_task(currentTask)
		
		





class Building extends Entity:
	var buildingType :String
	var workers : Dictionary[Villager,String] = {}

	
	func _init(buildingType_:String,position_:Vector2=Vector2(0.0,0.0)):
		buildingType=buildingType_
		position=position_
		match buildingType:
			"loggingcamp":
				inventory = Classes.Inventory.new({0:0},50)
			_:
				inventory = Classes.Inventory.new()

	func gather(treenode:Entity): #TEMP only logcamp
		var task_queue:Array[Dictionary] = [
			{
		"type": "go_to",
		"target": treenode.position
			},
			{
		"type": "get_from",
		"target": treenode.inventory,
		"resource": Classes.Inventory.Type.log,
		"amount": 1
			},
			{
		"type": "go_to",
		"target": position
			},
			{
		"type": "deposit_to",
		"target": inventory,
		"resource": Classes.Inventory.Type.log,
		"amount": 1
			}
		]
		return task_queue

class ResourceNode extends Entity:
	var resourceType : String
	var naturalResource= {}
	
	
	func _init(resourceType_:String,position_:Vector2=Vector2(0.0,0.0)):
		resourceType=resourceType_
		
		
		
		
		
class NaturalResource extends Entity:
	var resourceType : String
	
	var positions :PackedVector2Array
	var resourceCount:int
	
	
	func _init(resourceType_:String):
		resourceType = resourceType_
		match resourceType:
			"tree":
				resourceCount=1
		
		


		
		
		
		
		
		
		
		
