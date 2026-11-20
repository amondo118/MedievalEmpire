extends Node

var selected_entity := ""

signal selected()
signal select(info:Dictionary)
signal update(info:Dictionary)
signal deselected()

@onready var kin_manager= $"../KinLayer"
@onready var building_manager=$"../BuildingLayer"

func _on_building_selected(target_id: String) -> void:
	if selected_entity =="":
		selected.emit()
	var info = building_manager.get_building_info(target_id)
	if info:
		selected_entity = target_id
		select.emit(info)
		print("Selected building: "+target_id)

func _on_kin_selected(target_id: String) -> void:
	if selected_entity =="":
		selected.emit()
	var info = kin_manager.get_kin_info(target_id)
	if info:
		info["home"] = building_manager.get_building_name(info["home"])
		info["work"] = building_manager.get_building_name(info["work"])
		selected_entity = target_id
		select.emit(info)
		print("Selected kin: "+target_id)

func _on_deselect() -> void:
	selected_entity = ""
	deselected.emit()
	print("Deselected")


func _on_kin_update(target_id: String) -> void:
	if selected_entity == target_id:
		var info = kin_manager.get_kin_info(target_id)
		if info:
			info["home"] = building_manager.get_building_name(info["home"])
			info["work"] = building_manager.get_building_name(info["work"])
			update.emit(info)
			print("Updated kin: "+target_id)

func _on_building_update(target_id: String) -> void:
	if selected_entity == target_id:
		var info = building_manager.get_building_info(target_id)
		if info:
			update.emit(info)
			print("Updated building: "+target_id)


func _on_exit_selection() -> void:
	selected_entity=""
