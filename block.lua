block = class:new()

function block:init(x, y, z, i)
	self.x = x
	self.y = y
	self.z = z
	self.tilenum = i
	--                    1     2     3     4    top
	self.facevisible = {true, true, true, true, true}
	
	self.facecolor = {}
	self.facecolor[1] = {255, 0, 0}
	self.facecolor[2] = {0, 255, 0}
	self.facecolor[3] = {0, 0, 255}
	self.facecolor[4] = {255, 255, 0}
	self.facecolor[5] = {255, 255, 255}
	
	
	self.gridcolor = {}
	self.gridcolor[1] = {100, 100, 100}
	self.gridcolor[2] = {150, 150, 150}
end

function block:updatevisiblefaces()
	--side1
	if self.z == mapdepth then
		self.facevisible[1] = true
	elseif map[self.x][self.y][self.z+1].tilenum ~= 1 then
		self.facevisible[1] = false
	else
		self.facevisible[1] = true
	end
	
	--side2
	if self.x == mapwidth then
		self.facevisible[2] = true
	elseif map[self.x+1][self.y][self.z].tilenum ~= 1 then
		self.facevisible[2] = false
	else
		self.facevisible[2] = true
	end
	
	--side3
	if self.z == 1 then
		self.facevisible[3] = true
	elseif map[self.x][self.y][self.z-1].tilenum ~= 1 then
		self.facevisible[3] = false
	else
		self.facevisible[3] = true
	end
	
	--side4
	if self.x == 1 then
		self.facevisible[4] = true
	elseif map[self.x-1][self.y][self.z].tilenum ~= 1 then
		self.facevisible[4] = false
	else
		self.facevisible[4] = true
	end
	
	--top
	if self.y == mapheight then
		self.facevisible[5] = true
	elseif map[self.x][self.y+1][self.z].tilenum ~= 1 then
		self.facevisible[5] = false
	else
		self.facevisible[5] = true
	end
end

----------------------------------

menublock = class:new()

function menublock:init(x, y, z, i)
	self.x = x
	self.y = y
	self.z = z
	self.tilenum = i
	--                    1     2     3     4    top
	self.facevisible = {true, true, true, true, true}
	
	self.facecolor = {}
	self.facecolor[1] = {255, 0, 0}
	self.facecolor[2] = {0, 255, 0}
	self.facecolor[3] = {0, 0, 255}
	self.facecolor[4] = {255, 255, 0}
	self.facecolor[5] = {255, 255, 255}
	
	
	self.gridcolor = {}
	self.gridcolor[1] = {100, 100, 100}
	self.gridcolor[2] = {150, 150, 150}
end

function menublock:updatevisiblefaces()
	--side1
	if self.z == menumapdepth then
		self.facevisible[1] = true
	elseif menumap[self.x][self.y][self.z+1].tilenum ~= 1 then
		self.facevisible[1] = false
	else
		self.facevisible[1] = true
	end
	
	--side2
	if self.x == menumapwidth then
		self.facevisible[2] = true
	elseif menumap[self.x+1][self.y][self.z].tilenum ~= 1 then
		self.facevisible[2] = false
	else
		self.facevisible[2] = true
	end
	
	--side3
	if self.z == 1 then
		self.facevisible[3] = true
	elseif menumap[self.x][self.y][self.z-1].tilenum ~= 1 then
		self.facevisible[3] = false
	else
		self.facevisible[3] = true
	end
	
	--side4
	if self.x == 1 then
		self.facevisible[4] = true
	elseif menumap[self.x-1][self.y][self.z].tilenum ~= 1 then
		self.facevisible[4] = false
	else
		self.facevisible[4] = true
	end
	
	--top
	if self.y == menumapheight then
		self.facevisible[5] = true
	elseif menumap[self.x][self.y+1][self.z].tilenum ~= 1 then
		self.facevisible[5] = false
	else
		self.facevisible[5] = true
	end
end