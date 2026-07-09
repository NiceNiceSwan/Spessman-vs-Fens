class_name UserInterface extends CanvasLayer

@onready var pause_menu: PauseMenu = $PauseMenu
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var wave_progress_bar: ProgressBar = $WaveBarHolder/WaveProgressBar
@onready var announcement_holder: VBoxContainer = $AnnouncementHolder
@onready var announcement_label: Label = $AnnouncementHolder/AnnouncementLabel
@onready var poly_rect: TextureRect = $AnnouncementHolder/PolyRect
@onready var announcement_timer: Timer = $AnnouncementHolder/AnnouncementTimer
@onready var game_over_timer: Timer = $GameOverTimer
@onready var win_timer: Timer = $WinTimer
@onready var plants_hbox: HBoxContainer = $PlantsBox
@onready var plant_remover_sprite: AnimatedSprite2D = $PlantRemoverContainer/PlantRemover/PlantRemoverSprite
@onready var plant_remover_container: PanelContainer = $PlantRemoverContainer

signal plant_remover_selected
signal won_timer_expired

func _ready():
	plant_remover_container.set_visible(SaveData.unlocked_plants >= Enums.UNLOCKS.PLANT_REMOVER)
	Signals.money_changed.connect(update_money)
	plant_remover_sprite.play()
	for plant_holder: PlantHolder in plants_hbox.get_children():
		if plant_holder.get_index() <= SaveData.unlocked_plants:
			plant_holder.set_visible(true)
		else:
			plant_holder.set_visible(false)

func update_money(money: int):
	$MoneyBox/VBoxContainer/Money.text = str(money)

func _on_pause_menu_button_pressed():
	if not get_tree().is_paused():
		get_tree().set_pause(true)
		pause_menu.set_visible(true)
		return
	
	get_tree().set_pause(false)
	pause_menu.disable()

func _on_plant_remover_pressed():
	plant_remover_selected.emit()
	plant_remover_sprite.set_animation("ready")
	$PlantRemoverContainer/AudioStreamPlayer.play()

func on_plant_removed():
	plant_remover_sprite.set_animation("default")

func initialize_progress_bar(enemies_amount: int) -> void:
	wave_progress_bar.max_value = enemies_amount

func update_progress_bar(value: int) -> void:
	wave_progress_bar.value = value

func announce_wave() -> void:
	announcement_holder.set_visible(true)
	announcement_label.text = "HUGE WAVE INCOMING!"
	announcement_label.label_settings.font_color = Color(1, 0, 0, 1)
	announcement_holder.modulate = Color(0, 0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(announcement_holder, "modulate", Color(1, 1, 1, 1), 0.3) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func(): announcement_timer.start())

func announce_defeat() -> void:
	announcement_holder.set_visible(true)
	poly_rect.set_visible(true)
	announcement_label.text = "THEY KILLED POLY!"
	announcement_label.label_settings.font_color = Color(1, 0, 0, 1)
	announcement_holder.modulate = Color(0, 0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(announcement_holder, "modulate", Color(1, 1, 1, 1), 0.8) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func(): game_over_timer.start())

func _on_announcement_timer_timeout() -> void:
	announcement_holder.set_visible(false)

func _on_game_over_timer_timeout():
	get_tree().change_scene_to_packed(load("res://Code/UI/MainMenu.tscn"))

func announce_victory() -> void:
	announcement_holder.set_visible(true)
	announcement_label.text = "Victory!"
	announcement_label.label_settings.font_color = Color(0, 1, 0, 1)
	announcement_holder.modulate = Color(0, 0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(announcement_holder, "modulate", Color(1, 1, 1, 1), 0.8) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func(): win_timer.start())

func _on_win_timer_timeout():
	won_timer_expired.emit()
