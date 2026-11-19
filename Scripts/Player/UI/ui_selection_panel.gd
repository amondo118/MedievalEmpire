extends Control
class_name SelectionPanel


@onready var kin_selection_panel :Dictionary={
	"panel": $Kin,
	"name": $Kin/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Name1,
	"home": $Kin/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/HBoxContainer/Home1,
	"work":$Kin/MarginContainer/VBoxContainer/PanelContainer5/MarginContainer/HBoxContainer/Work1,
	"task":$Kin/MarginContainer/VBoxContainer/PanelContainer6/MarginContainer/HBoxContainer/Task1
}
@onready var building_selection_panel:Dictionary ={
	"panel": $Building,
	"name":$Building/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Type1,
	"kinLabel":$Building/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/HBoxContainer/Kin,
	"kinCount":$Building/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/HBoxContainer/kincount,
	"job":$Building/MarginContainer/VBoxContainer/PanelContainer5/MarginContainer/HBoxContainer/Job2,
	"inv":$Building/MarginContainer/VBoxContainer/PanelContainer6/MarginContainer/HBoxContainer/Inv1
}

var selected_id=""

signal hide_select_panel
signal assign_kin_to(target_id: String)



func hide_selectionpanel():
	visible = false
	kin_selection_panel["panel"].visible = false
	building_selection_panel["panel"].visible=false
	selected_id=""

func _on_select_kin(kin:Dictionary,_id:String=""):
	selected_id=_id
	visible = true
	building_selection_panel["panel"].visible=false
	kin_selection_panel["panel"].visible = true
	kin_selection_panel["name"].text = kin["name"]
	kin_selection_panel["home"].text = kin["home"]
	kin_selection_panel["work"].text = kin["work"]
	kin_selection_panel["task"].text = kin["task"]
	
func _on_select_building(building:Dictionary,_id:String=""):
	selected_id=_id
	visible = true
	kin_selection_panel["panel"].visible = false
	building_selection_panel["panel"].visible=true
	#building_selection_panel["name"].text= building["name"]
	#building_selection_panel["kinLabel"].text= building["kinLabel"]
	#building_selection_panel["kinCount"].text= building["kinCount"]
	#building_selection_panel["job"].text= building["job"]
	#building_selection_panel["inv"].text= building["inv"]


func _on_hide_button_down() -> void:
	hide_selectionpanel()
	hide_select_panel.emit()


func _on_assign_kin_button() -> void:
	assign_kin_to.emit(selected_id)
