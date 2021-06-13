extends CenterContainer

onready var itemTextureRect = $TextureRect
onready var amountLabel = $TextureRect/AmountLabel
var emptyInventory = preload("res://Items/EmptyInventorySlot.png")
var inventory = preload("res://Items/Inventory.tres")
var currentItemDragged : Item

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		amountLabel.text = str(item.amount)
	else:
		itemTextureRect.texture = emptyInventory
		amountLabel.text = ""

#underscore to prevent warning
func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	currentItemDragged = item
	
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index

		var control = Control.new()	
		
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		control.add_child(dragPreview)
		dragPreview.rect_position = -0.5 * Vector2(34,34)
		
		print("=======")
		print(dragPreview.rect_position)
		print(control.rect_position)
		set_drag_preview(control)
		return data
		
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if inventory.is_equal(my_item_index, data.item_index):
		inventory.merge_items(my_item_index, data.item_index)
	else:
		inventory.swap_items(my_item_index, data.item_index)
	inventory.set_item(my_item_index, data.item)
	currentItemDragged = null
