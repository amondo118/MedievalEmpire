extends Manager

const CAMP_RES = preload("uid://cq34e63m64n36")
const LOGGINGCAMP_RES = preload("uid://lc0mnouheex4")

@onready var world: Node2D = $"../../World"

var list := [CAMP_RES, LOGGINGCAMP_RES]   # index = build key - 1
var controllers: Array[BuildingController] = []
var to_build: BuildingData = null

signal give_task(building: Building, kin: KinController)
signal added_building(controller: BuildingController)
signal inv_changed(res:ResourceType,amount:int)

# --- like KinManager: bootstrap / add / tick ---
func load_bootstrap(b: Resource) -> void:
	add_building(CAMP_RES, b.camp_pos)

func add_building(res: BuildingData, pos: Vector2) -> BuildingController:
	var c := BuildingController.new(res, pos, world,controllers.size())
	c.give_task.connect(func(b, k): give_task.emit(b, k))
	controllers.append(c)
	added_building.emit(c)
	c.model.inventory.changed.connect(func(r,a): inv_changed.emit(r,a))
	return c

func on_tick() -> void:
	for c in controllers:
		c.on_tick()

# --- like KinManager.get_unassigned / assign_kin ---
func get_model(bid:StringName) -> Building:
	if Entity.pref(bid)=="b":
		var c=controllers[bid.substr(1).to_int()]
		return c.model
	return null
	
func get_controller(bid:StringName) -> BuildingController:
	if Entity.pref(bid)=="b":
		var c=controllers[bid.substr(1).to_int()]
		return c
	return null

func get_view(bid:StringName) -> Node2D:
	if Entity.pref(bid)=="b":
		var c=controllers[bid.substr(1).to_int()]
		return c.view
	return null

func assign_kin(bid:StringName, kin: KinController) -> bool:
	get_controller(bid).assign_kin(kin)
	return false

# --- build mode (signals from InteractionController) ---
func _on_interaction_controller_to_build(b: int) -> void:
	to_build = list[b - 1] if b > 0 else null

func _on_interaction_controller_build_at(pos: Vector2) -> void:
	if to_build != null:
		add_building(to_build, pos)
		to_build = null
