extends Node

## Emitted when money is added or subtracted. Basically, when 
## the UI needs to update
signal money_changed(new_value: int)
signal plant_selected(plant: PlantData, plant_scene: PackedScene)
