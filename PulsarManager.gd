extends Node2D

signal pulsar_group_activated
signal pulsar_group_desactivated

var _nb_expected : int
var _nb_active := 0

func _ready():
	_nb_expected = get_child_count()
	for child in get_children():
		child.connect("activated", self, "_on_Pulsar_activated")
		child.connect("desactivated", self, "_on_Pulsar_desactivated")
		self.connect("pulsar_group_activated", child, "_on_PulsarManagar_pulsar_group_activated")
		self.connect("pulsar_group_desactivated", child, "_on_PulsarManagar_pulsar_group_desactivated")
		
func _on_Pulsar_activated():
	_nb_active += 1
	if _nb_active == _nb_expected:
		emit_signal("pulsar_group_activated")

func _on_Pulsar_desactivated():
	if _nb_active == _nb_expected:
		emit_signal("pulsar_group_desactivated")
	_nb_active -= 1
	
