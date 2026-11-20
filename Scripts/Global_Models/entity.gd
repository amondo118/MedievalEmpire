class_name Entity

var id : StringName
var position : Vector2
var inventory : Inventory




func _init(init :Dictionary={},storage_max :int =0,position_:Vector2=Vector2(0.0,0.0),_id : StringName=""):
	inventory=Inventory.new(init,storage_max)
	position = position_
	id = _id

static func pref(id_:StringName)->String:
	return id_.substr(0, 1)

static func num(id_: String) -> int:
	return id_.substr(1).to_int()
