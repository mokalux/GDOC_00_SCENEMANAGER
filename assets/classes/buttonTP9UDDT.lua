--[[
ButtonTP9UDDT
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
	local mybtn03 = ButtonTP9UDDT.new({
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

ButtonTP9UDDT = Core.class(Sprite)

function ButtonTP9UDDT:init(xparams, xselector)
	-- the params table
	self.params = xparams or {}
	self.selector = xselector
	-- button
	-- add btn color up and down? sprite:setColorTransform(255/255, ...)
	self.params.alphaup = xparams.alphaup or 1 -- number between 0 and 1
	self.params.alphadown = xparams.alphadown or self.params.alphaup -- number between 0 and 1
	self.params.scalexup = xparams.scalexup or nil -- number
	self.params.scaleyup = xparams.scaleyup or self.params.scalexup -- number
	self.params.scalexdown = xparams.scalexdown or self.params.scalexup -- number
	self.params.scaleydown = xparams.scaleydown or self.params.scalexdown -- number
	-- pixel?
	self.params.pixelcolorup = xparams.pixelcolorup or nil -- color
	self.params.pixelcolordown = xparams.pixelcolordown or self.params.pixelcolorup -- color
	self.params.pixelcolordisabled = xparams.pixelcolordisabled or 0x555555 -- color
	self.params.pixelalphaup = xparams.pixelalphaup or 1 -- number between 0 and 1
	self.params.pixelalphadown = xparams.pixelalphadown or self.params.pixelalphaup -- number between 0 and 1
	self.params.pixelscalexup = xparams.pixelscalexup or 1 -- number
	self.params.pixelscaleyup = xparams.pixelscaleyup or self.params.pixelscalexup -- number
	self.params.pixelscalexdown = xparams.pixelscalexdown or self.params.pixelscalexup -- number
	self.params.pixelscaleydown = xparams.pixelscaleydown or self.params.pixelscalexdown -- number
	self.params.pixelpaddingx = xparams.pixelpaddingx or 32 -- number
	self.params.pixelpaddingy = xparams.pixelpaddingy or self.params.pixelpaddingx -- number
	-- textures?
	self.params.imgup = xparams.imgup or nil -- img tex up path
	self.params.imgdown = xparams.imgdown or nil -- img tex down path
	self.params.imgdisabled = xparams.imgdisabled or nil -- img tex disabled path
	self.params.imagealphaup = xparams.imagealphaup or 1 -- number between 0 and 1
	self.params.imagealphadown = xparams.imagealphadown or self.params.imagealphaup -- number between 0 and 1
	self.params.imgscalexup = xparams.imgscalexup or 1 -- number
	self.params.imgscaleyup = xparams.imgscaleyup or self.params.imgscalexup -- number
	self.params.imgscalexdown = xparams.imgscalexdown or self.params.imgscalexup -- number
	self.params.imgscaleydown = xparams.imgscaleydown or self.params.imgscalexdown -- number
	self.params.imagepaddingx = xparams.imagepaddingx or nil -- number (nil = auto, the image width)
	self.params.imagepaddingy = xparams.imagepaddingy or nil -- number (nil = auto, the image height)
	-- text?
	self.params.text = xparams.text or nil -- string
	self.params.ttf = xparams.ttf or nil -- ttf
	self.params.textcolorup = xparams.textcolorup or 0x0 -- color
	self.params.textcolordown = xparams.textcolordown or self.params.textcolorup -- color
	self.params.textcolordisabled = xparams.textcolordisabled or 0x777777 -- color
	self.params.textalphaup = xparams.textalphaup or 1 -- number between 0 and 1
	self.params.textalphadown = xparams.textalphaup or self.params.textalphaup -- number between 0 and 1
	self.params.textscalexup = xparams.textscalexup or 1 -- number
	self.params.textscaleyup = xparams.textscaleyup or self.params.textscalexup -- number
	self.params.textscalexdown = xparams.textscalexdown or self.params.textscalexup -- number
	self.params.textscaleydown = xparams.textscaleydown or self.params.textscalexdown -- number
	-- tool tip?
	self.params.tooltiptext = xparams.tooltiptext or nil -- string
	self.params.tooltipttf = xparams.tooltipttf or nil -- ttf
	self.params.tooltiptextcolor = xparams.tooltiptextcolor or 0xff00ff -- color
	self.params.tooltiptextscale = xparams.tooltiptextscale or 3 -- number
	self.params.tooltipoffsetx = xparams.tooltipoffsetx or 0 -- number
	self.params.tooltipoffsety = xparams.tooltipoffsety or 0 -- number
	-- audio?
	self.params.channel = xparams.channel or nil -- sound channel
	self.params.sound = xparams.sound or nil -- sound fx
	-- EXTRAS
	self.params.hover = xparams.hover and false or true -- boolean (default = true)
	self.params.isautoscale = xparams.isautoscale and false or true -- boolean (default = true)
	self.params.fun = xparams.fun or nil -- function
	-- warnings, errors
	if not self.params.imgup and not self.params.imgdown and not self.params.imgdisabled
		and not self.params.pixelcolorup and not self.params.text and not self.params.tooltiptext then
		print("*** ERROR ***", "YOUR BUTTON IS EMPTY!", self.selector)
		return
	end
	if self.params.sound and not self.params.channel then
		print("*** ERROR ***", "YOU HAVE A SOUND BUT NO CHANNEL!", self.selector)
		return
	end
	if self.params.fun ~= nil and type(self.params.fun) ~= "function" then
		print("*** ERROR ***", "YOU ARE NOT PASSING A FUNCTION", self.selector)
		return
	end
	-- button sprite holder
	self.sprite = Sprite.new()
	self:addChild(self.sprite)
	self:setButton()
	-- update visual state
	self.isclicked = nil
	self.isfocused = nil
	self.ishovered = nil
	self.isdisabled = nil
	self.ismoving = nil
	self.onenter = nil
	self.iskeyboard = nil
	-- let's go
	self:updateVisualState()
	-- event listeners
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.MOUSE_HOVER, self.onMouseHover, self)
	if not self.params.hover and not self.params.tooltiptext then
		self:removeEventListener(Event.MOUSE_HOVER, self.onMouseHover, self)
	end
end

-- FUNCTIONS
function ButtonTP9UDDT:setButton()
	local textwidth, textheight
	local bmps = {}
	-- text
	if self.params.text then
		self.text = TextField.new(self.params.ttf, self.params.text, self.params.text)
		self.text:setAnchorPoint(0.5, 0.5)
		self.text:setScale(self.params.textscalexup, self.params.textscaleyup)
		self.text:setTextColor(self.params.textcolorup)
		self.text:setAlpha(self.params.textalphaup)
		textwidth, textheight = self.text:getWidth(), self.text:getHeight()
	end
	-- first add pixel
	if self.params.pixelcolorup then
		if self.params.isautoscale and self.params.text then
			self.pixel = Pixel.new(
				self.params.pixelcolorup, self.params.pixelalphaup,
				textwidth + self.params.pixelpaddingx,
				textheight + self.params.pixelpaddingy)
		else
			self.pixel = Pixel.new(
				self.params.pixelcolorup, self.params.pixelalphaup,
				self.params.pixelpaddingx,
				self.params.pixelpaddingy)
		end
		self.pixel:setAnchorPoint(0.5, 0.5)
		self.pixel:setScale(self.params.pixelscalexup, self.params.pixelscaleyup)
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
		k:setAlpha(self.params.imagealphaup)
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
		self:addChild(self.tooltiptext) -- or here to self?
	end
end

-- isdisabled
function ButtonTP9UDDT:setDisabled(xdisabled)
	if self.isdisabled == xdisabled then return end
	self.isdisabled = xdisabled
	self.isfocused = false
	self:updateVisualState()
end
function ButtonTP9UDDT:isDisabled() return self.isdisabled end

-- VISUAL STATE
function ButtonTP9UDDT:updateVisualState()
	if self.isdisabled then -- button is isdisabled
		if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(true) end
		if self.params.pixelcolordisabled ~= nil then self.pixel:setColor(self.params.pixelcolordisabled) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordisabled) end
	elseif self.isfocused then -- button pressed or hovered
		if self.params.scalexdown ~= nil then self:setScale(self.params.scalexdown, self.params.scaleydown) end
		if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(true) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
		if self.params.pixelcolordown ~= nil then self.pixel:setColor(self.params.pixelcolordown, self.params.pixelalphadown) self.pixel:setScale(self.params.pixelscalexdown, self.params.pixelscaleydown) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordown) self.text:setScale(self.params.textscalexdown, self.params.textscaleydown) end
	else -- button up state & not hovered
		if self.params.scalexup ~= nil then self:setScale(self.params.scalexup, self.params.scaleyup) end
		if self.params.imgup ~= nil then self.bmpup:setVisible(true) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
		if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolorup, self.params.pixelalphaup) self.pixel:setScale(self.params.pixelscalexup, self.params.pixelscaleyup) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolorup) self.text:setScale(self.params.textscalexup, self.params.textscaleyup) end
	end

--	if self.params.tooltiptext and not self.isdisabled then -- shows tooltip when button is not disabled
	if self.params.tooltiptext then -- shows tooltip even when button is disabled
		if self.isfocused and (self.ishovered or self.iskeyboard) then -- shows tooltip for mouse and keyboard
--		if self.isfocused and self.ishovered and not self.iskeyboard then -- shows tooltip for mouse but not keyboard
			if self.isdisabled then self.tooltiptext:setText("( "..self.params.tooltiptext.." )")
			else self.tooltiptext:setText(self.params.tooltiptext)
			end
			self.tooltiptext:setVisible(true)
		else -- button is not hovered
			self.tooltiptext:setVisible(false)
		end
		if self.iskeyboard then -- reposition the tooltip for the keyboard navigation
			self.tooltiptext:setPosition(self:getParent():getX() + self.params.tooltipoffsetx, self:getParent():getY() + self.params.tooltipoffsety)
		end
	end
end

-- MOUSE LISTENERS
function ButtonTP9UDDT:onMouseDown(e)
--	if self.sprite:hitTestPoint(e.x, e.y, true) then -- XXX use this code when hitTestPoint bug is fixed!
	if self.sprite:hitTestPoint(e.x, e.y) and self:getParent():isVisible() then -- XXX
		self.isfocused = true
		self.isclicked = true
		self:updateVisualState()
--		if self.params.fun then self.params.fun(self:getParent()) end -- YOU CAN ADD THIS HERE
		e:stopPropagation()
	else
		self.isfocused = false
		self.isclicked = false
	end
	self.iskeyboard = false
end
function ButtonTP9UDDT:onMouseMove(e)
--	if self.sprite:hitTestPoint(e.x, e.y, true) then -- XXX use this code when hitTestPoint bug is fixed!
	if self.sprite:hitTestPoint(e.x, e.y) and self:getParent():isVisible() then -- XXX
		self.isfocused = true
		self.isclicked = true
		if self.selector then self:getParent().selector = self.selector end
--		if self.params.fun then self.params.fun(self:getParent()) end -- OR HERE?
		e:stopPropagation() -- new 2021/05/31 (1)
	else
		self.isfocused = false
		self.isclicked = false
	end
	self.iskeyboard = false
	self:updateVisualState()
end
function ButtonTP9UDDT:onMouseUp(e)
	if self.isfocused and self.isclicked then
		self.isclicked = false
		if not self.isdisabled then self:dispatchEvent(Event.new("clicked")) end
--		if self.params.fun then self.params.fun(self:getParent()) end -- OR EVEN HERE?
		e:stopPropagation()
	end
end
function ButtonTP9UDDT:onMouseHover(e)
--	if self.sprite:hitTestPoint(e.x, e.y, true) then -- XXX use this code when hitTestPoint bug is fixed!
	if self.sprite:hitTestPoint(e.x, e.y) and self.sprite:isVisible() then -- XXX
--		print("hover", self.selector, e.x, e.y) -- for debugging
		if self.params.tooltiptext then
			self.tooltiptext:setPosition(self.sprite:globalToLocal(e.x + self.params.tooltipoffsetx, e.y + self.params.tooltipoffsety))
		end
		self.isfocused = true
		self.ishovered = true
		if self.selector then
			-- this bit prevents the sound to repeat itself (which is very annoying) when button is hovered
			self.onenter = not self.onenter
			if not self.onenter then self.ismoving = true end
			-- here we update the button id (selector) of the parent, for keyboard navigation if any
			self:getParent().selector = self.selector
			if self.params.channel ~= nil and self.params.sound ~= nil then self:selectionSfxM() end
		end
--		if self.params.fun then self.params.fun(self:getParent()) end -- HERE COULD ALSO BE USEFUL?
		e:stopPropagation() -- new 2021/05/31 (2)
	else
		self.isfocused = false
		self.ishovered = false
		self.ismoving = false
		self.onenter = false
	end
	self.iskeyboard = false
	self:updateVisualState()
end

-- audio
function ButtonTP9UDDT:selectionSfxM()
	-- mouse sfx
	if not self.ismoving then
		if not self.params.channel:isPlaying() then self.params.channel = self.params.sound:play() end
	end
end
