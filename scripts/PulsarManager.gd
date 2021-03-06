extends Node2D

class_name PulsarManager

signal pulsar_activation_requested
signal pulsar_group_activated
signal pulsar_group_desactivated

var type : int

var _nb_expected : int
var _nb_active := 0
var _switchs := []
var _push_up_on_activated := []

func _ready():
	_nb_expected = 0
	var type = 0;
	for child in get_children():
		if child.is_in_group("pulsar_switchs"):
			_nb_expected += 1
			_switchs.append(child)
			child.connect("activated", self, "_on_Pulsar_activated")
			child.connect("desactivated", self, "_on_Pulsar_desactivated")
			child.connect("activation_requested", self, "_on_Pulsar_activation_requested")
			self.connect("pulsar_group_activated", child, "_on_PulsarManagar_pulsar_group_activated")
			self.connect("pulsar_group_desactivated", child, "_on_PulsarManagar_pulsar_group_desactivated")
		elif child.is_in_group("pulsar_targets"):
			_push_up_on_activated.push_back(child)

func start():
	for child in _switchs:
		child.start()

func activate(pulsar : Pulsar):
	pulsar.activate()

func desactivate_all():
	for child in _switchs:
		var pulsar : Pulsar = child
		pulsar.turn_off()

func _on_Pulsar_activation_requested(pulsar : Pulsar):
	emit_signal("pulsar_activation_requested", type, self, pulsar)

func _on_Pulsar_activated():
	_nb_active += 1
	if _nb_active == _nb_expected:
		for push_up in _push_up_on_activated:
			var big_pulsar : BigPulsar = push_up
			big_pulsar.z_index = 2
			big_pulsar.switch()
		emit_signal("pulsar_group_activated", type)

func _on_Pulsar_desactivated():
	if _nb_active == _nb_expected:
		for push_up in _push_up_on_activated:
			var big_pulsar : BigPulsar = push_up
			big_pulsar.z_index = 0
			big_pulsar.switch()
		emit_signal("pulsar_group_desactivated", type)
	_nb_active -= 1
	
