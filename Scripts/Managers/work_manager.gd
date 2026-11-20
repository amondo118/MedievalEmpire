extends Node
@onready var root: Control = $"../../Ui/Root"
@onready var kin_manager: Node2D = $"../KinLayer"
@onready var building_manager: Node2D = $"../BuildingLayer"
@onready var resource_manager: Node2D = $"../ResourceLayer"
@onready var selection_manager: Node = $"../SelectionManager"

func _on_interaction_controller_assign_kin_to(target: String) -> void:
	var b :Building = building_manager.get_model(target)
	if b == null:
		return
	var k_id: String = kin_manager.get_unassigned(b.type)
	if k_id == "":
		return
	if kin_manager.assign_kin(k_id, target, b.type, b.marker):
		building_manager.assign_kin(target, kin_manager.get_kin(k_id))
		print(kin_manager.get_kin(k_id).model.name + " assigned to " + b.get_building_type() + " as " + b.get_type())
	
func _on_kin_needs_work(kin:KinController):
	_assign_work(kin)


func _assign_work(kin: KinController):
	var b: Building = building_manager.get_model(kin.model.workBuilding)
	if b == null:
		return
	var tree = resource_manager.get_nearest(b.marker)
	if tree == null:
		return
	kin.work_queue(b.gather(tree))

func _on_building_layer_give_task(building: Variant, kin: Variant) -> void:
	_assign_work(kin)
