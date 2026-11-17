class_name Kin
extends Entity


var name : String
var workBuilding : String
var workMarker:Vector2
var homeMarker:Vector2
var homeBuilding : String





#var priorities

func _init(name_:String,data:KinData,_id:StringName="",position_:Vector2=Vector2(0.0,0.0),):
	super(data.inv.duplicate(),data.max_storage,position_,_id)
	name = name_

	
