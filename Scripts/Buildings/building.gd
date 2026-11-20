class_name Building
extends Entity

var type: String
var buildingType: StringName
var assigned_kin: Array[KinController] = []
var data: BuildingData
var marker: Vector2
var jobTitle: String

func _init(building_data: BuildingData, position_: Vector2 = Vector2.ZERO,_id:StringName=""):
	super(building_data.inv.duplicate(),building_data.max_storage,position_,_id)
	data = building_data
	buildingType = building_data.b_name
	jobTitle = building_data.jobTitle
	position = position_
	marker = position_ + data.marker_offset
	match buildingType:
		"loggingcamp":
			type = "work"
		_:
			type = "home"

func get_type() -> String:
	return type

func get_building_type() -> StringName:
	return buildingType

func add_kin(kin: KinController):
	if kin not in assigned_kin:
		assigned_kin.append(kin)

func gather(target: NaturalResource) -> Array[Task]:
	var task_queue: Array[Task] = [
		Task.go_to(target.marker),
		Task.get_from(target.inventory, target.resource, 1),
		Task.go_to(marker),
		Task.deposit_to(inventory, target.resource, 1),
	]
	return task_queue
	

func get_inv_string() -> String:
	return inventory.get_inv_string()

func get_building_name() -> String:
	return data.b_name