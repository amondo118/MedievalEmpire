extends Node
class_name MainManager
const BOOTSTRAP = preload("uid://uvkvlwv77cme")
@onready var kin_manager: Node = $KinLayer
@onready var building_manager: Node = $BuildingLayer
@onready var resource_manager: Node = $ResourceLayer 
var root: UserInerface 
@onready var ui: CanvasLayer = $"../Ui"
const UI = preload("uid://dpg7mjd70ii6u")

signal on_tick



func _ready() -> void:
	root=UI.instantiate()
	ui.add_child(root)
	kin_manager.need_work.connect(_on_kin_needs_work)
	kin_manager.added_kin.connect(root.added_kin)
	kin_manager.inv_changed.connect(func(r,a):root._on_resource_changed(r,a))
	building_manager.added_building.connect(root.added_building)
	building_manager.inv_changed.connect(func(r,a):root._on_resource_changed(r,a))
	
	load_bootstrap(BOOTSTRAP)
	
	
func load_bootstrap(b:Resource):
	kin_manager.load_bootstrap(b)
	building_manager.load_bootstrap(b)
	resource_manager.load_bootstrap(b)


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
	
func _on_tick_timeout() -> void:
	on_tick.emit()

func _assign_work(kin: KinController):
	var b: Building = building_manager.get_model(kin.model.workBuilding)
	if b == null:
		return
	var tree = resource_manager.get_nearest(b.marker)
	if tree == null:
		kin.model.workBuilding = ""
		return
	kin.work_queue(b.gather(tree))

func _on_building_layer_give_task(building: Variant, kin: Variant) -> void:
	_assign_work(kin)

func ui_select(entityID:String):
	root

func _on_interaction_controller_building_selected(target_id: String) -> void:
	ui_select(target_id)
