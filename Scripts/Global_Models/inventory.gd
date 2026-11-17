class_name Inventory


var resources :Dictionary
var current_storage := 0
var max_storage := 0
signal depleted(type)
signal changed(res,amount)

func _init(_initial:Dictionary={},_storageMax:int=0):
	max_storage=_storageMax
	if _initial.is_empty():
		return
	for res in _initial:
		add(res,_initial[res])


func add(type :ResourceType, quantity:int) -> bool:
	if quantity<=0 or current_storage + quantity > max_storage:
		return false
	resources[type]=resources.get(type,0)+quantity
	current_storage+=quantity
	changed.emit(type,quantity)
	return true
	
func remove(type :ResourceType, quantity:int) -> bool:
	if quantity<= 0 or not resources.has(type) or resources[type]<quantity:
		return false

	resources[type]-=quantity
	current_storage-=quantity
	if resources[type] == 0:
		depleted.emit()
		
	changed.emit(type,-quantity)
	return true
	
func amount(type :ResourceType) -> int:
		return resources.get(type,0)
	

func has(type : ResourceType,quantity: int = 1)->bool:
	return resources.has(type) and resources[type]>=quantity
	
func can_add(quantity:int) -> bool:
	return current_storage + quantity <= max_storage
	
func transfer_to(other:Inventory,type :ResourceType, quantity:int)->bool:
	if  has(type,quantity) and other.can_add(quantity):
		remove(type,quantity)
		other.add(type,quantity)
		print("Added ",quantity)
		return true
	prints(has(type,quantity) , other.can_add(quantity),quantity,current_storage)
	return false
	
func get_from(other:Inventory,type :ResourceType, quantity:int)->bool:
	if  other.has(type,quantity) and can_add(quantity):
		other.remove(type,quantity)
		add(type,quantity)
		print("Got ",quantity)
		return true
	prints(other.has(type,quantity) , can_add(quantity))
	return false
