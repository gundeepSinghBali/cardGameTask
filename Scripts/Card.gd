extends TextureRect

# signals 
signal transferToRight(getParent, getSelf)
signal transferToLeft(getParent, getSelf)
# import
onready var timer =  $Timer
onready var animationPlayer = $AnimationPlayer


var back_texture = "res://Playing Cards/card-back1.png"
var texture_string : String
var cardID : int 
var get_direction : Vector2

var inputTouchPosition : Array 
var revealCard : bool = false

func _ready():
	if revealCard == false:
		self.texture = load(back_texture)
	
func _physics_process(delta):
	pass



func _on_Card_gui_input(event):
	if event is InputEventScreenDrag:
		inputTouchPosition.append(event.position)
	if event is InputEventScreenTouch:
		if !event.is_pressed():
			
			if inputTouchPosition.size() > 2:
				get_direction = inputTouchPosition[inputTouchPosition.size() - 1] - inputTouchPosition[0]
				get_direction = get_direction.normalized()
				
				if get_direction.x > 0:
					
					emit_signal("transferToRight", self.get_parent(), self)
						
					print("swipe_right")
				elif get_direction.x < 0:
					
					emit_signal("transferToLeft", self.get_parent(), self)
					print("swipe_left")
				
				
			inputTouchPosition.clear()
	
		
