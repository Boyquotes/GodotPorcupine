extends Node2D

var x = null
var y = null
var pool = null

func SetCoords(coords):
	self.x = coords.x
	self.y = coords.y
	self.position = coords * 32