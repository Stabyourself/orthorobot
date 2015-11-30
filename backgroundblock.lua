backgroundblock = class:new()

function backgroundblock:init(x, y, width, height, dir, speed)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dir = dir
	self.speed = speed
	self.r = 0
end

function backgroundblock:update(dt)
	if self.dir == "hor" then
		self.x = self.x + self.speed*dt
		if self.x < -screenwidth-self.width or self.x > screenwidth*2+self.width then
			self.x, self.y, self.width, self.height, self.dir, self.speed = unpack(newBox())
		end
	else
		self.y = self.y + self.speed*dt
		if self.y < -screenheight-self.height or self.y > screenheight*2+self.height then
			self.x, self.y, self.width, self.height, self.dir, self.speed = unpack(newBox())
		end
	end
end

function backgroundblock:draw()
	if self.x+self.width >= -menuoffsetx and self.x < -menuoffsetx+screenwidth and self.y+self.height >= -menuoffset and self.y < -menuoffset+screenheight then
		fillR, fillG, fillB = unpack(fillcolor)
		if self.dir == "hor" then
			fillR = fillR * (1-self.width/100)
			fillG = fillG * (1-self.width/100)
			fillB = fillB * (1-self.width/100)
		else
			fillR = fillR * (1-self.height/100)
			fillG = fillG * (1-self.height/100)
			fillB = fillB * (1-self.height/100)
		end
		drawblock(self.x+menuoffsetx, self.y+menuoffset, self.width, self.height, {fillR, fillG, fillB}, outlinecolor, self.r)
	end
end