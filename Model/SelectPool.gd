extends Node

class PoolMember:
	var myPool

class Pool extends Node:
	var nextID = 1
	var inactive = []
	var prefab

	func _init(prefab):
			self.prefab = prefab;
	
	func spawn(coords):
		var obj
		if inactive.empty():
			obj = self.prefab.instance()
			obj.name = str(prefab) + "_" + str(nextID)
			nextID = nextID + 1
			var p = PoolMember.new()
			p.myPool = self
			obj.pool = p
			self.add_child(obj)
		else:
			obj = inactive.pop_back()
			if obj == null: 
				return spawn(coords)
		obj.SetCoords(coords)
		obj.visible = true
		return obj;

	func Despawn(obj):
		obj.visible = false
		inactive.append(obj);

var pools = {}

func init(prefab=null):
	if !pools.has(prefab):
		var p = Pool.new(prefab)
		self.add_child(p)
		pools[prefab] = p

func Preload(prefab, qty):
	init(prefab)
	var obs = []
	for i in range(qty):
		obs[i] = Spawn(prefab, Vector2(0,0))

	for i in range(qty):
		Despawn(obs[i])

func Spawn(prefab, coords):
	init(prefab);
	return pools[prefab].spawn(coords)

func Despawn(obj):
	var pm = obj.pool
	if(pm == null):
		print("Object '"+obj.name+"' wasn't spawned from a pool.")
	else:
		pm.myPool.Despawn(obj)