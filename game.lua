function game_load(i)
	currentmap = i
	gamestate = "game"
	if loadmap(filetable[i].path) == false then
		gamestate = "error"
	end
	
	controlsenabled = false
	gamepaused = false
	
	newstar = false
	
	fadetimer = 0
	fadetimert = 1
	fadetimer2 = 0
	fadetimer2t = 0
	fadetimer3 = 0
	fadetimer3t = 0
	fadetimer4 = 0
	fadetimer4t = 0
	
	fadecolor = 0
	
	fadegoal = "in"
	
	coinglowtimer = 0
	coinglowtimert = 0
	coinglowa = 0
	
	if filetable[i].text then
		texttimer = 0
		texttime = string.len(filetable[i].text)/30
	end
	
	pausemenutimer = 0
	pausemenutimert = 0
	
	menumusic:stop()
	
	musicvolume = 0
	gamemusic:setVolume(musicvolume)
	
	wantedbackground = {0, 0, 0}
	
	collectedcoins = {}
	
	camY = - mapheight*20
	camX = 10
	
	--get boxwidth
	boxwidth = (screenheight+screenwidth)/2/(math.sqrt(mapwidth^2+mapdepth^2)*(1/math.sqrt(2)))
	
	playerscale = math.ceil(boxwidth/50)
	
	drawcenterX = screenwidth/2
	drawcenterY = screenheight/2
	
	rotation = 1.1*pi2--math.pi
	pitch = 0.5
	
	won = false
	
	calculatevars()
	
	pl = player:new(unpack(start))
	
	perspective = "none"
	--updateperspective("none")
	
	scoretime = 0
	scoresteps = 0
	scorewarps = 0
	
	pausebuttons = {}
	pausebuttons["next"] = pausebutton:new(screenwidth/2, screenheight/2+118, "Next Level", completed_next)
	pausebuttons["retry"] = pausebutton:new(screenwidth/2, screenheight/2+145, "Improve", completed_retry)
	pausebuttons["return"] = pausebutton:new(screenwidth/2, screenheight/2+172, "Back to Menu", completed_return)
	
	pausebuttons["back"] = pausebutton:new(screenwidth/2, screenheight/2-24, "Back to Game", pause_back)
	pausebuttons["restart"] = pausebutton:new(screenwidth/2, screenheight/2+3, "Restart Level", pause_restart)
	if soundenabled then
		pausebuttons["togglesound"] = pausebutton:new(screenwidth/2, screenheight/2+30, "Sound ON", pause_togglesound)
	else
		pausebuttons["togglesound"] = pausebutton:new(screenwidth/2, screenheight/2+30, "Sound OFF", pause_togglesound)
	end
	pausebuttons["tomenu"] = pausebutton:new(screenwidth/2, screenheight/2+57, "Back to Menu", pause_tomenu)
	pausebuttons["back"].width = 258
	pausebuttons["restart"].width = 258
	pausebuttons["togglesound"].width = 258
	pausebuttons["tomenu"].width = 258
	
	skipupdate = true
	playsound(gamemusic)
end

function game_update(dt)
	--LOTSA TIMERS
	if fadetimer >= 0.5 and fadetimer3 ~= 1.5 and rotation ~= math.pi*1.1 then
		local speed = math.abs(math.pi*1.1-rotation)*1.95+0.02
		
		rotation = rotation - speed*dt
		if rotation < math.pi*1.1 then
			rotation = math.pi*1.1
		end
		
		if rotation < 0 then
			rotation = rotation + pi2
		end
		calculatevars()
	end
	
	if fadetimer ~= fadetimert then
		if fadetimert > fadetimer then
			fadetimer = fadetimer + dt
			if fadetimer >= fadetimert then
				fadetimer = fadetimert
				fadecolor = fadetimer
				gamemusic:setVolume(1)
				if fadegoal == "in" then
					fadetimer2t = 1
					fadetimer2 = fadetimer - fadetimert
				end
			else
				gamemusic:setVolume(fadetimer)
				fadecolor = fadetimer
			end
		else 
			fadetimer = fadetimer - dt
			if fadetimer <= fadetimert then
				fadetimer = fadetimert
				gamemusic:stop()
				if fadegoal == "menu" then
					menu_load(0, 500)
					return
				elseif fadegoal == "retry" then
					game_load(currentmap)
					return
				elseif fadegoal == "next" then
					game_load(currentmap+1)
					return
				elseif fadegoal == "menuwin" then
					menu_load(-screenwidth, 500)
					return
				elseif fadegoal == "menustar" then
					menu_load(screenwidth, 500)
					return
				end
			else
				gamemusic:setVolume(fadetimer)
				fadecolor = fadetimer
			end
		end
	else
		if menuoffsett >= 0 then
			gamemusic:setVolume(gamemusic:getVolume()+dt)
			if gamemusic:getVolume() > 1 then
				gamemusic:setVolume(1)
			end
		end
	end
	
	if fadetimer2 ~= fadetimer2t then
		fadetimer2 = fadetimer2 + dt
		if fadetimer2 >= fadetimer2t then
			fadetimer3t = 1.5
			fadetimer3 = fadetimer2 - fadetimer2t
			fadetimer2 = fadetimer2t
		end
	end
	
	if fadetimer3 ~= fadetimer3t then
		fadetimer3 = fadetimer3 + dt
		if fadetimer3 >= fadetimer3t then
			fadetimer3 = fadetimer3t
			controlsenabled = true
			fadetimer4t = 0.2
			fadetimer4 = fadetimer3 - fadetimer3t
			if rotatedrag then
				rotatedragX, rotatedragY = mymousegetPosition()
			end
		end
	end
	
	if fadetimer4 ~= fadetimer4t then
		fadetimer4 = fadetimer4 + dt
		if fadetimer4 >= fadetimer4t then
			fadetimer4 = fadetimer4t
		end
	end
	
	if controlsenabled and texttimer ~= texttime and not gamepaused then
		texttimer = texttimer + dt
		if texttimer >= texttime then
			texttimer = texttime
		end
	end
	
	if coinglowtimer ~= coinglowtimert then
		if coinglowtimer < coinglowtimert then
			coinglowtimer = coinglowtimer + dt
			if coinglowtimer >= coinglowtimert then
				coinglowtimer = coinglowtimert
				coinglowtimert = 0
			end
		else
			coinglowtimer = coinglowtimer - dt
			if coinglowtimer <= coinglowtimert then
				coinglowtimer = coinglowtimert
			end
		end
	end
	
	--coinglow
	coinglowa = coinglowtimer*2

	if won == true then
		winwindowtimer = winwindowtimer + dt
		if winwindowtimer > 1 then
			winwindowtimer = 1
		end
	elseif fadetimer3 == 1.5 and not gamepaused then
		scoretime = scoretime + dt
	end

	if pausemenutimer ~= pausemenutimert then
		if pausemenutimer < pausemenutimert then
			pausemenutimer = pausemenutimer + dt*2
			if pausemenutimer >= pausemenutimert then
				pausemenutimer = pausemenutimert
			end
		else
			pausemenutimer = pausemenutimer - dt*2
			if pausemenutimer <= pausemenutimert then
				pausemenutimer = pausemenutimert
			end
		end
	end
	
	if movedrag then
		local mousex, mousey = mymousegetPosition()
		local xdist = mousex - movedragX
		local ydist = mousey - movedragY
		
		movedragX = mousex
		movedragY = mousey
		
		--XDIST
		cozdist = math.sin(rotation-pi025)*(xdist/pointsevenboxwidth)
		coxdist = math.sin(rotation+pi025)*(xdist/pointsevenboxwidth)
		
		rotcenterZ = rotcenterZ + cozdist
		rotcenterX = rotcenterX + coxdist
		
		if pitch ~= 0 then
			--YDIST
			cozdist = math.sin(rotation-pi075)*(ydist/pointsevenboxwidth)*(1/pitch)
			coxdist = math.sin(rotation-pi025)*(ydist/pointsevenboxwidth)*(1/pitch)
		
			rotcenterZ = rotcenterZ + cozdist
			rotcenterX = rotcenterX + coxdist
		end
		
		
	elseif rotatedrag and controlsenabled then
		local mousex, mousey = mymousegetPosition()
		local xdist = mousex - rotatedragX
		local ydist = mousey - rotatedragY
		
		rotatedragX = mousex
		rotatedragY = mousey
		
		rotation = rotation - xdist*rotatespeed
		pitch = pitch + ydist*pitchspeed
		
		if rotation < 0 then
			rotation = rotation + pi2
		elseif rotation > pi2 then
			rotation = rotation - pi2
		end
		
		if pitch > maxpitch then
			pitch = maxpitch
		elseif pitch < minpitch then
			pitch = minpitch
		end
		
		calculatevars()
	else
		if smoothtarget then
			local dir = 1
			if rotation > smoothtarget then
				dir = -1
			end
			rotation = smooth(rotation, smoothtarget, dt)
			if dir == 1 then
				if rotation >= smoothtarget then
					rotation = smoothtarget
					smoothtarget = nil
					updateperspective()
				end
			else
				if rotation <= smoothtarget then
					rotation = smoothtarget
					smoothtarget = nil
					updateperspective()
				end
			end
			calculatevars()
		end
		
		if pitchtarget then
			local dir = 1
			if pitchtarget == 0 then
				dir = -1
			end
			pitch = smooth(pitch, pitchtarget, dt)
			if dir == 1 then
				if pitch >= pitchtarget then
					pitch = pitchtarget
					pitchtarget = nil
					updateperspective()
				end
			else
				if pitch <= pitchtarget then
					pitch = pitchtarget
					pitchtarget = nil
					updateperspective()
				end
			end
			calculatevars()
		end			
	end
	
	pl:update(dt)
	
	for i, v in pairs(pausebuttons) do
		v:update(dt)
	end
end

function game_draw()
	local lmap = map
	
	lg_setColor(fillcolor[1], fillcolor[2], fillcolor[3], 255)
	love.graphics.draw(scanlineimg, 0, math.fmod(creditss*3, 5)-5)
	
	if fadetimert == 1 then
		gridfadecolor = fadecolor
		fillfadecolor = fadetimer2
		playerfadecolor = fadecolor
	else
		gridfadecolor = fadecolor
		fillfadecolor = fadecolor
		playerfadecolor = fadecolor
	end
	
	--ISOMETRIC WORLD
	if rotation >= pi125 and rotation < pi175 then
		--DRAW ORDER: X, -Z, Y
		for cox = 1, mapwidth do
			for coz = mapdepth, 1, -1 do
				for coy = 1, mapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz], 1, 1, -1)
				end
			end
		end
	elseif rotation >= pi175 or rotation < pi025 then
		--DRAW ORDER: Z, X, Y
		for coz = 1, mapdepth do
			for cox = 1, mapwidth do
				for coy = 1, mapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz], 1, 1, 1)
				end
			end
		end
	elseif rotation >= pi025 and rotation < pi075 then
		--DRAW ORDER: -X, Z, Y
		for cox = mapwidth, 1, -1 do
			for coz = 1, mapdepth do
				for coy = 1, mapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz], -1, 1, 1)
				end
			end
		end
	elseif rotation >= pi075 and rotation < pi125 then
		--DRAW ORDER: -Z, -X, Y
		for coz = mapdepth, 1, -1 do
			for cox = mapwidth, 1, -1 do
				for coy = 1, mapheight do
					drawtile(cox, coy, coz, lmap[cox][coy][coz], -1, 1, -1)
				end
			end
		end
	end
	
	--always draw player in topdown
	if perspective == "up" then
		local x, y = convertGRDtoSCR(pl.drawx, pl.drawy, pl.drawz)
		lg_setColor(255, 255, 255, 255*fadecolor)
		if won == false then
			love.graphics.draw(playerimg, playerquad[1], round(x), round(y+halfboxwidth*pitch*0.6), 0, playerscale, playerscale, 10, 20)
			lg_setColor(255, 255, 255, 255*coinglowa)
			love.graphics.draw(coinglowimg, round(x), round(y+halfboxwidth*pitch*0.6), 0, playerscale/4, playerscale/4, 29, 89)
		else
			love.graphics.draw(playerimg, playerquad[2], round(x), round(y+halfboxwidth*pitch*0.6), 0, playerscale, playerscale, 10, 20)
			lg_setColor(0, 255, 0, 255*fadecolor)
			love.graphics.rectangle("fill", round(x)-2*playerscale, round(y+halfboxwidth*pitch*0.6)-16*playerscale-winwindowtimer/1*3*playerscale, 4*playerscale, winwindowtimer/1*3*playerscale)
		end
	end
	
	--Level text
	if filetable[currentmap].text then
		alpha = fadecolor
		width = 99 + (625-(1-((fadetimer3)/1.5))^2 * 625)
		mygraphicssetScissor(149, 0, width+1, 101)
		lg_setColor(0, 0, 0, 200*alpha)
		love.graphics.rectangle("fill", 150, 1, width, 100)
		lg_setColor(255, 255, 255, 100*alpha)
		love.graphics.rectangle("fill", 159, 10, 80, 81)
		local r, g, b = unpack(getrainbowcolor(math.fmod(rainbowi+0.5, 1)))
		lg_setColor(r, g, b, 200*alpha)
		love.graphics.rectangle("line", 150, 1, width, 100)
		love.graphics.draw(textavatarimg, 159, 11)
		
		love.graphics.setFont(winwindowfont)
		lg_setColor(190, 206, 248, alpha*255)
		local s = string.sub(filetable[currentmap].text, 1, math.max(0, string.len(filetable[currentmap].text)*(texttimer/texttime)-1))
		if math.fmod(rainbowi, 0.1) > 0.033 then
			s = s .. "_"
		end
		
		love.graphics.printf( s, 260, 10, 604, "left" )
		
		lg_setColor(fillcolor[1], fillcolor[2], fillcolor[3], 255*alpha)
		love.graphics.draw(scanlineimg, 0, math.fmod(creditss*3, 5)-5)
		mygraphicssetScissor()
	end
	
	local r, g, b = unpack(getrainbowcolor(math.fmod(rainbowi+0.5, 1)))
	lg_setColor(r, g, b, 200*fadecolor)
	
	if fadetimer >= 0.5 and fadetimer2 < 0.5 then
		love.graphics.draw(number3img, 436.5, 296-(fadetimer+fadetimer2-1)*2*(screenheight/2+175))
	elseif fadetimer2 >= 0.5 and fadetimer3 < 0.5 then
		love.graphics.draw(number2img, 436.5, 296-(fadetimer2+fadetimer3-1)*2*(screenheight/2+175))
	elseif fadetimer3 >= 0.5 and fadetimer3 < 1.5 then
		love.graphics.draw(number1img, 474, 296-(fadetimer3-1)*2*(screenheight/2+175))
	elseif fadetimer3 == 1.5 and fadetimer4 < 0.1 then
		lg_setColor(r, g, b, 200*fadecolor)
		love.graphics.draw(gosmallimg, 311.5, 296)
	elseif fadetimer4 >= 0.1 and fadetimer4 < 0.2 then
		lg_setColor(r, g, b, 200*fadecolor)
		love.graphics.draw(gobigimg, 111.5, 208.5)
	end
	
	lg_setColor(255, 255, 255, 200*fadecolor)
	love.graphics.setFont(winwindowfont)
	love.graphics.draw(clockimg, 7, 7, 0, 2, 2)
	love.graphics.draw(stepsimg, 7, 32, 0, 2, 2)
	love.graphics.draw(warpsimg, 7, 57, 0, 2, 2)
	love.graphics.printf(round(scoretime, 2), 0, 2, 120, "right")
	love.graphics.printf(scoresteps, 0, 27, 120, "right")
	love.graphics.printf(scorewarps, 0, 52, 120, "right")
	love.graphics.line(0, 28, 111, 28)
	love.graphics.line(0, 53, 111, 53)
	
	if pausemenutimer > 0 then
		local height = (100-(1-((pausemenutimer)/1))^2 * 100)
		mygraphicssetScissor(screenwidth/2-130-1, screenheight/2-height-1, 260+1, height*2+1)
		lg_setColor(0, 0, 0, 200*fadecolor)
		love.graphics.rectangle("fill", screenwidth/2-130, screenheight/2-height, 259, height*2)
		lg_setColor(255, 255, 255, 255*fadecolor)
		
		love.graphics.setFont(winwindowtitlefont, 20)
		love.graphics.print("Game Paused", screenwidth/2-111, screenheight/2-80)
		
		pausebuttons["back"]:draw()
		pausebuttons["restart"]:draw()
		pausebuttons["togglesound"]:draw()
		pausebuttons["tomenu"]:draw()
		
		local r, g, b = unpack(getrainbowcolor(math.fmod(rainbowi+0.5, 1)))
		lg_setColor(r, g, b, 255*fadecolor)
		love.graphics.rectangle("line", screenwidth/2-130, screenheight/2-height, 260, height*2)
		
		mygraphicssetScissor()
	end
	
	if won then
		
		local height = (200-(1-((winwindowtimer)/1))^2 * 200)
		mygraphicssetScissor(0, screenheight/2-height-1, screenwidth, height*2+1)
		
		if newstar then
			lg_setColor(255, 255, 255, 150*fadecolor)
			love.graphics.draw(yaywonimg, screenwidth/2-210, screenheight/2-200)
		end
		
		lg_setColor(0, 0, 0, 200*fadecolor)
		love.graphics.rectangle("fill", screenwidth/2-110, screenheight/2-height, 219, height*2)
		lg_setColor(255, 255, 255, 255*fadecolor)
		
		love.graphics.setFont(winwindowtitlefont, 20)
		love.graphics.print("Level Done!", screenwidth/2-91, screenheight/2-200)
		love.graphics.draw(clockimg, screenwidth/2-92, screenheight/2-159, 0, 2, 2)
		love.graphics.draw(stepsimg, screenwidth/2-92, screenheight/2-59, 0, 2, 2)
		love.graphics.draw(warpsimg, screenwidth/2-92, screenheight/2+41, 0, 2, 2)
		
		love.graphics.print("Time", screenwidth/2-70, screenheight/2-170)
		love.graphics.print("Steps", screenwidth/2-70, screenheight/2-70)
		love.graphics.print("Warps", screenwidth/2-70, screenheight/2+30)
		
		love.graphics.setFont(winwindowfont, 20)
		love.graphics.print("You:", screenwidth/2-70, screenheight/2-145)
		love.graphics.print("You:", screenwidth/2-70, screenheight/2-45)
		love.graphics.print("You:", screenwidth/2-70, screenheight/2+55)
		
		love.graphics.setFont(winwindowfont, 20)
		love.graphics.print("P. Best:", screenwidth/2-70, screenheight/2-128)
		love.graphics.print(besttime or "-", screenwidth/2+30, screenheight/2-128)
		love.graphics.print("P. Best:", screenwidth/2-70, screenheight/2-28)
		love.graphics.print(beststeps or "-", screenwidth/2+30, screenheight/2-28)
		love.graphics.print("P. Best:", screenwidth/2-70, screenheight/2+72)
		love.graphics.print(bestwarps or "-", screenwidth/2+30, screenheight/2+72)
		
		if timebeaten then
			lg_setColor(0, 255, 0, 255*fadecolor)
		else
			lg_setColor(255, 0, 0, 255*fadecolor)
		end
		love.graphics.print(scoretime, screenwidth/2+30, screenheight/2-145)
		
		if stepsbeaten then
			lg_setColor(0, 255, 0, 255*fadecolor)
		else
			lg_setColor(255, 0, 0, 255*fadecolor)
		end
		love.graphics.print(scoresteps, screenwidth/2+30, screenheight/2-45)
		
		if warpsbeaten then
			lg_setColor(0, 255, 0, 255*fadecolor)
		else
			lg_setColor(255, 0, 0, 255*fadecolor)
		end
		love.graphics.print(scorewarps, screenwidth/2+30, screenheight/2+55)
		
		lg_setColor(255, 255, 255, 255*fadecolor)
		love.graphics.print("Goal:", screenwidth/2-70, screenheight/2-111)
		love.graphics.print(goaltime, screenwidth/2+30, screenheight/2-111)
		love.graphics.print("Goal:", screenwidth/2-70, screenheight/2-11)
		love.graphics.print(goalsteps, screenwidth/2+30, screenheight/2-11)
		love.graphics.print("Goal:", screenwidth/2-70, screenheight/2+89)
		love.graphics.print(goalwarps, screenwidth/2+30, screenheight/2+89)
		
		if currentmap ~= #filetable then
			pausebuttons["next"]:draw()
		end
		pausebuttons["retry"]:draw()
		pausebuttons["return"]:draw()
		
		local r, g, b = unpack(getrainbowcolor(math.fmod(rainbowi+0.5, 1)))
		lg_setColor(r, g, b, 255*fadecolor)
		love.graphics.rectangle("line", screenwidth/2-110, screenheight/2-height, 220, height*2)
		
		mygraphicssetScissor()
	end		
end

function updateperspective(persp)
	local previouspersp = perspective
	if persp then
		perspective = persp
	else
		--get what perspective we're even _talking_ about!
		if pitchtarget ~= nil or smoothtarget ~= nil then
			return
		end
		
		perspective = "none"
		
		if pitch == 1 then
			perspective = "up"
		else
			if rotation == pi025 + 0.000001 then
				perspective = "back"
			elseif rotation == pi075 + 0.000001 then
				perspective = "left"
			elseif rotation == pi125 + 0.000001 then
				perspective = "front"
			elseif rotation == pi175 + 0.000001 then
				perspective = "right"
			end
		end
	end
	
	if perspective == "none" then
		if previouspersp ~= "none" then
			if not won then
				wantedbackground = {70, 0, 0}
			end
			if map[pl.x][pl.y][pl.z].tilenum == 1 then --Player is flying lol /noclip
				if previouspersp == "front" or previouspersp == "back" then
					--Player is wrong on the Z axis
					local plusdist, mindist = mapdepth, mapdepth
					for z = pl.z+1, mapdepth do
						if map[pl.x][pl.y][z].tilenum ~= 1 then
							plusdist = z - pl.z
							break
						end
					end
					
					for z = pl.z-1, 1, -1 do
						if map[pl.x][pl.y][z].tilenum ~= 1 then
							mindist = pl.z - z
							break
						end
					end
					
					if plusdist <= mindist then
						pl.z = pl.z+plusdist
					else
						pl.z = pl.z-mindist
					end
					pl.drawz = pl.z
				elseif previouspersp == "left" or previouspersp == "right" then
					--Player is wrong on the X axis
					local plusdist, mindist = mapwidth, mapwidth
					for x = pl.x+1, mapwidth do
						if map[x][pl.y][pl.z].tilenum ~= 1 then
							plusdist = x - pl.x
							break
						end
					end
					
					for x = pl.x-1, 1, -1 do
						if map[x][pl.y][pl.z].tilenum ~= 1 then
							mindist = pl.x - x
							break
						end
					end
					
					if plusdist <= mindist then
						pl.x = pl.x+plusdist
					else
						pl.x = pl.x-mindist
					end
					pl.drawx = pl.x
				end
			end
		end
	else
		scorewarps = scorewarps + 1
		if previouspersp == "none" then
			pl.oldx, pl.oldy, pl.oldz = pl.x, pl.y, pl.z
		end
		
		wantedbackground = {0, 70, 0}
		local playercovered = false
		
		if perspective == "front" then
			map2d = {}
			for x = 1, mapwidth do
				map2d[x] = {}
				for y = 1, mapheight do
					--find closest to screen (lowest Z)
					local lowestz = mapdepth+1
					for z = mapdepth, 1, -1 do
						if map[x][y][z].tilenum ~= 1 then
							lowestz = z
						end
					end
					
					if x == pl.x and y == pl.y+1 then
						if lowestz ~= mapdepth+1 then
							playercovered = true
						end
					end
					
					if lowestz ~= mapdepth+1 then
						map2d[x][y] = map[x][y][lowestz].tilenum
					else
						map2d[x][y] = 1
					end
				end
			end
		elseif perspective == "back" then
			map2d = {}
			for x = 1, mapwidth do
				map2d[x] = {}
				for y = 1, mapheight do
					--find closest to screen (highest Z)
					local highestz = 0
					for z = 1, mapdepth do
						if map[mapwidth-x+1][y][z].tilenum ~= 1 then
							highestz = z
						end
					end
					
					if mapwidth-x+1 == pl.x and y == pl.y+1 then
						if highestz ~= 0 then
							playercovered = true
						end
					end
					
					if highestz ~= 0 then
						map2d[x][y] = map[mapwidth-x+1][y][highestz].tilenum
					else
						map2d[x][y] = 1
					end
				end
			end
		elseif perspective == "left" then
			map2d = {}
			for x = mapdepth, 1, -1 do
				map2d[x] = {}
				for y = 1, mapheight do
					--find closest to screen (lowest X)
					local lowestx = mapwidth+1
					for x2 = mapwidth, 1, -1 do
						if map[x2][y][mapdepth-x+1].tilenum ~= 1 then
							lowestx = x2
						end
					end
					
					if mapdepth-x+1 == pl.z and y == pl.y+1 then
						if lowestx ~= mapwidth+1 then
							playercovered = true
						end
					end
					
					if lowestx ~= mapwidth+1 then
						map2d[x][y] = map[lowestx][y][mapdepth-x+1].tilenum
					else
						map2d[x][y] = 1
					end
				end
			end
		elseif perspective == "right" then
			map2d = {}
			for x = 1, mapdepth do
				map2d[x] = {}
				for y = 1, mapheight do
					--find closest to screen (highest X)
					local highestx = 0
					for x2 = 1, mapwidth do
						if map[x2][y][x].tilenum ~= 1 then
							highestx = x2
						end
					end
					
					if x == pl.z and y == pl.y+1 then
						if highestx ~= 0 then
							playercovered = true
						end
					end
					
					if highestx ~= 0 then
						map2d[x][y] = map[highestx][y][x].tilenum
					else
						map2d[x][y] = 1
					end
				end
			end
		elseif perspective == "up" then
			map2d = {}
			for x = 1, mapwidth do
				map2d[x] = {}
				for y = 1, mapdepth do
					--find closest to screen (highest Y)
					local highesty = 0
					for y2 = 1, mapheight do
						if map[x][y2][y].tilenum ~= 1 then
							highesty = y2
						end
					end
					
					if x == pl.x and y == pl.z then
						if highesty > pl.y+1 or map[x][highesty][y].tilenum == 3 then
							playercovered = true
						end
					end
					
					if highesty ~= 0 then
						map2d[x][y] = map[x][highesty][y].tilenum
					else
						map2d[x][y] = 1
					end
				end
			end
		end
		if playercovered then
			updateperspective("none")
			return
		end
	end
	
	checkstuff()
end

function checkperspective(perspective)
	local playercovered = false
		
	if perspective == "front" then
		for x = 1, mapwidth do
			for y = 1, mapheight do
				--find closest to screen (lowest Z)
				local lowestz = mapdepth+1
				for z = mapdepth, 1, -1 do
					if map[x][y][z].tilenum ~= 1 then
						lowestz = z
					end
				end
				
				if x == pl.x and y == pl.y+1 then
					if lowestz ~= mapdepth+1 then
						playercovered = true
					end
				end
			end
		end
	elseif perspective == "back" then
		for x = 1, mapwidth do
			for y = 1, mapheight do
				--find closest to screen (highest Z)
				local highestz = 0
				for z = 1, mapdepth do
					if map[mapwidth-x+1][y][z].tilenum ~= 1 then
						highestz = z
					end
				end
				
				if mapwidth-x+1 == pl.x and y == pl.y+1 then
					if highestz ~= 0 then
						playercovered = true
					end
				end
			end
		end
	elseif perspective == "left" then
		for x = mapdepth, 1, -1 do
			for y = 1, mapheight do
				--find closest to screen (lowest X)
				local lowestx = mapwidth+1
				for x2 = mapwidth, 1, -1 do
					if map[x2][y][mapdepth-x+1].tilenum ~= 1 then
						lowestx = x2
					end
				end
				
				if mapdepth-x+1 == pl.z and y == pl.y+1 then
					if lowestx ~= mapwidth+1 then
						playercovered = true
					end
				end
			end
		end
	elseif perspective == "right" then
		for x = 1, mapdepth do
			for y = 1, mapheight do
				--find closest to screen (highest X)
				local highestx = 0
				for x2 = 1, mapwidth do
					if map[x2][y][x].tilenum ~= 1 then
						highestx = x2
					end
				end
				
				if x == pl.z and y == pl.y+1 then
					if highestx ~= 0 then
						playercovered = true
					end
				end
			end
		end
	elseif perspective == "up" then
		for x = 1, mapwidth do
			for y = 1, mapdepth do
				--find closest to screen (highest Y)
				local highesty = 0
				for y2 = 1, mapheight do
					if map[x][y2][y].tilenum ~= 1 then
						highesty = y2
					end
				end
				
				if x == pl.x and y == pl.z then
					if highesty > pl.y+1 or map[x][highesty][y].tilenum == 3 then
						playercovered = true
					end
				end
			end
		end
	end
	
	return playercovered
end

function checkstuff()
	if won == true then
		return
	end
	
	local delete = {}
	
	for i, v in pairs(coins) do
		if perspective == "front" or perspective == "back" then
			for z = 1, mapdepth do
				if v[1] == pl.x and v[2] == pl.y and v[3] == z then
					collectcoin(i)
					table.insert(delete, i)
					coinglowtimert = 0.5
					playsound(coinsound)
				end
			end
		elseif perspective == "right" or perspective == "left" then
			for x = 1, mapwidth do
				if v[1] == x and v[2] == pl.y and v[3] == pl.z then
					collectcoin(i)
					table.insert(delete, i)
					coinglowtimert = 0.5
					playsound(coinsound)
				end
			end
		elseif perspective == "up" then
			for y = mapheight, pl.y, -1 do
				if v[1] == pl.x and v[2] == y and v[3] == pl.z then
					collectcoin(i)
					table.insert(delete, i)
					coinglowtimert = 0.5
					playsound(coinsound)
				end
			end
		else
			if pl.x == v[1] and pl.y == v[2] and pl.z == v[3] then
				collectcoin(i)
				table.insert(delete, i)
				coinglowtimert = 0.5
				playsound(coinsound)
			end
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.insert(collectedcoins, {coins[v][1], coins[v][2], coins[v][3]})
		table.remove(coins, v)
	end
	
	if perspective == "front" then
		if map2d[pl.x][pl.y] == 4 then
			win()
		end
	elseif perspective == "back" then
		if map2d[mapwidth-pl.x+1][pl.y] == 4 then
			win()
		end
	elseif perspective == "right" then
		if map2d[pl.z][pl.y] == 4 then
			win()
		end
	elseif perspective == "left" then
		if map2d[mapdepth-pl.z+1][pl.y] == 4 then
			win()
		end
	else
		if map[pl.x][pl.y][pl.z].tilenum == 4 then
			win()
		end
	end
end

function win()
	won = true
	
	if scoretime < 100 then
		scoretime = round(scoretime, 2)
	else
		scoretime = round(scoretime)
	end
	
	texttimer = texttime
	
	if scoretime <= goaltime then
		timebeaten = true
	else
		timebeaten = false
	end
	
	if scoresteps <= goalsteps then
		stepsbeaten = true
	else
		stepsbeaten = false
	end
	
	if scorewarps <= goalwarps then
		warpsbeaten = true
	else
		warpsbeaten = false
	end
	
	besttime = filetable[currentmap].hightime
	beststeps = filetable[currentmap].highsteps
	bestwarps = filetable[currentmap].highwarps
	
	if not filetable[currentmap].hightime or scoretime < filetable[currentmap].hightime then
		filetable[currentmap].hightime = scoretime
	end
	
	if not filetable[currentmap].highsteps or scoresteps < filetable[currentmap].highsteps then
		filetable[currentmap].highsteps = scoresteps
	end
	
	if not filetable[currentmap].highwarps or scorewarps < filetable[currentmap].highwarps then
		filetable[currentmap].highwarps = scorewarps
	end
	
	--Just got the goldstar?
	if (not besttime or besttime > goaltime) or (not beststeps or beststeps > goalsteps) or (not bestwarps or bestwarps > goalwarps) or #filetable[currentmap].collectedcoins < filetable[currentmap].coins then
		if (not goaltime or filetable[currentmap].hightime <= goaltime) and (not goalsteps or filetable[currentmap].highsteps <= goalsteps) and (not goalwarps or filetable[currentmap].highwarps <= goalwarps) and #filetable[currentmap].collectedcoins+#collectedcoins >= filetable[currentmap].coins then
			newstar = true
		end
	end
	
	--collectedcoins
	for j = 1, #collectedcoins do
		local exists = false
		
		for i = 1, #filetable[currentmap].collectedcoins do
			if filetable[currentmap].collectedcoins[i][1] == collectedcoins[j] or filetable[currentmap].collectedcoins[i][1] == collectedcoins[j] or filetable[currentmap].collectedcoins[i][1] == collectedcoins[j] then
				exists = true
			end
		end
	
		if not exists then
			table.insert(filetable[currentmap].collectedcoins, {collectedcoins[j][1], collectedcoins[j][2], collectedcoins[j][3]})
		end
	end
	
	if currentmap ~= #filetable then
		pausebuttons["next"].active = true
	end
	pausebuttons["retry"].active = true
	pausebuttons["return"].active = true
	
	savesave()
	
	if currentmap == unlockedlevels then
		unlockedlevels = unlockedlevels + 1
	end
	
	winwindowtimer = 0
	playsound(winningsound)
end

function collectcoin(i)
	coincount = coincount + 1
end

function completed_next()
	fadetimert = 0
	fadegoal = "next"
	pausebuttons["next"].active = false
	pausebuttons["retry"].active = false
	pausebuttons["return"].active = false
end

function completed_retry()
	fadetimert = 0
	fadegoal = "retry"
	pausebuttons["next"].active = false
	pausebuttons["retry"].active = false
	pausebuttons["return"].active = false
end

function completed_return()
	fadetimert = 0
	fadegoal = "menu"
	pausebuttons["next"].active = false
	pausebuttons["retry"].active = false
	pausebuttons["return"].active = false
	
	if currentmap == #filetable then
		fadegoal = "menuwin"
	end
end

function pause_back()
	pausemenutimert = 0
	gamepaused = false
	pausebuttons["back"].active = false
	pausebuttons["restart"].active = false
	pausebuttons["togglesound"].active = false
	pausebuttons["tomenu"].active = false
	playsound(backsound)
end

function pause_restart()
	fadetimert = 0
	fadegoal = "retry"
	pausebuttons["back"].active = false
	pausebuttons["restart"].active = false
	pausebuttons["togglesound"].active = false
	pausebuttons["tomenu"].active = false
	playsound(backsound)
end

function pause_togglesound()
	if soundenabled then
		soundenabled = false
		gamemusic:stop()
		pausebuttons["togglesound"].text = "Sound OFF"
		pausebuttons["togglesound"].textwidth = levelselectfont:getWidth(pausebuttons["togglesound"].text)
	else
		soundenabled = true
		playsound(gamemusic)
		pausebuttons["togglesound"].text = "Sound ON"
		pausebuttons["togglesound"].textwidth = levelselectfont:getWidth(pausebuttons["togglesound"].text)
	end
end

function pause_tomenu()
	fadetimert = 0
	fadegoal = "menu"
	pausebuttons["back"].active = false
	pausebuttons["restart"].active = false
	pausebuttons["togglesound"].active = false
	pausebuttons["tomenu"].active = false
	playsound(backsound)
	wantedbackground = {0, 0, 0}
end

function game_keypressed(key)
	pl:keypressed(key)
	
	if key == "escape" and fadetimer3 == 1.5 then
		if pausemenutimert == 0 then
			pausemenutimert = 1
			gamepaused = true
			rotatedrag = false
			pausebuttons["back"].active = true
			pausebuttons["restart"].active = true
			pausebuttons["togglesound"].active = true
			pausebuttons["tomenu"].active = true
			backsound:stop()
			playsound(proceedsound)
		else
			pausemenutimert = 0
			gamepaused = false
			pausebuttons["back"].active = false
			pausebuttons["restart"].active = false
			pausebuttons["togglesound"].active = false
			pausebuttons["tomenu"].active = false
			winningsound:stop()
			playsound(backsound)
		end
	end
end

function game_mousepressed(x, y, button)
	for i, v in pairs(pausebuttons) do
		v:mousepressed(x, y, button)
	end
	
	print(fadegoal)
	if button == rbutton or button == lbutton and (not gamepaused and fadegoal ~= "menu") then
		updateperspective("none")
		rotatedrag = true
		rotatedragX = x
		rotatedragY = y
		smoothtarget = nil
		pitchtarget = nil
		wantedbackground = {0, 0, 0}
	end
end

function game_mousereleased(x, y, button)
	if (button == rbutton or button == lbutton) and love.mouse.isDown(lbutton) == false and love.mouse.isDown(rbutton) == false and fadegoal ~= "menu" then
		rotatedrag = false
		if won == false then
		--check if current pitch is good
			if pitch < clipP then
				local smoothfound = false
				--check if current angle is close enough to good
				for i = 1, 4 do
					if math.abs(math.pi/2*i - (rotation+math.pi/4)) < clipR then
					
						local persp
						if math.pi/2*i - math.pi/4 == pi025 then
							persp = "back"
						elseif math.pi/2*i - math.pi/4 == pi075 then
							persp = "left"
						elseif math.pi/2*i - math.pi/4 == pi125 then
							persp = "front"
						elseif math.pi/2*i - math.pi/4 == pi175 then
							persp = "right"
						end
						
						if checkperspective(persp) == false then
							smoothtarget = math.pi/2*i - math.pi/4 + 0.000001
							pitchtarget = 0
							smoothfound = true
							break
						else
							wantedbackground = {70, 0, 0}
							smoothtarget = nil
							smoothfound = true
						end
					end
				end
			
				if smoothfound == false then
					wantedbackground = {0, 0, 0}
					smoothtarget = nil
				end
			elseif pitch > 1-clipP then
				if checkperspective("up") == false then
					pitchtarget = 1
				else
					wantedbackground = {70, 0, 0}
					pitchtarget = nil
				end
			else
				wantedbackground = {0, 0, 0}
				pitchtarget = nil
			end
		end
	end
end
