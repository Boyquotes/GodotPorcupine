extends Node2D

const GRID_SIZE = 32
#camera
onready var cam = get_node("Camera2D")
var camDragState = false
export var zoomspeed = 10.0
var zoomfactor = 1.0
export var maxzoom = 3.0
export var minzoom = 0.25
#general
onready var CurrentMouseCoords = cam.get_viewport().get_mouse_position()
onready var LastMouseCoords = CurrentMouseCoords
var curr = get_global_mouse_position()
var selObj = load("res://Scenes/UI/SelectCircle.tscn")
#tiles
var world = null
var dragStartPos = Vector2(0,0)
var tileDragState = false
var startx 
var starty
var endx
var endy
var selArr = []
var activetype = 0

onready var build = self.get_node("Camera2D/UI/CanvasLayer/Buttons/Build Floor")
onready var bull = self.get_node("Camera2D/UI/CanvasLayer/Buttons/Bulldoze")

func _ready():
	build.connect("pressed", self, "BuildFloor")
	bull.connect("pressed", self, "Bulldoze")

func _physics_process(delta):
	if world == null:
		var children = self.get_parent().get_children()
		for i in children:
			if i.name == "world":
				world = i
	while !selArr.empty():
		var obj = selArr.pop_front()
		SelectPool.Despawn(obj)
	LastMouseCoords = CurrentMouseCoords
	CurrentMouseCoords = cam.get_viewport().get_mouse_position()
	if camDragState:
		var diff = (LastMouseCoords - CurrentMouseCoords)#.normalized()
		cam.position += diff*cam.zoom
	if tileDragState:
		DragUpdate()
	cam.zoom.x = lerp(cam.zoom.x, cam.zoom.x * zoomfactor, zoomspeed * delta)
	cam.zoom.y = lerp(cam.zoom.y, cam.zoom.y * zoomfactor, zoomspeed * delta)
	cam.zoom.x = clamp(cam.zoom.x, minzoom, maxzoom)
	cam.zoom.y = clamp(cam.zoom.y, minzoom, maxzoom)
	zoomfactor = 1.0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if not camDragState:
			camDragState = true
		else:
			camDragState = false
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		dragStartPos = get_global_mouse_position()
		tileDragState = true
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.is_pressed():
		curr = get_global_mouse_position()
		tileDragState = false
		startx = floor((dragStartPos.x+16)/GRID_SIZE)
		starty = floor((dragStartPos.y+16)/GRID_SIZE)
		endx = floor((curr.x+16)/GRID_SIZE)
		endy = floor((curr.y+16)/GRID_SIZE)
		if startx > endx:
			var tmp = startx
			startx = endx
			endx = tmp
		if starty > endy:
			var tmp = starty
			starty = endy
			endy = tmp
		for i in range(startx, endx+1):
			for j in range(starty, endy+1):
				var t = world.GetTile(Vector2(i,j))
				if t != null:
					t.SetTileType(activetype)
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP and event.is_pressed():
		zoomfactor -= 1
	elif event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN and event.is_pressed():
		zoomfactor += 1

func BuildFloor():
	activetype = 1
	
func Bulldoze():
	activetype = 0

func DragUpdate():
	curr = get_global_mouse_position()
	startx = floor((dragStartPos.x+16)/GRID_SIZE)
	starty = floor((dragStartPos.y+16)/GRID_SIZE)
	endx = floor((curr.x+16)/GRID_SIZE)
	endy = floor((curr.y+16)/GRID_SIZE)
	if startx > endx:
		var tmp = startx
		startx = endx
		endx = tmp
	if starty > endy:
		var tmp = starty
		starty = endy
		endy = tmp
	for i in range(startx, endx+1):
		for j in range(starty, endy+1):
			var selInt = SelectPool.Spawn(selObj, Vector2(i,j))
			selArr.append(selInt)