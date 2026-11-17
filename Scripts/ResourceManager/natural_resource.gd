class_name NaturalResource
extends Entity

var data :ResourceData
var res_name : String
var resource : ResourceType
var marker : Vector2

signal depleted(node: NaturalResource)

func _init(data_: ResourceData,position_:Vector2,_id:StringName=""):
	super(data_.starting_res.duplicate(),data_.max_storage,position_,_id)
	data = data_
	resource = data.resource
	res_name = data.name
	marker = position+data.marker_offset
	inventory.depleted.connect(dep)
	
	
func dep(): 
	depleted.emit(self)
