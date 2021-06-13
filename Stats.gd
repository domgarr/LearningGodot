extends Node

export var max_health = 3
onready var health = max_health setget set_health

signal no_health
signal health_change(value)

func set_health(value):
	health = value
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("no_health")
