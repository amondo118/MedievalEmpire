extends Node

const BOOTSTRAP = preload("uid://uvkvlwv77cme")
@onready var kin_manager: Node2D = $KinLayer
@onready var building_manager: Node2D = $BuildingLayer
@onready var resource_manager: Node2D = $ResourceLayer 
@onready var root: Control = $"../Ui/Root"


signal on_tick



func _ready() -> void:
	load_bootstrap(BOOTSTRAP)
	
	
func load_bootstrap(b:Resource):
	kin_manager.load_bootstrap(b)
	building_manager.load_bootstrap(b)
	resource_manager.load_bootstrap(b)


func _on_tick_timeout() -> void:
	on_tick.emit()
