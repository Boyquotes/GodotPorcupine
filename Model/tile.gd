extends Node

enum TileType {empty, ground}
var type = TileType.empty
var looseobj
var instobj
var world
var x
var y
var selected
signal typeUpdate(type)

func _init(world,x,y):
	self.world = world
	self.x = x
	self.y = y
	
func SetTileType(type):
	self.type = type
	self.emit_signal("typeUpdate")