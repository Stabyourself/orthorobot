pausebutton = class:new()

function pausebutton:init(x, y, text, func)
	self.x = x-1
	self.y = y
	self.text = text
	self.func = func
	self.value = 0
	self.textwidth = levelselectfont:getWidth(self.text)
	self.active = false
	
	self.height = 23
	self.width = 218
end

function pausebutton:changetext(t)
	self.text = t
	self.textwidth = levelselectfont:getWidth(self.text)
end

function pausebutton:update(dt)
	local x, y = mymousegetPosition()
	y = y
	x = x
	if self:gethighlight(x, y) then
		self.value = self.value + ((1-self.value)*10*dt+0.01*dt)
		if self.value > 1 then
			self.value = 1
		end
	else
		self.value = self.value - (self.value*4*dt+0.1*dt)
		if self.value < 0 then
			self.value = 0
		end
	end
end

function pausebutton:draw()
	local r, g, b = 190, 206, 248
	local tr, tg, tb = unpack(getrainbowcolor(math.mod(rainbowi+.5+self.value*0.5, 1)))
	
	r = r + (tr-r)*(self.value*.7+.3)
	g = g + (tg-g)*(self.value*.7+.3)
	b = b + (tb-b)*(self.value*.7+.3)
	
	local scissorx, scissory, scissorwidth, scissorheight = mygraphicsgetScissor( )
	
	love.graphics.setFont(levelselectfont)
	mygraphicssetScissor(self.x-self.width/2+self.width/2*self.value, scissory or self.y, round(self.width-self.width*self.value), scissorheight or self.height)
	lg_setColor(r, g, b, 100*fadecolor)
	love.graphics.rectangle("fill", self.x-self.width/2, self.y, self.width, self.height)
	lg_setColor(0, 0, 0, 255*fadecolor)
	if self.text then
		love.graphics.print(self.text, self.x - self.textwidth/2+1, self.y-7)
	end
	mygraphicssetScissor()
	
	lg_setColor(r, g, b, 255*fadecolor)
	
	mygraphicssetScissor(round(self.x-self.width/2), scissory or self.y, round(self.width/2*self.value), scissorheight or self.height)
	if self.text then
		love.graphics.print(self.text, round(self.x - self.textwidth/2+1), self.y-7)
	end
	
	mygraphicssetScissor(round(self.x+self.width/2-(self.width/2*self.value)), scissory or self.y, round(self.width/2), scissorheight or self.height)
	if self.text then
		love.graphics.print(self.text, round(self.x - self.textwidth/2+1), self.y-7)
	end
	
	if scissorx then
		mygraphicssetScissor(scissorx, scissory, scissorwidth, scissorheight)
	else
		mygraphicssetScissor()
	end
end

function pausebutton:mousepressed(x, y, button)
	if self.active then
		if button == lbutton then
			if self:gethighlight(x, y) then
				self:func()
			end
		end
	end
end

function pausebutton:gethighlight(x, y)
	if x >= self.x-self.width/2-1 and x < self.x+self.width/2+2 and
	y >= self.y-1 and y < self.y+self.height+2 then
		return true
	end
	return false
end
