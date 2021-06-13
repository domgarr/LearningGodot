extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var bar = $TextureProgress

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if bar != null:
		bar.value = value
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	bar.value = hearts
	bar.max_value = max_hearts
	PlayerStats.connect("health_change", self, "set_hearts")
