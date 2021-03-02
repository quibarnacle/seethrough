extends Node2D

signal pulsar_group_activated
signal pulsar_group_desactivated

var _nb_expected : int
var _nb_active := 0
var _push_up_on_activated := []

func _ready():
	_nb_expected = 0
	for child in get_children():
		if child.is_in_group("pulsar_switchs"):
			_nb_expected += 1
			child.connect("activated", self, "_on_Pulsar_activated")
			child.connect("desactivated", self, "_on_Pulsar_desactivated")
			self.connect("pulsar_group_activated", child, "_on_PulsarManagar_pulsar_group_activated")
			self.connect("pulsar_group_desactivated", child, "_on_PulsarManagar_pulsar_group_desactivated")
		elif child.is_in_group("pulsar_targets"):
			_push_up_on_activated.push_back(child)
		
func _on_Pulsar_activated():
	_nb_active += 1
	if _nb_active == _nb_expected:
		for push_up in _push_up_on_activated:
			push_up.z_index = 2
			emit_signal("pulsar_group_activated")

func _on_Pulsar_desactivated():
	if _nb_active == _nb_expected:
		emit_signal("pulsar_group_desactivated")
	_nb_active -= 1
	
