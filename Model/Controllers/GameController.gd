extends Node2D

var world = null
var worldClass = load("res://Model/world.gd")
var tile = load("res://Model/tile.gd")
var tileNodeObj = load("res://Scenes/TileNode.tscn")
var grndImage = preload("res://Images/Tiles/Floor-0.png")
var gridsize = grndImage.get_size()
var tileDict = {}

func _ready():
	world = worldClass.new(100,100)
	world.name = "world"
	self.add_child(world)
	#create node for each tile
	for x in range(world.GetWidth()):
		for y in range(world.GetHeight()):
			#generate tile node
			var tileNode = tileNodeObj.instance()
			tileNode.name = "Tile_"+str(x)+"_"+str(y)
			tileNode.position = Vector2(x*gridsize[0],y*gridsize[1])
			world.add_child(tileNode)
			
			#sprite component
			var spr = Sprite.new()
			spr.name = "main_sprite"
			tileNode.add_child(spr)
			
			#set image based on type
			var tile_data = world.GetTile(Vector2(x,y))
			tileDict[tile_data] = tileNode
			tile_data.connect("typeUpdate",self,"OnTileTypeChanged",[tile_data])
			world.Randomize(tile_data)
	
func DestroyTiles():
	#var data
	var object
	var keys = tileDict.keys()
	while !tileDict.empty():
		var i = keys.pop_front()
		#data = i
		print("fuck")
		object = tileDict[i]
		tileDict.erase(i)
		object.queue_free()

func OnTileTypeChanged(tile_data):
	if !tileDict.has(tile_data):
		print("Tile does not exist")
	var tn = tileDict[tile_data]
	if tile_data.type == tile.TileType.empty:
		tn.get_node("main_sprite").set_texture(null)
	elif tile_data.type == tile.TileType.ground:
		tn.get_node("main_sprite").set_texture(grndImage)