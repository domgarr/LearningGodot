extends Resource
class_name Inventory

signal items_changed(indexes)

export(Array, Resource) var items = [
	null,null,null,null,null,null,null,null,null
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previousItem
	
func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])

func merge_items(item_index, target_item_index):
	var targetItem : Item = items[target_item_index]
	var item : Item = items[item_index]
	targetItem.amount += item.amount
	emit_signal("items_changed", [item_index, target_item_index])
	
func is_equal(item_index, target_item_index):
	var targetItem : Item = items[target_item_index]
	var item : Item = items[item_index]
	return targetItem.identifier == item.identifier

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem
