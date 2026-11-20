extends Node


@onready var world: Node2D = $"../../World"


var state = 0

var kins: Array[KinController]
var unemployed: Array[String]
var homeless: Array[String]

signal need_work(kin:String)
signal added_kin(kin:String)
signal inv_changed(res:ResourceType,amount:int)
signal kin_update(target_id: String)

func _ready():
	pass
	

func load_bootstrap(b:Resource):
	add_npc()

func _process(_delta):
	pass

func add_npc():
	var kin = KinController.new(world,kins.size())
	kin.need_work.connect(func(k): need_work.emit(k))
	kin.update.connect(func(k): kin_update.emit(k))
	kin.model.inventory.changed.connect(func(r,a): inv_changed.emit(r,a))
	kins.append(kin)
	unemployed.append(kin.id)
	homeless.append(kin.id)
	added_kin.emit(kin)


func get_kin(id_):
	if id_!=null:
		return kins[Entity.num(id_)]



func on_tick():#ticker
	tick_npcs()
	
func get_unassigned_list(Buildingtype: String)->Array:
	return unemployed if Buildingtype=="work" else homeless
	
func get_unassigned(Buildingtype):
	var arr = unemployed if Buildingtype=="work" else homeless
	if arr.size()>0:
		return arr.front()
	return ""
	
func assign_kin(kin:String,building:String,type:String,marker:Vector2)->bool:
	var arr = unemployed if type=="work" else homeless
	if kin in arr:
		arr.pop_at(arr.find(kin))
		get_kin(kin).assignBuilding(building,type,marker)
		return true
	return false

func work_kin(kin,queue):
	kin.work_queue(queue)


func tick_npcs():
	for npc in kins:
		npc.tick()


func _on_timer_temp_timeout() -> void:
	#change state of kin
	pass


func _on_managers_on_tick() -> void:
	tick_npcs()

func get_kin_info(id_):
	var kin = get_kin(id_)
	if kin!=null:
		return kin.select_info()
	return null
