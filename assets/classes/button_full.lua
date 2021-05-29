--[[
ButtonTextP9UDDT
A Button class with text, Pixel, images 9patch (Up, Down, Disabled) and Tooltip
This code is CC0
github: mokalux
v 0.1.6:  2021-05-29 fixed tooltip not disappearing + removed unnecessary sprite + added more params
v 0.1.5:  2020-08-25 replaced font params with ttf params for better control
v 0.1.41: 2020-08-19 added tooltip text scale and color
v 0.1.4:  2020-06-08 removed useless variables + the class was somehow broken :/
v 0.1.3:  2020-03-30 added tooltiptext
v 0.1.2:  2020-03-29 added nine patch
v 0.1.1:  2020-03-28 added pixel
v 0.1.0:  2020-03-28 init (based on the initial gideros generic button class)
]]
--[[
-- SAMPLE
	local mybtn03 = ButtonTextP9UDDT.new({
		pixelcolorup=0x123456, pixelpaddingx=196, pixelpaddingy=16,
		text="     XXX     ", ttf=font01,
		textcolorup=0xA6740C, textcolordown=0xF2B941,
		hover=1,
		tooltiptext="disabled", tooltipoffsetx=96,
		isautoscale=0,
	})
	mybtn03:setDisabled(true)
	mybtn03.text:setText("    GEEL    ")
	mybtn03.params.tooltiptext = "GEEL"
	mybtn03:setPosition(myappwidth/2, 7*myappheight/10)
	self:addChild(mybtn03)
	self.mybtn03:addEventListener("clicked", function()
		-- code
	end)
]]

ButtonTextP9UDDT = Core.class(Sprite)

function ButtonTextP9UDDT:init(xparams, xselector)
	-- the params table
	self.params = xparams or {}
	self.selector = xselector
	-- pixel?
	self.params.pixelcolorup = xparams.pixelcolorup or nil -- color
	self.params.pixelcolordown = xparams.pixelcolordown or nil -- color
	self.params.pixelcolordisabled = xparams.pixelcolordisabled or 0x555555 -- color
	self.params.pixelalpha = xparams.pixelalpha or 1 -- number between 0 and 1
	self.params.pixelscalex = xparams.pixelscalex or 1 -- number
	self.params.pixelscaley = xparams.pixelscaley or 1 -- number
	self.params.pixelpaddingx = xparams.pixelpaddingx or 12 -- number
	self.params.pixelpaddingy = xparams.pixelpaddingy or 12 -- number
	-- textures?
	self.params.imgup = xparams.imgup or nil -- img tex up path
	self.params.imgdown = xparams.imgdown or nil -- img tex down path
	self.params.imgdisabled = xparams.imgdisabled or nil -- img tex disabled path
	self.params.imagealpha = xparams.imagealpha or 1 -- number between 0 and 1
	self.params.imgscalex = xparams.imgscalex or 1 -- number
	self.params.imgscaley = xparams.imgscaley or 1 -- number
	self.params.imagepaddingx = xparams.imagepaddingx or nil -- number (nil = auto, the image width)
	self.params.imagepaddingy = xparams.imagepaddingy or nil -- number (nil = auto, the image height)
	-- text?
	self.params.text = xparams.text or nil -- string
	self.params.ttf = xparams.ttf or nil -- ttf
	self.params.textcolorup = xparams.textcolorup or 0x0 -- color
	self.params.textcolordown = xparams.textcolordown or self.params.textcolorup -- color
	self.params.textcolordisabled = xparams.textcolordisabled or 0x777777 -- color
	self.params.textalpha = xparams.textalpha or 1 -- number between 0 and 1
	self.params.textscalex = xparams.textscalex or 1 -- number
	self.params.textscaley = xparams.textscaley or self.params.textscalex -- number
	-- tool tip?
	self.params.tooltiptext = xparams.tooltiptext or nil -- string
	self.params.tooltipttf = xparams.tooltipttf or nil -- ttf
	self.params.tooltiptextcolor = xparams.tooltiptextcolor or 0xff00ff -- color
	self.params.tooltiptextscale = xparams.tooltiptextscale or 3 -- number
	self.params.tooltipoffsetx = xparams.tooltipoffsetx or 0 -- number
	self.params.tooltipoffsety = xparams.tooltipoffsety or 0 -- number
	-- EXTRAS
	self.params.hover = xparams.hover or 0 -- number 0 or 1 (default 0 = false)
	self.params.isautoscale = xparams.isautoscale or 1 -- number 0 or 1 (default 1 = true)
	-- LET'S GO!
	if self.params.hover == 0 then self.params.hover = false else self.params.hover = true end
	if self.params.isautoscale == 0 then self.params.isautoscale = false else self.params.isautoscale = true end
	-- warnings
	if not self.params.imgup and not self.params.imgdown and not self.params.imgdisabled
		and not self.params.pixelcolorup and not self.params.text and not self.params.tooltiptext then
		print("*** WARNING: YOUR BUTTON IS EMPTY! ***")
	else
		-- button sprite holder
		self.sprite = Sprite.new()
		self:addChild(self.sprite)
		self:setButton()
	end
	-- update visual state
	self.isfocused = false
	self.isdisabled = false
	self.ismoving = false
	self.onenter = false
	self:updateVisualState()
	-- event listeners
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.MOUSE_HOVER, self.onMouseHover, self)
	if not self.params.hover and not self.params.tooltiptext then
		print("mouse hover event listener removed")
		self:removeEventListener(Event.MOUSE_HOVER, self.onMouseHover, self)
	end
end

-- FUNCTIONS
function ButtonTextP9UDDT:setButton()
	local textwidth, textheight
	local bmps = {}
	-- text
	if self.params.text then
		self.text = TextField.new(self.params.ttf, self.params.text, self.params.text)
		self.text:setAnchorPoint(0.5, 0.5)
		self.text:setScale(self.params.textscalex, self.params.textscaley)
		self.text:setTextColor(self.params.textcolorup)
		self.text:setAlpha(self.params.textalpha)
		textwidth, textheight = self.text:getWidth(), self.text:getHeight()
	end
	-- first add pixel
	if self.params.pixelcolorup then
		if self.params.isautoscale and self.params.text then
			self.pixel = Pixel.new(
				self.params.pixelcolorup, self.params.pixelalpha,
				textwidth + self.params.pixelpaddingx,
				textheight + self.params.pixelpaddingy)
		else
			self.pixel = Pixel.new(
				self.params.pixelcolorup, self.params.pixelalpha,
				self.params.pixelpaddingx,
				self.params.pixelpaddingy)
		end
		self.pixel:setAnchorPoint(0.5, 0.5)
		self.pixel:setScale(self.params.pixelscalex, self.params.pixelscaley)
		self.sprite:addChild(self.pixel)
	end
	-- then images
	if self.params.imgup then
		local texup = Texture.new(self.params.imgup)
		if self.params.isautoscale and self.params.text then
			self.bmpup = Pixel.new(texup,
				textwidth + (self.params.imagepaddingx),
				textheight + (self.params.imagepaddingy))
		else
			self.bmpup = Pixel.new(texup, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpup] = 1
	end
	if self.params.imgdown then
		local texdown = Texture.new(self.params.imgdown)
		if self.params.isautoscale and self.params.text then
			self.bmpdown = Pixel.new(texdown,
				textwidth + (self.params.imagepaddingx),
				textheight + (self.params.imagepaddingy))
		else
			self.bmpdown = Pixel.new(texdown, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpdown] = 2
	end
	if self.params.imgdisabled then
		local texdisabled = Texture.new(self.params.imgdisabled)
		if self.params.isautoscale and self.params.text then
			self.bmpdisabled = Pixel.new(texdisabled,
				textwidth + (self.params.imagepaddingx),
				textheight + (self.params.imagepaddingy))
		else
			self.bmpdisabled = Pixel.new(texdisabled, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpdisabled] = 3
	end
	-- image batch
	for k, _ in pairs(bmps) do
		k:setAnchorPoint(0.5, 0.5)
		k:setAlpha(self.params.imagealpha)
		local split = 9 -- magik number
		k:setNinePatch(math.floor(k:getWidth()/split), math.floor(k:getWidth()/split),
			math.floor(k:getHeight()/split), math.floor(k:getHeight()/split))
		self.sprite:addChild(k)
	end
	-- finally add text on top of all
	if self.params.text then self.sprite:addChild(self.text) end
	-- and the tooltip text
	if self.params.tooltiptext then
		self.tooltiptext = TextField.new(self.params.tooltipttf, self.params.tooltiptext, self.params.tooltiptext)
		self.tooltiptext:setScale(self.params.tooltiptextscale)
		self.tooltiptext:setTextColor(self.params.tooltiptextcolor)
		self.tooltiptext:setVisible(false)
--		self.sprite:addChild(self.tooltiptext) -- best to add here?
		self:addChild(self.tooltiptext) -- or here to self?
	end
end

-- VISUAL STATE
function ButtonTextP9UDDT:updateVisualState()
	if self.isdisabled then -- button is isdisabled
		if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(true) end
		if self.params.pixelcolordisabled ~= nil then self.pixel:setColor(self.params.pixelcolordisabled) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordisabled) end
	elseif self.isfocused then -- button pressed or hovered
		if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(true) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
		if self.params.pixelcolordown ~= nil then self.pixel:setColor(self.params.pixelcolordown) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordown) end
	else -- button up state + not hovered
		if self.params.imgup ~= nil then self.bmpup:setVisible(true) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
		if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolorup) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolorup) end
	end

--	if self.params.tooltiptext and not self.isdisabled then -- you can choose this option: hides the tooltip when button is isdisabled
	if self.params.tooltiptext then -- or this option: shows the tooltip even when button is isdisabled
		if self.isfocused then -- button hovered
			if self.isdisabled then self.tooltiptext:setText("( "..self.params.tooltiptext.." )")
			else self.tooltiptext:setText(self.params.tooltiptext)
			end
			self.tooltiptext:setVisible(true)
		else -- button no hover state
			self.tooltiptext:setVisible(false)
		end
	end
end

-- isdisabled
function ButtonTextP9UDDT:setDisabled(xdisabled)
	if self.isdisabled == xdisabled then return end
	self.isdisabled = xdisabled
	self.isfocused = false
	self:updateVisualState()
end
function ButtonTextP9UDDT:isDisabled() return self.isdisabled end

-- MOUSE LISTENERS
function ButtonTextP9UDDT:onMouseDown(e)
	if self:hitTestPoint(e.x, e.y) and self:getParent():isVisible() then
		self.isfocused = true
		self.isclicked = true
		self:updateVisualState()
		e:stopPropagation()
	end
end
function ButtonTextP9UDDT:onMouseMove(e)
	if self:hitTestPoint(e.x, e.y) and self:getParent():isVisible() then self.isfocused = true
	else self.isfocused = false
	end
	self:updateVisualState()
end
function ButtonTextP9UDDT:onMouseUp(e)
	if self.isfocused and self.isclicked then
		self.isfocused = false
		self.isclicked = false
		if not self.isdisabled then self:dispatchEvent(Event.new("clicked")) end
		e:stopPropagation()
	end
end
function ButtonTextP9UDDT:onMouseHover(e)
	if self.sprite:hitTestPoint(e.x, e.y) and self.sprite:isVisible() then
		if self.params.tooltiptext then
			self.tooltiptext:setPosition(self.sprite:globalToLocal(e.x + self.params.tooltipoffsetx, e.y + self.params.tooltipoffsety))
		end
		self.isfocused = true
		self.onenter = not self.onenter
		if not self.onenter then self.ismoving = true end
		self:getParent().selector = self.selector
		self:getParent():selectionSfxM()
	else
		self.isfocused = false
		self.ismoving = false
		self.onenter = false
	end
	self:updateVisualState()
end
