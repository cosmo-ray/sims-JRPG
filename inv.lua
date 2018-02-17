local objWSize = 110
local objHSize = 140

function display_furniture(furn, invScreen, t, xThreshold, yThreshold)
   local pos = 0 + xThreshold

   for i = 0, furn[t]:len() do
      if furn[t][i] then
	 invScreen.ent.posInfo[invScreen.ent.nbFurniture:to_int()] = {}
	 local posInfo = invScreen.ent.posInfo[invScreen.ent.nbFurniture:to_int()]
	 invScreen.ent.nbFurniture = invScreen.ent.nbFurniture + 1
	 posInfo.furn = furn[t][i]
	 posInfo.pos = Pos.new(pos, yThreshold).ent

	 invScreen:new_text(1 + pos, 0 + yThreshold,
			    Entity.new_string(furn[t][i].name:to_string()))
	 invScreen:new_img(pos, 20 + yThreshold, furn[t][i].path:to_string(),
			   furn[t][i].rect)
	 invScreen:new_text(1 + pos, 120 + yThreshold,
			    Entity.new_string(furn[t][i].price:to_string()))
	 pos = pos + objWSize
      end
   end
   return furn[t]:len()
end

function shoop_cursor_move(main, invScreen, move)
   invScreen.current_pos = invScreen.current_pos + move

   if invScreen.current_pos < 0 then
      invScreen.current_pos = invScreen.nbFurniture + -1
   elseif invScreen.current_pos == invScreen.nbFurniture then
      invScreen.current_pos = 0
   end
   local realPos = Pos.wrapp(invScreen.posInfo[invScreen.current_pos:to_int()].pos)
   print(realPos:tostring())
   CanvasObj.wrapp(invScreen.rect):set_pos(realPos:x(), realPos:y())
end

function init_inv_furnitur(main, invScreen)
   local furn = main.furniture

   invScreen.nbFurniture = 0
   invScreen.posInfo = {}

   invScreen = Canvas.wrapp(invScreen)

   for i = 0, invScreen.ent.objs:len() do
      invScreen:pop_back()
   end

   local nb = display_furniture(furn, invScreen, "beds", 0, 0)
   display_furniture(furn, invScreen, "stove", nb * objWSize, 0)
   nb = display_furniture(furn, invScreen, "wc", 0, objHSize)
   nb = display_furniture(furn, invScreen, "shower", nb * objWSize, objHSize) + nb
   display_furniture(furn, invScreen, "radio", nb * objWSize, objHSize)
   local rect = Entity.new_array()
   rect[0] = Pos.new(objWSize, objHSize).ent;
   rect[1] = "rgba: 127 0 0 100";
   invScreen.ent.rect = invScreen:new_rect(invScreen.ent.posInfo[0].pos.x:to_int(),
					   invScreen.ent.posInfo[0].pos.x:to_int(),
					   rect):cent()
   invScreen.ent.current_pos = 0
end

function inv_buy(entity)
   print("buy stuff")
end
