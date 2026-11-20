class_name Task
extends RefCounted

enum Type {GO_TO, GET_FROM, DEPOSIT_TO}

var type: Type
var target 
var resource: ResourceType
var amount := 1
var info: String = ""


static func go_to(pos:Vector2)->Task:
	var t := Task.new()
	t.type = Type.GO_TO
	t.target = pos
	t.info = "Walking"	
	return t
	
static func get_from(inv:Inventory,res:ResourceType,qty:int) -> Task:
	var t := Task.new()
	t.type = Type.GET_FROM
	t.target=inv as Inventory
	t.resource=res
	t.amount=qty
	t.info="Getting "+res.display_name
	return t

static func deposit_to(inv:Inventory,res:ResourceType,qty:int) -> Task:
	var t := Task.new()
	t.type = Type.DEPOSIT_TO
	t.target = inv as Inventory
	t.resource = res
	t.amount = qty
	t.info = "Depositing "+res.display_name
	return t

func get_info() -> String:
	return info
