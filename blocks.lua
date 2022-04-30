griddarkenfactor = 0.7

--Colors for .png loading
tilecolors = {}
tilecolors[1] = {1,1,1}
tilecolors[2] = {0,0,0}
tilecolors[3] = {1,0,0}
tilecolors[4] = {0,1,0}
tilecolors[5] = {1,0,1}

specialcolors = {}
specialcolors[1] = {0,0,1} --PLAYER
specialcolors[2] = {1,1,0} --COIN

--BLOCK COLORS
blockcolors = {} --First 4 are sides (I think they go clockwise(viewed from top)), 5 is top.
blockcolors[1] = {}
blockcolors[2] = {
	{220/255, 220/255, 220/255}, 
	{220/255, 220/255, 220/255}, 
	{220/255, 220/255, 220/255}, 
	{220/255, 220/255, 220/255}, 
	{220/255, 220/255, 220/255}
}
blockcolors[3] = {
	{220/255,   0,   0}, 
	{220/255,   0,   0}, 
	{220/255,   0,   0}, 
	{220/255,   0,   0}, 
	{220/255,   0,   0}
}
blockcolors[4] = {
	{  0, 220/255,   0}, 
	{  0, 220/255,   0}, 
	{  0, 220/255,   0}, 
	{  0, 220/255,   0}, 
	{  0, 220/255,   0}
}
blockcolors[5] = {
	{190/255, 206/255, 248/255}, 
	{190/255, 206/255, 248/255}, 
	{190/255, 206/255, 248/255}, 
	{190/255, 206/255, 248/255}, 
	{190/255, 206/255, 248/255}
}

--grid colors
gridcolors = {}
for i = 2, #blockcolors do
	gridcolors[i] = {}
	for j = 1, 2 do
		gridcolors[i][j] = {}
		for k = 1, 3 do
			gridcolors[i][j][k] = blockcolors[i][6-j][k] * griddarkenfactor
		end		
		gridcolors[i][j][4] = 255
	end
end