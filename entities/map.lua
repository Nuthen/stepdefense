Map = class('Map')

function Map:initialize(width, height, columns, rows)
	local scrnWidth, scrnHeight = love.graphics.getDimensions()
	self.x = scrnWidth/2 - width/2
	self.y = scrnHeight/2 - height/2
	
	self.width = width
	self.height = height
	
	self.tileWidth = width/columns
	self.tileHeight = height/rows
	
	self.columns = columns
	self.rows = rows
	
	self.tiles = {}
	for iy = 1, rows do
		self.tiles[iy] = {}
		for ix = 1, columns do
			self.tiles[iy][ix] = {tile = 0}
		end
	end
	
	self.tileBaseColor = {89, 118, 128}
	self.tileKingColor = {222, 193, 67}
	self.tileSoldierColor = {64, 161, 230}
	self.tileEnemyColor = {209, 52, 78}
end

function Map:mousepressed(x, y, mbutton)
	local tileX = math.ceil((x-self.x)/self.tileWidth)
	local tileY = math.ceil((y-self.y)/self.tileHeight)
	
	if tileX > 0 and tileY > 0 and tileX <= self.columns and tileY <= self.rows then
		if self.tiles[tileY][tileX].tile == 0 then
			self.tiles[tileY][tileX].tile = 2
		elseif self.tiles[tileY][tileX].tile == 2 then
			self.tiles[tileY][tileX].tile = 0
		end
	end
end

function Map:draw()
	for iy = 1, #self.tiles do
		for ix = 1, #self.tiles[iy] do
			love.graphics.setColor(self.tileBaseColor)
			if iy == #self.tiles then
				love.graphics.setColor(255, 0, 0)
			elseif self.tiles[iy][ix].tile == 1 then
				love.graphics.setColor(self.tileKingColor)
			elseif self.tiles[iy][ix].tile == 2 then
				love.graphics.setColor(self.tileSoldierColor)
			elseif self.tiles[iy][ix].tile == 3 then
				love.graphics.setColor(self.tileEnemyColor)
			end
			
			local x, y = self.x + (ix-1)*self.tileWidth, self.y + (iy-1)*self.tileHeight
			
			love.graphics.rectangle('fill', x, y, self.tileWidth, self.tileHeight)
			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle('line', x, y, self.tileWidth, self.tileHeight)
		end
	end
end


function Map:startSim()
	local soldiers = {}

	for iy = 1, self.rows do
		for ix = 1, self.columns do
			local tile = self.tiles[iy][ix].tile
			
			if tile == 1 then
				table.insert(soldiers, Soldier:new(1, ix, iy))
			elseif tile == 2 then
				table.insert(soldiers, Soldier:new(2, ix, iy))
			elseif tile == 3 then
				table.insert(soldiers, Soldier:new(3, ix, iy))
			end
		end
	end
	
	return soldiers
end