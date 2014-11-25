game = {}

function game:enter()
    self.map = Map:new(500, 500, 20, 20)
	self.soldiers = {}
	
	--self.map.tiles[10][10].tile = 1
	for i = 1, 20 do
		self.map.tiles[1][i].tile = 3
	end
	
	self.state = 'setup'
	
	self.timer = 0
	self.gameStep = 1
end

function game:update(dt)
	if self.state == 'running' then
		self.timer = self.timer + dt
		if self.timer > self.gameStep then
			self.timer = 0
			
			self.hotTiles = {}
			for k, soldier in pairs(self.soldiers) do
				local hot = false
				for i = 1, #self.hotTiles do
					if self.hotTiles[i][1] == soldier.x and self.hotTiles[i][2] == soldier.y then
						hot = true
					end
				end
			
				local x, y = soldier:step(hot)
				if x and y then
					table.insert(self.hotTiles, {x, y})
				end
			end
		end
		
		for k, soldier in pairs(self.soldiers) do
			soldier:update()
		end
	end
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	if key == 'return' then
		self:startSim()
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	self.map:mousepressed(x, y, mbutton)
end

function game:draw()
    self.map:draw()
	
	for k, soldier in pairs(self.soldiers) do
		soldier:draw()
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.state, 5, 5)
end


function game:startSim()
	self.state = 'running'
	self.soldiers = self.map:startSim()
end