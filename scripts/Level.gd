extends Node2D

signal finished

export var RADIUS := 20
export(float,0.0,1.0, 0.05) var PLAYER_RELATIVE_RADIUS := 0.8
export var START_POSITION := Vector2(400, 300)

var mask
var finishMask
var player
var collision_shape

var _nb_expected : int
var _nb_active := 0

enum PulsarGroupStatus {INACTIVE, PARTIALLY_ACTIVE, ACTIVE}
var _pulsar_groups := {}
var _pulsar_groups_status := {}
var _blockers := []
var level_start : LevelStart

# Called when the node enters the scene tree for the first time.
func _ready():
	mask = $Mask
	finishMask= $FinishMask	
	player = $Player
	collision_shape = $Player/CollisionShape2D
	_set_radius(RADIUS)
	mask.player = player
	mask.visible = true
	var limits = mask.texture.get_size()
	player.position = Vector2(-100,-100)
	player.limits = limits
	$Player/Camera2D.limit_top=0
	$Player/Camera2D.limit_bottom = limits.y
	$Player/Camera2D.limit_left=0
	$Player/Camera2D.limit_right = limits.x
	
	_nb_expected = 0
	var type = 0
	for child in get_children():
		if child.has_signal("pulsar_group_activated"):
			var pulsar_manager : PulsarManager = child
			pulsar_manager.connect("pulsar_group_activated", self, "_on_PulsarManager_activated")
			pulsar_manager.connect("pulsar_group_desactivated", self, "_on_PulsarManager_desactivated")
			pulsar_manager.connect("pulsar_activation_requested", self, "_on_PulsarManager_pulsar_activation_requested")
			_nb_expected += 1
			_pulsar_groups_status[type] = PulsarGroupStatus.INACTIVE
			_pulsar_groups[type] = pulsar_manager
			pulsar_manager.type = type
			type +=1
		elif child.is_in_group("blockers"):
			_blockers.append(child)
		elif child.is_in_group("level_start"):
			level_start = child
	if level_start != null:
		player.follow(level_start.follower())
		level_start.connect("finished", self, "_on_LevelStart_finished")
		level_start.start()
	else:
		start()

func start():
	mask.reset_mask()
	player.start()
	player.position = START_POSITION
	for group in _pulsar_groups.values():
		group.start()

func _on_LevelStart_finished():
	start()

func _on_PulsarManager_pulsar_activation_requested(type : int, pulsarManager : PulsarManager, pulsar : Pulsar):
	for key in _pulsar_groups.keys():
		if key != type && _pulsar_groups_status[key] == PulsarGroupStatus.PARTIALLY_ACTIVE:
			_pulsar_groups[key].desactivate_all()
	_pulsar_groups_status[type] = PulsarGroupStatus.PARTIALLY_ACTIVE
	pulsarManager.activate(pulsar)

func _on_PulsarManager_activated(type : int):
	_nb_active += 1
	_pulsar_groups_status[type] = PulsarGroupStatus.ACTIVE
	if _nb_active == _nb_expected:
		_finish()

func _on_PulsarManager_desactivated(type : int):
	_pulsar_groups_status[type] = PulsarGroupStatus.INACTIVE
	_nb_active -= 1

func _finish():
	mask.visible = false
	for blocker in _blockers:
		blocker.queue_free()
	var finish_mask= get_node("FinishMask")
	if finish_mask != null:
		finish_mask.play()
		yield(finish_mask, "finished")
	emit_signal("finished")
	
func _set_radius(new_radius : float):
	mask.radius = new_radius
	collision_shape.shape.radius = new_radius * PLAYER_RELATIVE_RADIUS
	player.size = Vector2(new_radius, new_radius)
	
