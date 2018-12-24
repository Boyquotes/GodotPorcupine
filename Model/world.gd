extends Node

var tile = load("res://Model/tile.gd") #tile class
var Tiles = []
var width
var height

func _init(width=10, height=10):
	self.height = height
	self.width = width
	#Initialize 2D array
	for i in range(width):
		Tiles.append([])
		Tiles[i].resize(height)
		for j in range(height):
			Tiles[i][j]=tile.new(self,i,j)

func Randomize(tiledat):
	var k = randi()%2
	if k == 0:
		tiledat.SetTileType(tile.TileType.empty)
	if k == 1:
		tiledat.SetTileType(tile.TileType.ground)

func GetTile(coords):
	var x = floor(coords.x)
	var y = floor(coords.y)
	if x >= self.width or x < 0 or y >= self.height or y < 0:
		return null
	return Tiles[x][y]
func GetWidth():
	return self.width
func GetHeight():
	return self.height