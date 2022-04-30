--ORTHO ROBOT
--by Maurice Gu�gan
--Stabyourself.net
--Made in 7 days for a competition (Total time: ~50 hours)

--Music credits:
--Menu background: "Trooped" by BlueAngelEagle
--Game background: "oh" by Capsadmin

--Other credits
--yay.png (star) by http://www.psdgraphics.com/

--Version compatibility stuff
major, minor, revision, codename = love.getVersion()
if major == 0 and minor <= 9 then
	lbutton = "l"
	rbutton = "r"
else
	lbutton = 1
	rbutton = 2
end
math.mod = math.fmod
if not love.graphics.drawq then
	love.graphics.drawq = love.graphics.draw
end

local lg_polygon = love.graphics.polygon
local lg_setColor = love.graphics.setColor

function love.load()
	require "intro"
	require "menu"
	require "game"
	require "blocks"
	require "class"
	require "block"
	require "player"
	require "backgroundblock"
	require "menubutton"
	require "levelbutton"
	require "pausebutton"
	
	math.randomseed(os.time());math.random();math.random()
	
	menufont = love.graphics.newFont( "font.ttf", 40)
	helpfont = love.graphics.newFont( "font.ttf", 30)
	winwindowtitlefont = love.graphics.newFont( "font.ttf", 23)
	levelselectfont = love.graphics.newFont( "font.ttf", 20)
	winwindowfont = love.graphics.newFont( "font.ttf", 15)
	coinsfont = love.graphics.newFont( "font.ttf", 11)
	love.graphics.setFont( menufont )
	
	areyousurewidth = menufont:getWidth( "Are you sure?" )
	
	soundenabled = true
	
	drawfaces = true
	drawgrid = true
	
	currentmap = 1
	unlockedlevels = 1
	
	fadecolor = 0
	
	creditsr = 0
	creditss = 0
	
	currentbackground = {0, 0, 0}
	wantedbackground = {0, 0, 0}
	
	shadowfactor = 0.8
	shadowtopfactor = 0.2
	
	backgroundblocks = {}
	rainbowi = math.random()
	
	clipR = math.rad(10)
	clipP = 0.2
	
	smoothconstant = 0.005
	
	rotatespeed = math.pi/500
	pitchspeed = math.pi/1000
	
	love.graphics.setPointSize(5)
	
	maxpitch = 1
	minpitch = 0
	
	winscreen = false
	
	pi025 = math.pi*0.25
	pi05 = math.pi*0.5
	pi075 = math.pi*0.75
	pi1 = math.pi
	pi125 = math.pi*1.25
	pi15 = math.pi*1.5
	pi175 = math.pi*1.75
	pi2 = math.pi*2
	
	fillcolor = {11, 63, 27}
	outlinecolor = {7, 37, 16}
	
	logo = love.graphics.newImage("stabyourself.png")
	logoblood = love.graphics.newImage("stabyourselfblood.png")
	
	playerimg = love.graphics.newImage("player.png");playerimg:setFilter("nearest", "nearest")
	playerquad = {love.graphics.newQuad(0, 0, 20, 20, 40, 20), love.graphics.newQuad(20, 0, 20, 20, 40, 20)}
	
	coinimg = love.graphics.newImage("coin.png");coinimg:setFilter("nearest", "nearest")
	scanlineimg = love.graphics.newImage("scanlines.png");scanlineimg:setFilter("nearest", "nearest")
	
	textavatarimg = love.graphics.newImage("textavatar.png");textavatarimg:setFilter("nearest", "nearest")
	
	helptextimg = love.graphics.newImage("helptext.png");helptextimg:setFilter("nearest", "nearest")
	helpgoalimg = love.graphics.newImage("helpgoal.png");helpgoalimg:setFilter("nearest", "nearest")
	helpplayerimg = love.graphics.newImage("helpplayer.png");helpplayerimg:setFilter("nearest", "nearest")
	helpfswdimg = love.graphics.newImage("helpfswd.png");helpfswdimg:setFilter("nearest", "nearest")
	helpcursorimg = love.graphics.newImage("helpcursor.png");helpcursorimg:setFilter("nearest", "nearest")
	
	coinsbackimg = love.graphics.newImage("coinsback.png");coinsbackimg:setFilter("nearest", "nearest")
	yayimg = love.graphics.newImage("yay.png");yayimg:setFilter("nearest", "nearest")
	yaywonimg = love.graphics.newImage("yaywon.png");yaywonimg:setFilter("nearest", "nearest")
	
	clockimg = love.graphics.newImage("clock.png");clockimg:setFilter("nearest", "nearest")
	stepsimg = love.graphics.newImage("steps.png");stepsimg:setFilter("nearest", "nearest")
	warpsimg = love.graphics.newImage("warps.png");warpsimg:setFilter("nearest", "nearest")
	
	number1img = love.graphics.newImage("1.png");number1img:setFilter("nearest", "nearest")
	number2img = love.graphics.newImage("2.png");number2img:setFilter("nearest", "nearest")
	number3img = love.graphics.newImage("3.png");number3img:setFilter("nearest", "nearest")
	gosmallimg = love.graphics.newImage("gosmall.png");gosmallimg:setFilter("nearest", "nearest")
	gobigimg = love.graphics.newImage("gobig.png");gobigimg:setFilter("nearest", "nearest")
	
	winplayerimg = love.graphics.newImage("winplayer.png");winplayerimg:setFilter("nearest", "nearest")
	coinglowimg = love.graphics.newImage("coinglow.png");coinglowimg:setFilter("nearest", "nearest")
	
	ssssimg = love.graphics.newImage("ssss.png");ssssimg:setFilter("nearest", "nearest")
	accentimg = love.graphics.newImage("accent.png");accentimg:setFilter("nearest", "nearest")
	
	menumusic = love.audio.newSource("sounds/menu_back.ogg", "stream")
	menumusic:setLooping(true)
	menumusic:setVolume(0.01)
	gamemusic = love.audio.newSource("sounds/game_back.ogg", "stream")
	gamemusic:setLooping(true)
	stabsound = love.audio.newSource("sounds/stab.ogg", "static")
	
	backsound = love.audio.newSource("sounds/back.ogg", "static")
	proceedsound = love.audio.newSource("sounds/proceed.ogg", "static")
	winningsound = love.audio.newSource("sounds/winning.ogg", "static")
	coinsound = love.audio.newSource("sounds/coin.ogg", "static")
	
	loadlevels()
	scale = 1
	loadsave()
	currentmap = unlockedlevels
	
	loadmenumap("menu")

	intro_load()
	
	skipupdate = true
	 
	love.graphics.setLineWidth(1/scale)
	if scale ~= 1 then
		changescale(scale)
	end
	
	screenwidth = 1024
	screenheight = 768
end

function changescale(s)
	scale = s
	if love.graphics.setMode then
		love.graphics.setMode(1024*scale, 768*scale, false, true)
	elseif love.window.setMode then
		love.window.setMode(1024*scale, 768*scale, {fullscreen=false, vsync=true})
	end
	
	love.graphics.setLineWidth(1/scale)
end

function love.update(dt)
	if skipupdate then
		skipupdate = false
		return
	end
	
	dt = math.min(dt, 0.1666666667)
	
	creditss = creditss + dt*4
	creditsr = math.sin(creditss)/10
	
	--background fading
	local b = currentbackground
	for c = 1, 3 do
		if b[c] > wantedbackground[c] then
			b[c] = b[c] - dt*600
			if b[c] < wantedbackground[c] then
				b[c] = wantedbackground[c]
			end
		elseif b[c] < wantedbackground[c] then
			b[c] = b[c] + dt*600
			if b[c] > wantedbackground[c] then
				b[c] = wantedbackground[c]
			end
		end
	end
	currentbackground = b
	
	love.graphics.setBackgroundColor(b)
	
	for i, v in pairs(backgroundblocks) do
		v:update(dt)
	end
	
	rainbowi = rainbowi + dt*0.2
	while rainbowi > 1 do
		rainbowi = rainbowi - 1
	end
	fillcolor = getrainbowcolor(rainbowi, 100)
	outlinecolor = getrainbowcolor(rainbowi, 50)
	c = getrainbowcolor(rainbowi)
	for i = 1, 3 do
		c[i] = c[i] + (255-c[i])*0.5
	end

	if gamestate == "game" then
		game_update(dt)
	elseif gamestate == "menu" then
		menu_update(dt)
	elseif gamestate == "intro" then
		intro_update(dt)
	end
end

function love.draw()
	love.graphics.scale(scale, scale)
	if gamestate == "intro" then
		intro_draw()
	elseif gamestate == "game" then
		for i, v in pairs(backgroundblocks) do
			v:draw()
		end
		game_draw()
	elseif gamestate == "menu" then
		for i, v in pairs(backgroundblocks) do
			v:draw()
		end
		menu_draw()
	elseif gamestate == "error" then
		love.graphics.print("Failed to load map (Nonexistant map.png or map.txt? Height doesn't match up?)", 0, 0)
	end
end

function love.keypressed(key, unicode)
	if gamestate == "game" then
		game_keypressed(key)
	elseif gamestate == "menu" then
		menu_keypressed(key)
	elseif gamestate == "intro" then
		intro_keypressed(key)
	end
end

function mymousegetX()
	return love.mouse.getX()*(1/scale)
end

function mymousegetY()
	return love.mouse.getY()*(1/scale)
end

function mymousegetPosition()
	return love.mouse.getX()*(1/scale), love.mouse.getY()*(1/scale)
end

function mygraphicssetScissor(x, y, w, h)
	if x and y and w and h then
		love.graphics.setScissor(x*scale, y*scale, w*scale, h*scale)
	else
		love.graphics.setScissor()
	end
end

function mygraphicsgetScissor()
	local x, y, w, h = love.graphics.getScissor()
	if x and y and w and h then
		return x*(1/scale), y*(1/scale), w*(1/scale), h*(1/scale)
	else
		return false
	end
end

function love.mousepressed(x, y, button)
	x = x * (1/scale)
	y = y * (1/scale)
	if gamestate == "game" then
		game_mousepressed(x, y, button)
	elseif gamestate == "menu" then
		menu_mousepressed(x, y, button)
	elseif gamestate == "intro" then
		intro_mousepressed(x, y, button)
	end
end

function love.mousereleased(x, y, button)
	x = x * (1/scale)
	y = y * (1/scale)
	if gamestate == "game" then
		game_mousereleased(x, y, button)
	end
end

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function string:split(delimiter)
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function smooth(i, target, dt)
	local diff = target-i
	if diff > 0 then
		return i + diff*10*dt + smoothconstant*dt
	else
		return i + diff*10*dt - smoothconstant*dt
	end
end

function loadmap(name)
	if string.sub(name, -4) == ".txt" then
		name = string.sub(name, 1, -5)
	end
	
	if love.filesystem.getInfo("maps/" .. name .. ".txt") == false or love.filesystem.getInfo("maps/" .. name .. ".png") == false then
		return false
	end
	
	--LOAD OPTIONS	
	local txtcontents = love.filesystem.read("maps/" .. name .. ".txt")
	
	goaltime = 60.00
	goalsteps = 100
	goalwarps = 10
	
	local s1 = txtcontents:split("\n")
	for i = 1, #s1 do
		local s2 = s1[i]:split("=")
		if s2[1] == "height" then
			mapheight = tonumber(s2[2])
		elseif s2[1] == "text" then
			text = s2[2]
		elseif s2[1] == "time" then
			goaltime = tonumber(s2[2])
		elseif s2[1] == "steps" then
			goalsteps = tonumber(s2[2])
		elseif s2[1] == "warps" then
			goalwarps = tonumber(s2[2])
		end
	end
	
	--LOAD MAP	
	local imgdata = love.image.newImageData("maps/" .. name .. ".png")
	mapwidth = imgdata:getWidth()
	mapdepth = imgdata:getHeight()/mapheight
	
	if mapwidth ~= math.floor(mapwidth) or mapheight ~= math.floor(mapheight) or mapdepth ~= math.floor(mapdepth) then
		return false
	end
	
	rotcenterX = mapwidth/2+.5
	rotcenterY = mapheight/2
	rotcenterZ = mapdepth/2+.5
	
	coins = {}
	start = {1, 2, 1}
	
	--clear maptable
	map = {}
	
	for x = 1, mapwidth do
		map[x] = {}
		for y = 1, mapheight do
			map[x][y] = {}
			for z = 1, mapdepth do
				map[x][y][z] = block:new(x, y, z, 1, map)
			end
		end
	end
	
	for y = 1, mapheight do
		for z = 1, mapdepth do
			for x = 1, mapwidth do
				local r, g, b, a = imgdata:getPixel( x-1, z+(y-1)*mapdepth-1 )
				
				for i = 1, #tilecolors do
					if r == tilecolors[i][1] and g == tilecolors[i][2] and b == tilecolors[i][3] then
						map[x][mapheight-y+1][mapdepth-z+1].tilenum = i
						map[x][mapheight-y+1][mapdepth-z+1].facecolor = blockcolors[i]
						map[x][mapheight-y+1][mapdepth-z+1].gridcolor = gridcolors[i]
					end
				end
				
				for i = 1, #specialcolors do
					if r == specialcolors[i][1] and g == specialcolors[i][2] and b == specialcolors[i][3] then
						map[x][mapheight-y+1][mapdepth-z+1].tilenum = 1
						
						if i == 1 then
							start = {x, mapheight-y, mapdepth-z+1}
						elseif i == 2 then
							local good = true
							for j = 1, #filetable[currentmap].collectedcoins do
								if x == filetable[currentmap].collectedcoins[j][1] and mapheight-y == filetable[currentmap].collectedcoins[j][2] and mapdepth-z+1 == filetable[currentmap].collectedcoins[j][3] then
									good = false
								end
							end
							
							if good then
								table.insert(coins, {x, mapheight-y, mapdepth-z+1})
							end
						end
					end
				end		
			end
		end
	end
	
	for x = 1, mapwidth do
		for y = 1, mapheight do
			for z = 1, mapdepth do
				map[x][y][z]:updatevisiblefaces()
			end
		end
	end
end

function loadmenumap(name)
	if string.sub(name, -4) == ".txt" then
		name = string.sub(name, 1, -5)
	end
	
	if love.filesystem.getInfo("maps/" .. name .. ".txt") == false or love.filesystem.getInfo("maps/" .. name .. ".png") == false then
		return false
	end
	
	--LOAD OPTIONS	
	local txtcontents = love.filesystem.read("maps/" .. name .. ".txt")
	
	local s1 = txtcontents:split("\n")
	for i = 1, #s1 do
		local s2 = s1[i]:split("=")
		if s2[1] == "height" then
			menumapheight = tonumber(s2[2])
		end
	end
	
	--LOAD MAP	
	local imgdata = love.image.newImageData("maps/" .. name .. ".png")
	menumapwidth = imgdata:getWidth()
	menumapdepth = imgdata:getHeight()/menumapheight
	
	if menumapwidth ~= math.floor(menumapwidth) or menumapheight ~= math.floor(menumapheight) or menumapdepth ~= math.floor(menumapdepth) then
		return false
	end
	
	menurotcenterX = menumapwidth/2+.5
	menurotcenterY = menumapheight/2
	menurotcenterZ = menumapdepth/2+.5
	
	--clear maptable
	menumap = {}
	
	for x = 1, menumapwidth do
		menumap[x] = {}
		for y = 1, menumapheight do
			menumap[x][y] = {}
			for z = 1, menumapdepth do
				menumap[x][y][z] = menublock:new(x, y, z, 1)
			end
		end
	end
	
	for y = 1, menumapheight do
		for z = 1, menumapdepth do
			for x = 1, menumapwidth do
				local r, g, b, a = imgdata:getPixel( x-1, z+(y-1)*menumapdepth-1 )
				
				for i = 1, #tilecolors do
					if r == tilecolors[i][1] and g == tilecolors[i][2] and b == tilecolors[i][3] then
						menumap[x][menumapheight-y+1][menumapdepth-z+1].tilenum = i
						menumap[x][menumapheight-y+1][menumapdepth-z+1].facecolor = blockcolors[i]
						menumap[x][menumapheight-y+1][menumapdepth-z+1].gridcolor = gridcolors[i]
					end
				end
			end
		end
	end
	
	for x = 1, menumapwidth do
		for y = 1, menumapheight do
			for z = 1, menumapdepth do
				menumap[x][y][z]:updatevisiblefaces()
			end
		end
	end
end

function convertGRDtoSCR(cox, coy, coz) --CONVERTS GRID COORDINATES INTO SCREEN COORDINATES
	local angle = math.atan2(cox-rotcenterX, coz-rotcenterZ)
	local r = math.sqrt((cox-rotcenterX)^2 + (coz-rotcenterZ)^2)
	local x = drawcenterX+math.cos(angle+rotation+pi025)*r*pointsevenboxwidth
	local y = drawcenterY+math.sin(angle+rotation+pi025)*r*pointsevenboxwidth*pitch + (rotcenterY-coy)*boxheightmodded
	
	return x, y
end

function drawlinepolygon(...)
	local points = {...}
	for i = 1, #points-2, 2 do
		love.graphics.line(points[i], points[i+1], points[i+2], points[i+3])
	end
	love.graphics.line(points[#points-1], points[#points], points[1], points[2])
end

function drawtile(cox, coy, coz, tile, xd, yd, zd)
	local tilenum = tile.tilenum
	if tilenum ~= 1 then
		local x, y = convertGRDtoSCR(cox, coy, coz)
		drawbox(x, y, tile)
	end
	
	if pl then
		local playerx = math.floor(pl.drawx)
		local playery = math.floor(pl.drawy)
		local playerz = math.floor(pl.drawz)
		if xd == 1 then
			playerx = math.ceil(pl.drawx)
		end
		if yd == 1 then
			playery = math.ceil(pl.drawy)
		end
		if zd == 1 then
			playerz = math.ceil(pl.drawz)
		end
		
		if perspective ~= "up" then
			if playerx == cox and playery == coy and playerz == coz then
				local x, y = convertGRDtoSCR(pl.drawx, pl.drawy, pl.drawz)
				love.graphics.setColor(255, 255, 255, 255*fadecolor)
				if won == false then
					love.graphics.drawq(playerimg, playerquad[1], round(x), round(y+halfboxwidth*pitch*0.6), 0, playerscale, playerscale, 10, 20)
					love.graphics.setColor(255, 255, 255, 255*coinglowa)
					love.graphics.draw(coinglowimg, round(x), round(y+halfboxwidth*pitch*0.6), 0, playerscale/4, playerscale/4, 29, 89)
				else
					love.graphics.drawq(playerimg, playerquad[2], round(x), round(y+halfboxwidth*pitch*0.6), 0, playerscale, playerscale, 10, 20)
					love.graphics.setColor(0, 255, 0, 255*fadecolor)
					love.graphics.rectangle("fill", round(x)-2*playerscale, round(y+halfboxwidth*pitch*0.6)-16*playerscale-winwindowtimer/1*3*playerscale, 4*playerscale, winwindowtimer/1*3*playerscale)
				end
			end
		end
	end
	
	for i, v in pairs(coins) do
		if v[1] == cox and v[2] == coy and v[3] == coz then
			local x, y = convertGRDtoSCR(cox, coy, coz)
			love.graphics.setColor(255, 255, 255, 255*fadecolor)
			love.graphics.draw(coinimg, round(x), round(y+halfboxwidth*pitch*0.6-(math.sin(rainbowi*pi2)+1)*halfboxwidth/6+3*playerscale), 0, playerscale, playerscale, 10, 20)
		end
	end
end

function drawbox(x, y, tile)
	local point1 = {x+relpoint1[1], y+relpoint1[2]}
	local point2 = {x+relpoint2[1], y+relpoint2[2]}
	local point3 = {x+relpoint3[1], y+relpoint3[2]}
	local point4 = {x+relpoint4[1], y+relpoint4[2]}
	
	--TOPSIDE
	if tile.facevisible[5] then
		if drawfaces then
			local r, g, b, a = unpack(tile.facecolor[5])
			lg_setColor(r*shadowtop, g*shadowtop, b*shadowtop, (a or 255)*fillfadecolor)
			lg_polygon("fill", point1[1], point1[2], point2[1], point2[2], point3[1], point3[2], point4[1], point4[2])
		end
		
		if drawgrid then
			local r, g, b, a = unpack(tile.gridcolor[1])
			lg_setColor(r*shadowtop, g*shadowtop, b*shadowtop, (a or 255)*gridfadecolor)
			drawlinepolygon(point1[1], point1[2], point2[1], point2[2], point3[1], point3[2], point4[1], point4[2])
		end
	end
	
	--SIDES
	--get which sides to draw
	local newpoint1, newpoint2, newpoint3, newpoint4, newpoint5, newpoint6
	local side1, side2
	
	if rotation < pi075 and rotation >= pi025 then --SIDES 4 AND 1
		side1 = 1
		side2 = 4
		
		if tile.facevisible[side1] or tile.facevisible[side2] then
			newpoint1 = point2
			newpoint2 = point1
			newpoint3 = point4
			
			newpoint4 = {newpoint1[1], newpoint1[2] + boxheightmodded}
			newpoint5 = {newpoint2[1], newpoint2[2] + boxheightmodded}
			newpoint6 = {newpoint3[1], newpoint3[2] + boxheightmodded}
		end
	elseif rotation < pi025 or rotation >= pi175 then --SIDES 1 AND 2
		side1 = 2
		side2 = 1
		
		if tile.facevisible[side1] or tile.facevisible[side2] then
			newpoint1 = point3
			newpoint2 = point2
			newpoint3 = point1
			
			newpoint4 = {newpoint1[1], newpoint1[2] + boxheightmodded}
			newpoint5 = {newpoint2[1], newpoint2[2] + boxheightmodded}
			newpoint6 = {newpoint3[1], newpoint3[2] + boxheightmodded}
		end	
	elseif rotation < pi175 and rotation >= pi125 then --SIDES 2 AND 3
		side1 = 3
		side2 = 2
		
		if tile.facevisible[side1] or tile.facevisible[side2] then
			newpoint1 = point4
			newpoint2 = point3
			newpoint3 = point2
			
			newpoint4 = {newpoint1[1], newpoint1[2] + boxheightmodded}
			newpoint5 = {newpoint2[1], newpoint2[2] + boxheightmodded}
			newpoint6 = {newpoint3[1], newpoint3[2] + boxheightmodded}
		end
	elseif rotation < pi125 and rotation >= pi075 then --SIDES 3 AND 4
		side1 = 4
		side2 = 3
		
		if tile.facevisible[side1] or tile.facevisible[side2] then
			newpoint1 = point1
			newpoint2 = point4
			newpoint3 = point3
			--Yarr I'm a pirate comment, gimme your booty
			newpoint4 = {newpoint1[1], newpoint1[2] + boxheightmodded}
			newpoint5 = {newpoint2[1], newpoint2[2] + boxheightmodded}
			newpoint6 = {newpoint3[1], newpoint3[2] + boxheightmodded}
		end
	end
	
	--draw them sides
	local function leftside()
		if tile.facevisible[side2] then
			if drawfaces then
				local r, g, b, a = unpack(tile.facecolor[side2])
				lg_setColor(r*shadow1, g*shadow1, b*shadow1, (a or 255)*fillfadecolor)
				lg_polygon("fill", newpoint2[1], newpoint2[2], newpoint3[1], newpoint3[2], newpoint6[1], newpoint6[2], newpoint5[1], newpoint5[2])
			end
			
			if drawgrid then
				local r, g, b, a = unpack(tile.gridcolor[2])
				lg_setColor(r*shadow1, g*shadow1, b*shadow1, (a or 255)*gridfadecolor)
				drawlinepolygon(newpoint2[1], newpoint2[2], newpoint3[1], newpoint3[2], newpoint6[1], newpoint6[2], newpoint5[1], newpoint5[2])
			end
		end
	end
	
	local function rightside()
		if tile.facevisible[side1] then
			if drawfaces then
				local r, g, b, a = unpack(tile.facecolor[side1])
				lg_setColor(r*shadow2, g*shadow2, b*shadow2, (a or 255)*fillfadecolor)
				lg_polygon("fill", newpoint1[1], newpoint1[2], newpoint2[1], newpoint2[2], newpoint5[1], newpoint5[2], newpoint4[1], newpoint4[2])
			end
			
			if drawgrid then
				local r, g, b, a = unpack(tile.gridcolor[2])
				lg_setColor(r*shadow2, g*shadow2, b*shadow2, (a or 255)*gridfadecolor)
				drawlinepolygon(newpoint1[1], newpoint1[2], newpoint2[1], newpoint2[2], newpoint5[1], newpoint5[2], newpoint4[1], newpoint4[2])
			end
		end
	end
	
	if shadow1 > shadow2 then
		rightside()
		leftside()
	else
		leftside()
		rightside()
	end
end

function calculatevars()
	boxheight = boxwidth*0.9
	
	halfboxwidth = boxwidth/2
	boxheight = boxheight * math.sin(math.pi/4)
	pointsevenboxwidth = boxwidth*0.7
	boxheightmod = 1-pitch^3
	boxheightmodded = boxheight*boxheightmod
	
	--CALCULATE RELATIVE POINTS OF BOXES!
	relpoint1 = {math.cos(rotation)*halfboxwidth, math.sin(rotation)*halfboxwidth*pitch}
	relpoint2 = {math.cos(rotation+pi05)*halfboxwidth, math.sin(rotation+pi05)*halfboxwidth*pitch}
	relpoint3 = {math.cos(rotation+pi1)*halfboxwidth, math.sin(rotation+pi1)*halfboxwidth*pitch}
	relpoint4 = {math.cos(rotation+pi15)*halfboxwidth, math.sin(rotation+pi15)*halfboxwidth*pitch}
	
	
	shadowtop = 1-boxheightmod^2*shadowtopfactor
	shadow1 = (1-math.abs((math.pi/2-math.mod(rotation+math.pi/4, math.pi/2)))*(1/(math.pi/2)))
	shadow2 = 1-shadow1
	
	shadow1 = shadow1*shadowfactor+(1-shadowfactor)
	shadow2 = shadow2*shadowfactor+(1-shadowfactor)
	
	shadow1 = 1-(1-shadow1)^2
	shadow2 = 1-(1-shadow2)^2
end

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function loadsave()
	if not love.filesystem.getInfo("save.txt") then
		return
	end
	
	local txtcontents = love.filesystem.read("save.txt")
	txtcontents = txtcontents:split(";")
	local currentmap
	local s
	for i = 1, #txtcontents do
		s = txtcontents[i]:split("=")
		if s[1] == "map" then
			for j = 1, #filetable do
				if s[2] == filetable[j].path then
					currentmap = j
				end
			end
		elseif s[1] == "time" then
			filetable[currentmap].hightime = round(tonumber(s[2]), 2)
		elseif s[1] == "steps" then
			filetable[currentmap].highsteps = tonumber(s[2])
		elseif s[1] == "warps" then
			filetable[currentmap].highwarps = tonumber(s[2])
		elseif s[1] == "coins" then
			s2 = s[2]:split(":")
			for j = 1, #s2 do
				s3 = s2[j]:split(",")
				table.insert(filetable[currentmap].collectedcoins, {tonumber(s3[1]), tonumber(s3[2]), tonumber(s3[3])})
			end
		elseif s[1] == "sound" then
			if s[2] == "true" then
				soundenabled = true
			else
				soundenabled = false
			end
		elseif s[1] == "scale" then
			scale = tonumber(s[2])
		end
		
		if filetable[currentmap].hightime then
			unlockedlevels = currentmap + 1
		end
	end
end

function savesave()
	s = ""
	for i = 1, #filetable do
		s = s .. "map=" .. filetable[i].path .. ";"
		if filetable[i].hightime then
			s = s .. "time=" .. filetable[i].hightime .. ";"
		end
		if filetable[i].highsteps then
			s = s .. "steps=" .. filetable[i].highsteps .. ";"
		end
		if filetable[i].highwarps then
			s = s .. "warps=" .. filetable[i].highwarps .. ";"
		end
		for j = 1, #filetable[i].collectedcoins do
			if j == 1 then
				s = s .. "coins="
			end
			s = s .. filetable[i].collectedcoins[j][1] .. "," .. filetable[i].collectedcoins[j][2] .. "," .. filetable[i].collectedcoins[j][3]
			if j ~= #filetable[i].collectedcoins then
				s = s .. ":"
			else
				s = s .. ";"
			end
		end
	end
	s = s .. "scale=" .. scale .. ";"
	if soundenabled then
		s = s .. "sound=true;"
	else
		s = s .. "sound=false;"
	end
	
	love.filesystem.write("save.txt", s)
end

function rotatedsquare(mode, x, y, r, d)
	local a = d/2 * math.sqrt(2)
	
	local points = {}
	for rot = 0, math.pi*1.5, math.pi/2 do
		table.insert(points, x+math.sin(rot+r+math.pi/4)*a)
		table.insert(points, y+math.cos(rot+r+math.pi/4)*a)
	end
	
	love.graphics.polygon(mode, unpack(points))
end

function drawblock(x, y, width, height, fillcolor, outlinecolor, r)
	if math.mod((r or 0), math.pi/2) ~= 0 then --Rotated
		love.graphics.setColor(unpack(fillcolor))
		rotatedsquare("fill", x+width/2+.5, y+height/2+.5, r or 0, width-1)
		love.graphics.setColor(unpack(outlinecolor))
		rotatedsquare("line", x+width/2+.5, y+height/2+.5, r or 0, width)
	else --not rotated
		love.graphics.setColor(unpack(fillcolor))
		love.graphics.rectangle("fill", x+1, y+1, width-1, height-1)
		love.graphics.setColor(unpack(outlinecolor))
		love.graphics.rectangle("line", x+.5, y+.5, width, height)
	end
end

function getrainbowcolor(i, whiteness)
	if not whiteness then
		whiteness = 255
	end
	local r, g, b
	if i < 1/6 then
		r = 1
		g = i*6
		b = 0
	elseif i >= 1/6 and i < 2/6 then
		r = (1/6-(i-1/6))*6
		g = 1
		b = 0
	elseif i >= 2/6 and i < 3/6 then
		r = 0
		g = 1
		b = (i-2/6)*6
	elseif i >= 3/6 and i < 4/6 then
		r = 0
		g = (1/6-(i-3/6))*6
		b = 1
	elseif i >= 4/6 and i < 5/6 then
		r = (i-4/6)*6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = (1/6-(i-5/6))*6
	end
	
	return {round(r*whiteness), round(g*whiteness), round(b*whiteness), 255}
end

function playsound(sound)
	if soundenabled then
		sound:stop()
		sound:play()
	end
end
