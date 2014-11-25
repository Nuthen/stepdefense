Soldier = class('Soldier')

function Soldier:initialize(piece, x, y)
	self.piece = piece

	self.x = x
	self.y = y
	
	self.searchAngle = math.rad(55) -- degrees
	self.angle = 0 -- degrees
	if self.piece == 2 then
		self.angle = math.rad(-90)
	elseif self.piece == 3 then
		self.angle = math.rad(90)
	end
	
	self.mouseOver = false
end

function Soldier:step(hot)
	if not self.destroy then
		if not hot then
			game.map.tiles[self.y][self.x].tile = 0
		end

		if self.piece == 3 then
			if self.y < game.map.rows then
				self.y = self.y + 1
			end
		end
		
		if self.piece == 2 then
			for k, soldier in pairs(game.soldiers) do
				if soldier.piece == 3 and soldier.x == self.x then
					if soldier.y == self.y or soldier.y == self.y - 1 then
						soldier.destroy = true
					end
				end
			end
		end
		
		game.map.tiles[self.y][self.x].tile = self.piece
		
		return self.x, self.y
	end
end

function Soldier:update()
	if self.destroy then
		game.map.tiles[self.y][self.x].tile = 0
		self.mouseOver = false
	else
		local mouseX, mouseY = love.mouse.getPosition()
		if mouseX >= game.map.x + (self.x-1)*(game.map.tileWidth) and mouseX < game.map.x + (self.x-1)*(game.map.tileWidth) + game.map.tileWidth
		and mouseY >= game.map.y + (self.y-1)*(game.map.tileHeight) and mouseY < game.map.y + (self.y-1)*(game.map.tileHeight) + game.map.tileHeight then
			self.mouseOver = true
		else
			self.mouseOver = false
		end
	end
end

function Soldier:draw()
	if self.mouseOver then
		local x = game.map.x + (self.x-1)*(game.map.tileWidth) + game.map.tileWidth/2
		local y = game.map.y + (self.y-1)*(game.map.tileHeight) + game.map.tileWidth/2
	
		local dist = 500
	
		local angle1 = self.angle - self.searchAngle/2
		local angle2 = self.angle + self.searchAngle/2
		
		local dx1 = math.cos(angle1)*dist
		local dy1 = math.sin(angle1)*dist
		
		local dx2 = math.cos(angle2)*dist
		local dy2 = math.sin(angle2)*dist
		
		love.graphics.line(x, y, x + dx1, y + dy1)
		love.graphics.line(x, y, x + dx2, y + dy2)
	end
end