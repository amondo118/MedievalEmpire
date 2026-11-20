class_name BuildingController


signal give_task(building: Building, kin: KinController)
signal update(target_id: String)

var model: Building
var view: BuildingView
var id : StringName

func _init(data: BuildingData, pos: Vector2, world: Node2D,id_num:int) -> void:
	id ="b"+String.num_int64(id_num)
	model = Building.new(data, pos,id)
	view = data.scene.instantiate() as BuildingView
	view.position = pos
	view.id = id
	world.add_child(view)

func assign_kin(kin: KinController) -> bool:
	model.add_kin(kin)
	update.emit(id)
	if model.get_type() == "work":
		give_task.emit(model, kin)
		return true
	return false

func on_tick():
	pass

func get_name():
	return model.get_building_type()

func select_info():
	return {"id":id,"name":model.get_building_name(),"kinLabel":"Workers " if model.get_type()=="work" else "Residents: ",
	"kinCount":model.assigned_kin.size(),"job":model.jobTitle,"inv":model.inventory.get_inv_string()}
