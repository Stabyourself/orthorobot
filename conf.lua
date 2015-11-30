function love.conf(t)
	t.title = "Ortho Robot"
	t.identity = "ortho_robot"
	t.author = "Maurice"
	
	if t.screen then
		t.screen.vsync = true
		t.screen.width = 1024
		t.screen.height = 768
	end
	
	if t.window then
		t.window.vsync = true
		t.window.width = 1024
		t.window.height = 768
	end
end