extends Node

class Inventory:
	static var types :Array[String] = ["log","stone","firewood"]
	enum Type {log,stone,firewood}
	enum StorageTypes {general}
	var resources :Dictionary[int,int]
	var current_storage : int
	var max_storage : int
	
	func _init(initialInventory:Dictionary[int,int]={},storageMax:int=0,_storagetype : StorageTypes = StorageTypes.general):
		resources = initialInventory.duplicate()
		current_storage=0
		for v in resources.values():
			current_storage+=v
		max_storage = storageMax
	
	func add(type :Inventory.Type, quantity:int) -> bool:
		if quantity<=0 or current_storage+quantity > max_storage:
			return false
		resources[type]=resources.get(type,0)+quantity
		current_storage+=quantity
		print("Added ",quantity, " ", types[type])
		return true
		
	func remove(type :Inventory.Type, quantity:int) -> bool:
		if quantity<= 0 or not resources.has(type) or resources[type]<quantity:
			return false

		resources[type]-=quantity
		current_storage-=quantity
		print("Got ",quantity, " ",types[type])
		return true
		
	func amount(type :Inventory.Type) -> int:
			return resources.get(type,0)
		
	
	func has(type : Inventory.Type,quantity: int = 1)->bool:
		return resources.has(type) and resources[type]>=quantity
		
	func can_add(quantity:int) -> bool:
		return current_storage + quantity <= max_storage
		
	func transfer_to(other:Inventory,type :Inventory.Type, quantity:int)->bool:
		if  has(type,quantity) and other.can_add(quantity):
			remove(type,quantity)
			other.add(type,quantity)
			return true
		return false
		
	func get_from(other:Inventory,type :Inventory.Type, quantity:int)->bool:
		if  other.has(type,quantity) and can_add(quantity):
			other.remove(type,quantity)
			add(type,quantity)
			return true
		return false
	
	

class ResourceTracker:
	var types = Inventory.types
	
	func update(add_remove: bool,type : Inventory.Type, quantity:int):
		if add_remove:
			print("Added ",quantity, " ", types[type])
			return
		print("Got ",quantity, " ",types[type])
