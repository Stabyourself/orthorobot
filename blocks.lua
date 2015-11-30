griddarkenfactor = 0.7

--Colors for .png loading
tilecolors = {}
tilecolors[1] = {255, 255, 255}
tilecolors[2] = {  0,   0,   0}
tilecolors[3] = {255,   0,   0}
tilecolors[4] = {  0, 255,   0}
tilecolors[5] = {255,   0, 255}

specialcolors = {}
specialcolors[1] = {  0,   0, 255} --PLAYER
specialcolors[2] = {255, 255,   0} --COIN

--BLOCK COLORS
blockcolors = {} --First 4 are sides (I think they go clockwise(viewed from top)), 5 is top.
blockcolors[1] = {}
blockcolors[2] = {{220, 220, 220}, {220, 220, 220}, {220, 220, 220}, {220, 220, 220}, {220, 220, 220}}
blockcolors[3] = {{220,   0,   0}, {220,   0,   0}, {220,   0,   0}, {220,   0,   0}, {220,   0,   0}}
blockcolors[4] = {{  0, 220,   0}, {  0, 220,   0}, {  0, 220,   0}, {  0, 220,   0}, {  0, 220,   0}}
blockcolors[5] = {{190, 206, 248}, {190, 206, 248}, {190, 206, 248}, {190, 206, 248}, {190, 206, 248}}

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