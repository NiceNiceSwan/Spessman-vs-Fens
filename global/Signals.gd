extends Node

## Emitted when money is added or subtracted. Basically, when 
## the UI needs to update.[br]
## [b]Params:[/b][br]
## [param new_value] - the new value of the money counter. Basically, how much 
## money it has now.[br][br]
signal money_changed(new_value: int)
## Emitted when money is added or subtracted.
## This should be emitted when you want to modify the money amount, 
## not after it was changed.[br]
## [b]Params:[/b][br]
## [param money] - Amount of cash to add or subtract.[br][br]
signal add_money(money: int)
signal plant_selected(plant: PlantData, plant_scene: PackedScene, plant_slot: int)
signal plant_placed(plant_slot: int)
## Used to apply the freeze status effect onto all enemies
signal global_freeze()
