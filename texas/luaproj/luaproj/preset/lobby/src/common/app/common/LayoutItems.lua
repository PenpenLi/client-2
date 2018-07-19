local LayoutItems = class("LayoutItems")

LayoutItems.growthVertical = 0;
LayoutItems.growthHorizontal = 1;

--container 是一个scrollView
function LayoutItems:ctor(container)
	self.container = container;
end

--params.strict
--params.hspace
--params.vspace
--params.growth

function LayoutItems:setParams(params)
	self.params = params;
end

function LayoutItems:addChild(child)
	child:setAnchorPoint(cc.p(0, 1));
	child:addTo(self.container);
end

function LayoutItems:removeAllChildren()
	self.container:removeAllChildren();
end

function LayoutItems:doLayout()
	local strict = self.params.strict.height;

	local hspace = self.params.hspace or 20;
	local vspace = self.params.vspace or 20;

	local rowpos = 0;
	local colpos = strict; 
	local children = self.container:getChildren();

	local w = 0;
	local h = 0;
	--计算需要的长宽
	for _, child in ipairs(children) do
		if w < rowpos + child:getContentSize().width then
			w = rowpos + child:getContentSize().width;
		end

		if h < (strict - colpos) + child:getContentSize().height  then
			h = (strict - colpos) + child:getContentSize().height 
		end
		--竖的
		if self.params.growth == LayoutItems.growthVertical then
			rowpos = rowpos + child:getContentSize().width + hspace;
			--如果排不下了
			if child:getContentSize().width + rowpos > strict then
				colpos = colpos - child:getContentSize().height - vspace;
				rowpos = 0;
			end
		
		--横的
		else
			colpos = colpos - child:getContentSize().height - vspace;
			--如果排不下了
			if child:getContentSize().height > colpos then
				rowpos = rowpos + child:getContentSize().width + hspace;
				colpos = strict;
			end
		end
	end

	strict = math.min(h, strict);
	rowpos = 0;
	colpos = strict; 

	for _, child in ipairs(children) do
		child:setPosition(cc.p(rowpos, colpos));
		--竖的
		if self.params.growth == LayoutItems.growthVertical then
			rowpos = rowpos + child:getContentSize().width + hspace;
			--如果排不下了
			if child:getContentSize().width + rowpos > strict then
				colpos = colpos - child:getContentSize().height - vspace;
				rowpos = 0;
			end
		
		--横的
		else
			colpos = colpos - child:getContentSize().height - vspace;
			--如果排不下了
			if child:getContentSize().height > colpos then
				rowpos = rowpos + child:getContentSize().width + hspace;
				colpos = strict;
			end
		end
	end

	local innerc = self.container:getInnerContainer();
	innerc:setContentSize(cc.size(w, h));
	
	local sz = self.container:getContentSize();
	sz.width = math.min(self.params.strict.width, w);
	sz.height = math.min(self.params.strict.height, h);

	self.container:setContentSize(sz)
	
end

return LayoutItems;