levelbutton = class:new()

function levelbutton:init(x, y, text, i, unlocked)
	self.x = x
	self.y = y
	self.text = text
	self.i = i
	self.unlocked = unlocked
	self.value = 0
	self.textwidth = levelselectfont:getWidth(self.text)
	self.coinwidth = coinsfont:getWidth(#filetable[self.i].collectedcoins .. "/" .. filetable[self.i].coins)
	self.active = true
	self.xt = x
	
	self.xmargin = 20
	self.textyplus = -5
	
	self.height = 80
	self.width = 190
end

function levelbutton:update(dt)
	if self.x < self.xt then
		self.x = self.x + (self.xt-self.x)/3*dt*15+10*dt
		if self.x > self.xt then
			self.x = self.xt
		end
	elseif self.x > self.xt then
		self.x = self.x - (self.x-self.xt)/3*dt*15-10*dt
		if self.x < self.xt then
			self.x = self.xt
		end
	end
	
	if self.unlocked then
		local x, y = love.mouse.getPosition()
		y = y - menuoffset
		x = x - menuoffsetx
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
end

function levelbutton:draw()
	if self.x < -self.width/2-32 or self.x > screenwidth+self.width/2 then
		return
	end

	if self.unlocked then
		if 	(not filetable[self.i].goaltime or (filetable[self.i].hightime and filetable[self.i].hightime <= filetable[self.i].goaltime)) and
		(not filetable[self.i].goalsteps or (filetable[self.i].highsteps and filetable[self.i].highsteps <= filetable[self.i].goalsteps)) and
		(not filetable[self.i].goalwarps or (filetable[self.i].highwarps and filetable[self.i].highwarps <= filetable[self.i].goalwarps)) and
		(#filetable[self.i].collectedcoins >= filetable[self.i].coins) then
			love.graphics.setColor(255, 255, 255, 150*fadecolor)
			love.graphics.draw(yayimg, self.x-self.width/2+.5, self.y+1)
		end
		
		local r, g, b = 190, 206, 248
		local tr, tg, tb = unpack(getrainbowcolor(math.mod(rainbowi+.5+self.value*0.5, 1)))
		
		r = r + (tr-r)*(self.value*.7+.3)
		g = g + (tg-g)*(self.value*.7+.3)
		b = b + (tb-b)*(self.value*.7+.3)
		
		love.graphics.setColor(r, g, b, 200*fadecolor)
		love.graphics.rectangle("fill", self.x-self.width/2, self.y+self.height-(self.height-30)*self.value, self.width, (self.height-30)*self.value)
		
		love.graphics.setFont(levelselectfont)
		love.graphics.setScissor(self.x-self.width/2+menuoffsetx+self.width/2*self.value, self.y+menuoffset, round(self.width-self.width*self.value), self.height*0.6)
		love.graphics.setColor(r, g, b, 100*fadecolor)
		love.graphics.rectangle("fill", self.x-self.width/2, self.y, self.width, 30)
		love.graphics.setColor(0, 0, 0, 255*fadecolor)
		if self.text then
			love.graphics.print(self.text, self.x - self.textwidth/2+6, self.y-2)
		end
		love.graphics.setScissor()
		
		love.graphics.setColor(r, g, b, 255*fadecolor)
		
		love.graphics.setScissor(round(self.x-self.width/2+menuoffsetx), self.y+menuoffset, round(self.width/2*self.value), self.height*0.6)
		if self.text then
			love.graphics.print(self.text, round(self.x - self.textwidth/2+6), self.y-2)
		end
		
		love.graphics.setScissor(round(self.x+menuoffsetx+self.width/2-(self.width/2*self.value)), self.y+menuoffset, round(self.width/2), self.height*0.6)
		if self.text then
			love.graphics.print(self.text, round(self.x - self.textwidth/2+6), self.y-2)
		end
		
		love.graphics.setScissor()
		
		
		love.graphics.setFont(winwindowfont)
		
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		love.graphics.draw(clockimg, self.x-self.width/2+6, self.y+34, 0, 2, 2)
		love.graphics.draw(stepsimg, self.x-self.width/2+70, self.y+34, 0, 2, 2)
		love.graphics.draw(warpsimg, self.x-self.width/2+134, self.y+34, 0, 2, 2)
		
		if not filetable[self.i].hightime then
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
		elseif (not filetable[self.i].goaltime and filetable[self.i].hightime) or  filetable[self.i].hightime <= filetable[self.i].goaltime then
			love.graphics.setColor(0, 255, 0, 255*fadecolor)
		else
			love.graphics.setColor(255, 0, 0, 255*fadecolor)
		end
		love.graphics.print(filetable[self.i].hightime or "-", self.x-self.width/2+30, self.y+50)
		
		if not filetable[self.i].highsteps then
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
		elseif (not filetable[self.i].goalsteps and filetable[self.i].highsteps) or filetable[self.i].highsteps <= filetable[self.i].goalsteps then
			love.graphics.setColor(0, 255, 0, 255*fadecolor)
		else
			love.graphics.setColor(255, 0, 0, 255*fadecolor)
		end
		love.graphics.print(filetable[self.i].highsteps or "-", self.x-self.width/2+94, self.y+50)
		
		if not filetable[self.i].highwarps then
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
		elseif (not filetable[self.i].goalwarps and filetable[self.i].highwarps) or filetable[self.i].highwarps <= filetable[self.i].goalwarps then
			love.graphics.setColor(0, 255, 0, 255*fadecolor)
		else
			love.graphics.setColor(255, 0, 0, 255*fadecolor)
		end
		love.graphics.print(filetable[self.i].highwarps or "-", self.x-self.width/2+158, self.y+50)
		
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		love.graphics.print(filetable[self.i].goaltime or "-", self.x-self.width/2+30, self.y+30)
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		love.graphics.print(filetable[self.i].goalsteps or "-", self.x-self.width/2+94, self.y+30)
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		love.graphics.print(filetable[self.i].goalwarps or "-", self.x-self.width/2+158, self.y+30)
		
		love.graphics.setColor(100+self.value*150, 100+self.value*150, 100+self.value*150, 200*fadecolor)
		love.graphics.draw(coinsbackimg, self.x+self.width/2, self.y)
		love.graphics.setColor(255, 255, 255, 255*fadecolor)
		
		if #filetable[self.i].collectedcoins >= filetable[self.i].coins then
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
		else
			love.graphics.setColor(50, 50, 50, 255*fadecolor)
		end
		
		love.graphics.draw(coinimg, self.x+self.width/2-14, self.y-2+creditsr*30, 0, 3, 3)
		
		if #filetable[self.i].collectedcoins >= filetable[self.i].coins then
			love.graphics.setColor(0, 255, 0, 255*fadecolor)
		else
			love.graphics.setColor(255, 0, 0, 255*fadecolor)
		end
		
		love.graphics.setFont(coinsfont)
		love.graphics.print(#filetable[self.i].collectedcoins .. "/" .. filetable[self.i].coins, self.x+self.width/2+17-self.coinwidth/2, self.y+50)
		
		local r, g, b = unpack(getrainbowcolor(math.mod(rainbowi+0.5+self.value*0.5, 1)))
		love.graphics.setColor(r, g, b, 255*fadecolor)
		love.graphics.rectangle("line", round(self.x-self.width/2), round(self.y), self.width+2, self.height+2)
	else		
		local r, g, b = 200, 200, 200
		
		love.graphics.setFont(levelselectfont)
		love.graphics.setColor(r, g, b, 100*fadecolor)
		love.graphics.rectangle("fill", self.x-self.width/2, self.y, self.width, 30)
		love.graphics.setColor(0, 0, 0, 255*fadecolor)
		if self.text then
			love.graphics.print(self.text, self.x - self.textwidth/2+6, self.y-2)
		end
		
		love.graphics.setColor(100, 100, 100, 100*fadecolor)
		love.graphics.draw(coinsbackimg, self.x+self.width/2, self.y)
		
		love.graphics.setColor(r, g, b, 100*fadecolor)
		love.graphics.rectangle("line", round(self.x-self.width/2), round(self.y), self.width+2, self.height+2)
	end
end

function levelbutton:mousepressed(x, y, button)
	if self.unlocked and self.active and button == "l" then
		if self:gethighlight(x, y) then
			for i, v in pairs(levelbuttons) do
				v.active = false
			end
			menubuttons[5].active = false
			startlevel(self.i)
			return true
		end
	end
end

function levelbutton:gethighlight(x, y)
	if x >= self.x-self.width/2-1 and x < self.x+self.width/2+2+30 and
	y >= self.y-1 and y < self.y+self.height+2 then
		return true
	end
	return false
end