extends Node

## Emitted when money is added or subtracted. Basically, when 
## the UI needs to update
signal money_changed(new_value: int)
signal plant_selected(plant: PlantData, plant_scene: PackedScene, plant_slot: int)
signal plant_placed(plant_slot: int)
## Used to apply the freeze status effect onto all enemies
signal global_freeze()
