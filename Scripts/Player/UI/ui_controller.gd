extends Control
class_name UserInerface

@onready var items_menu: TabContainer = $RightBar/RightTab
@onready var loging: RichTextLabel =$LeftBar/Log
@onready var t: Timer = $"t"
@onready var log: Label = $TopBar/HBoxContainer/Log/VBoxContainer/Label
@onready var stone: Label = $TopBar/HBoxContainer/Stone/VBoxContainer/Label
@onready var reed: Label = $TopBar/HBoxContainer/Reed/VBoxContainer/Label
@onready var firewood: Label = $TopBar/HBoxContainer/Firewood/VBoxContainer/Label



var previous:String
var counter : int = 1


func _ready() -> void:
	pass
func log_message(to_print : String):
	if previous ==to_print:
		counter+=1
		to_print=(to_print+" ("+String.num_int64(counter)+")\n")
		
	else:
		previous = to_print
		to_print=(to_print+"\n")
		counter=1
	print(to_print)
	loging.append_text(to_print)
	t.start()

func added_kin(kin:KinController):
	log_message("New kin joined: "+ kin.get_name())

func added_building(building:BuildingController):
	log_message("New building buidt: "+building.get_name())

func _on_t_timeout() -> void:
	if loging.get_paragraph_count() > 0:
		loging.remove_paragraph(0)
	

func _on_resource_changed(res:ResourceType, amount:int):
	match res.id:
		"log":
			log.text = String.num_int64(log.text.to_int()+amount)
	
		"stone":
			stone.text = String.num_int64(stone.text.to_int()+amount)
	
		"reed":
			reed.text = String.num_int64(reed.text.to_int()+amount)
		"firewood":
			firewood.text = String.num_int64(firewood.text.to_int()+amount)
