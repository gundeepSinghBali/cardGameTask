extends Node2D



var cardScene = load("res://Scenes/Card.tscn")

var IdontKnow : Array 
var Middle : Array
var Iknow : Array

# counters
var IdontKnowCounter : int
var IknowCounter : int 


onready var IdontKnowGridContainer : GridContainer = $"I dont Know"
onready var MiddleGridContainer : GridContainer = $Middle
onready var IknowGridContainer : GridContainer = $"I know"
onready var IdontKnowRichTextLabel : RichTextLabel = $IdontKnow
onready var IKnowRichTextLabel : RichTextLabel = $Iknow

func _physics_process(delta):
	IdontKnowRichTextLabel.text = "I dont't know " + str(IknowCounter)
	IKnowRichTextLabel.text = "I  know " + str(IdontKnowCounter)
	showCards()
func _ready():
	var t_index = 0
	for texture in GlobalScene.textures:
		var t_card_instance = cardScene.instance()
		t_card_instance.connect("transferToRight", self, "on_tranferToRight")
		t_card_instance.connect("transferToLeft", self, "on_transferToLeft")
		t_card_instance.cardID = t_index
		t_card_instance.texture_string = texture
		t_index += 1	
		MiddleGridContainer.add_child(t_card_instance)


func on_tranferToRight(getNodeParent, getSelf):
	
	if getNodeParent == MiddleGridContainer:
		MiddleGridContainer.remove_child(getSelf)
		IknowGridContainer.add_child(getSelf)
		IknowCounter += 1
	elif getNodeParent == IknowGridContainer:
		pass
	elif getNodeParent == IdontKnowGridContainer:
		IdontKnowGridContainer.remove_child(getSelf)
		IdontKnowCounter -= 1
		MiddleGridContainer.add_child(getSelf)
	
func on_transferToLeft(getNodeParent, getSelf):
	if getNodeParent == MiddleGridContainer:
		MiddleGridContainer.remove_child(getSelf)
		IdontKnowGridContainer.add_child(getSelf)
		IdontKnowCounter += 1
	elif getNodeParent == IknowGridContainer:
		IknowGridContainer.remove_child(getSelf)
		MiddleGridContainer.add_child(getSelf)
		IknowCounter -=1
	elif getNodeParent == IdontKnowGridContainer:
		pass


func showCards():
	if MiddleGridContainer.get_child_count() == 0:
		var t_get_children = IknowGridContainer.get_children()
		for card in t_get_children:
			card.revealCard = true
			card.texture = load(card.texture_string)
			



func _on_Save_Button_pressed():
	var save_data = {
		"IdontKnow": [],
		"Middle": [],
		"Iknow": [],
		"IdontKnowCounter":0,
		"IknowCounter":0  
	}
	
	# Store cards in "I don't Know" grid
	for child in IdontKnowGridContainer.get_children():
		save_data["IdontKnow"].append({
			"cardID": child.cardID,
			"backTexture": child.back_texture,
			"texture_string": child.texture_string,
			"revealCard": child.revealCard
		})
	
	# Store cards in "Middle" grid
	for child in MiddleGridContainer.get_children():
		save_data["Middle"].append({
			"cardID": child.cardID,
			"backTexture": child.back_texture,
			"texture_string": child.texture_string,
			"revealCard": child.revealCard
		})
	
	# Store cards in "I know" grid
	for child in IknowGridContainer.get_children():
		save_data["Iknow"].append({
			"cardID": child.cardID,
			"backTexture": child.back_texture,
			"texture_string": child.texture_string,
			"revealCard": child.revealCard
		})
	
	save_data["IdontKnowCounter"] = IdontKnowCounter
	save_data["IknowCounter"] = IknowCounter
	
	var save_file = File.new()
	if save_file.open("user://save_game.sav", File.WRITE) == OK:
		save_file.store_string(to_json(save_data))
		save_file.close()
		print("Game saved.")
	else:
		print("Failed to save game.")


func _on_Load_Button_pressed():
	var save_file = File.new()
	if save_file.file_exists("user://save_game.sav"):
		save_file.open("user://save_game.sav", File.READ)
		var save_data = parse_json(save_file.get_as_text())
		save_file.close()
				
		# Remove all cards from the grids
		for child in IdontKnowGridContainer.get_children():
			child.queue_free()
		for child in MiddleGridContainer.get_children():
			child.queue_free()
		for child in IknowGridContainer.get_children():
			child.queue_free()
			
		IdontKnowCounter = save_data["IdontKnowCounter"]
		IknowCounter = save_data["IknowCounter"]
		# Load cards in "I don't Know" grid
		if "IdontKnow" in save_data:
			for card_data in save_data["IdontKnow"]:
				var instance = cardScene.instance()
				instance.connect("transferToRight", self, "on_tranferToRight")
				instance.connect("transferToLeft", self, "on_transferToLeft")
				instance.cardID = card_data["cardID"]
				instance.texture_string = card_data["texture_string"]
				instance.back_texture = card_data["backTexture"]
				instance.revealCard = card_data["revealCard"]
				if instance.revealCard:
					print("revealCardTrue")
					instance.texture = load(instance.texture_string)
				else:
					instance.texture = load(instance.back_texture)
				
				IdontKnowGridContainer.add_child(instance)
		
		# Load cards in "Middle" grid
		if "Middle" in save_data:
			for card_data in save_data["Middle"]:
				
				var instance = cardScene.instance()
				instance.connect("transferToRight", self, "on_tranferToRight")
				instance.connect("transferToLeft", self, "on_transferToLeft")
				instance.cardID = card_data["cardID"]
				instance.texture_string = card_data["texture_string"]
				instance.back_texture = card_data["backTexture"]
				instance.revealCard = card_data["revealCard"]
				if instance.revealCard:
					print("revealCardTrue")
					instance.texture = load(instance.texture_string)
				else:
					instance.texture = load(instance.back_texture)
				MiddleGridContainer.add_child(instance)
		
		# Load cards in "I know" grid
		if "Iknow" in save_data:
			for card_data in save_data["Iknow"]:
				var instance = cardScene.instance()
				instance.connect("transferToRight", self, "on_tranferToRight")
				instance.connect("transferToLeft", self, "on_transferToLeft")
				instance.cardID = card_data["cardID"]
				instance.texture_string = card_data["texture_string"]
				instance.back_texture = card_data["backTexture"]
				instance.revealCard = card_data["revealCard"]
				if instance.revealCard:
					print("revealCardTrue")
					instance.texture = load(instance.texture_string)
				else:
					instance.texture = load(instance.back_texture)
				IknowGridContainer.add_child(instance)
	
	
		
		
