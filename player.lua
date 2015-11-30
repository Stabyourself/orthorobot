player = class:new()

function player:init(x, y, z)
	self.x = x
	self.y = y
	self.z = z
	
	self.drawx = x
	self.drawy = y
	self.drawz = z
end

function player:update(dt)
	--smooth movement
	self.drawx = smoothmovement(self.drawx, self.x, dt)
	self.drawy = self.y --no smoothing because you never really see it anyway..
	self.drawz = smoothmovement(self.drawz, self.z, dt)
end

function smoothmovement(i, t, dt)
	if i < t then
		local d = t-i
		i = i + d/3*dt*20+3*dt
		if i > t then
			i = t
		end
	elseif i > t then
		local d = i-t
		i = i - d/3*dt*20-3*dt
		if i < t then
			i = t
		end
	end
	
	return i
end

function player:keypressed(key)
	if won == true or not controlsenabled or gamepaused then
		return
	end
	
	if key == "w" then
		key = "up"
	elseif key == "a" then
		key = "left"
	elseif key == "s" then
		key = "down"
	elseif key == "d" then
		key = "right"
	end
	
	local didmove = false
	--movement
	if perspective == "front" then
		if key == "right" then
			if self.x < mapwidth and map2d[self.x+1][self.y] ~= 1 and (self.y == mapheight or map2d[self.x+1][self.y+1] == 1) then
				self.x = self.x + 1
				didmove = true
			end
		elseif key == "left" then
			if self.x > 1 and map2d[self.x-1][self.y] ~= 1 and (self.y == mapheight or map2d[self.x-1][self.y+1] == 1) then
				self.x = self.x - 1
				didmove = true
			end
		end
	elseif perspective == "back" then
		if key == "right" then
			if self.x > 1 and map2d[(mapwidth-self.x+1)+1][self.y] ~= 1 and (self.y == mapheight or map2d[(mapwidth-self.x+1)+1][self.y+1] == 1) then
				self.x = self.x - 1
				didmove = true
			end
		elseif key == "left" then
			if self.x < mapwidth and map2d[(mapwidth-self.x+1)-1][self.y] ~= 1 and (self.y == mapheight or map2d[(mapwidth-self.x+1)-1][self.y+1] == 1) then
				self.x = self.x + 1
				didmove = true
			end
		end
	elseif perspective == "left" then
		if key == "right" then
			if self.z > 1 and map2d[(mapdepth-self.z+1)+1][self.y] ~= 1 and (self.y == mapheight or map2d[(mapdepth-self.z+1)+1][self.y+1] == 1) then
				self.z = self.z - 1
				didmove = true
			end
		elseif key == "left" then
			if self.z < mapdepth and map2d[(mapdepth-self.z+1)-1][self.y] ~= 1 and (self.y == mapheight or map2d[(mapdepth-self.z+1)-1][self.y+1] == 1) then
				self.z = self.z + 1
				didmove = true
			end
		end
	elseif perspective == "right" then
		if key == "right" then
			if self.z < mapdepth and map2d[self.z+1][self.y] ~= 1 and (self.y == mapheight or map2d[self.z+1][self.y+1] == 1) then
				self.z = self.z + 1
				didmove = true
			end
		elseif key == "left" then
			if self.z > 1 and map2d[self.z-1][self.y] ~= 1 and (self.y == mapheight or map2d[self.z-1][self.y+1] == 1) then
				self.z = self.z - 1
				didmove = true
			end
		end
	else
		--modify key to reflect rotation change
		local rot = rotation + pi025
		if rot <= pi075 and rot > pi025 then --move 1 right
			if key == "up" then
				key = "right"
			elseif key == "right" then
				key = "down"
			elseif key == "down" then
				key = "left"
			elseif key == "left" then
				key = "up"
			end
		elseif rot <= pi025 or rot > pi175 then --move 2 right
			if key == "up" then
				key = "down"
			elseif key == "right" then
				key = "left"
			elseif key == "down" then
				key = "up"
			elseif key == "left" then
				key = "right"
			end
		elseif rot <= pi175 and rot > pi125 then --move 3 right
			if key == "up" then
				key = "left"
			elseif key == "right" then
				key = "up"
			elseif key == "down" then
				key = "right"
			elseif key == "left" then
				key = "down"
			end
		end
		
		if perspective == "none" then
			if key == "up" then
				if self.x < mapwidth and map[self.x+1][self.y][self.z].tilenum ~= 1 and (self.y == mapheight or map[self.x+1][self.y+1][self.z].tilenum == 1) then
					self.x = self.x + 1
					didmove = true
				end
			elseif key == "down" then
				if self.x > 1 and map[self.x-1][self.y][self.z].tilenum ~= 1 and (self.y == mapheight or map[self.x-1][self.y+1][self.z].tilenum == 1) then
					self.x = self.x - 1
					didmove = true
				end
			elseif key == "left" then
				if self.z < mapdepth and map[self.x][self.y][self.z+1].tilenum ~= 1 and (self.y == mapheight or map[self.x][self.y+1][self.z+1].tilenum == 1) then
					self.z = self.z + 1
					didmove = true
				end
			elseif key == "right" then
				if self.z > 1 and map[self.x][self.y][self.z-1].tilenum ~= 1 and (self.y == mapheight or map[self.x][self.y+1][self.z-1].tilenum == 1) then
					self.z = self.z - 1
					didmove = true
				end
			end
		elseif perspective == "up" then
			local moved = false
			if key == "up" then
				if self.x < mapwidth and map2d[self.x+1][self.z] ~= 3 and map2d[self.x+1][self.z] ~= 1 then
					self.x = self.x + 1
					moved = true
					didmove = true
				end
			elseif key == "down" then
				if self.x > 1 and map2d[self.x-1][self.z] ~= 3 and map2d[self.x-1][self.z] ~= 1 then
					self.x = self.x - 1
					moved = true
					didmove = true
				end
			elseif key == "left" then
				if self.z < mapdepth and map2d[self.x][self.z+1] ~= 3 and map2d[self.x][self.z+1] ~= 1 then
					self.z = self.z + 1
					moved = true
					didmove = true
				end
			elseif key == "right" then
				if self.z > 1 and map2d[self.x][self.z-1] ~= 3 and map2d[self.x][self.z-1] ~= 1 then
					self.z = self.z - 1
					moved = true
					didmove = true
				end
			end
			
			if moved then
				self.y = mapheight			
				while map[self.x][self.y][self.z].tilenum == 1 do
					self.y = self.y - 1
				end
			end
		end
	end
	
	if didmove then
		scoresteps = scoresteps + 1
	end
	
	checkstuff()
end