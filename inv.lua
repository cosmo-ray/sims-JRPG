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
	 posInfo.type = t

	 invScreen:new_text(1 + pos, 0 + yThreshold,
			    Entity.new_string(furn[t][i].name:to_string()))
	 invScreen:new_img(pos, 20 + yThreshold, furn[t][i].path:to_string(),
			   furn[t][i].rect)
	 invScreen:new_text(1 + pos, 120 + yThreshold,
			    Entity.new_string(furn[t][i].price:to_string() .. "$"))
	 pos = pos + objWSize
      end
   end
   return furn[t]:len()
end

function shoop_cursor_move(main, invScreen, move)
   invScreen.current_pos = invScreen.current_pos + move

   if invScreen.current_pos < 0 then
      invScreen.current_pos = invScreen.nbFurniture + -1
   elseif invScreen.current_pos >= invScreen.nbFurniture then
      invScreen.current_pos = 0
   end
   local realPos = Pos.wrapp(invScreen.posInfo[invScreen.current_pos:to_int()].pos)
   CanvasObj.wrapp(invScreen.rect):set_pos(realPos:x(), realPos:y())
end

function init_clothes_shop_furnitur(main, invScreen)
   invScreen.nbFurniture = 0
   invScreen.posInfo = {}
   invScreen.resources = {}
   invScreen = Canvas.wrapp(invScreen)

   for i = 0, invScreen.ent.objs:len() do
      invScreen:pop_back()
   end

   local j = 0
   invScreen.ent.resources = {}
   for i = 0, main.clothes:len() do
      if main.clothes[i] and main.clothes[i].is_buy:to_int() == 0 then
	 invScreen.ent.resources[j] = main.clothes[i].resources[0]
	 invScreen:new_obj(j * objWSize, 20, j)
	 invScreen:new_text(j * objWSize, 0,
			    Entity.new_string(main.clothes[i].price:to_string() .. "$"))

	 j = j + 1
      end
   end
end

function init_shop_furnitur(main, invScreen, furn)
   invScreen.nbFurniture = 0
   invScreen.posInfo = {}

   invScreen = Canvas.wrapp(invScreen)

   for i = 0, invScreen.ent.objs:len() do
      invScreen:pop_back()
   end

   local nb = display_furniture(furn, invScreen, "bed", 0, 0)
   nb = display_furniture(furn, invScreen, "fridge", nb * objWSize, 0) + nb
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

function shop_buy(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))
   local invScreen = main.invScreen
   local newObj = invScreen.posInfo[invScreen.current_pos:to_int()]
   local mainCanvas = Canvas.wrapp(main.mainScreen)
   local t = newObj.type:to_string()
   local posx = main[t].pos.x
   local posy = main[t].pos.y

   if (main.guy.money - newObj.furn.price < 0) then
      display_text(main, "you're too poor for that", 20, 300)
      return
   end
   mainCanvas:remove(main[t])
   main[t] = mainCanvas:new_img(posx:to_int(), posy:to_int(),
				   newObj.furn.path:to_string(),
				   newObj.furn.rect):cent()
   main[t].stat = newObj.furn.stat
   main.guy.money = main.guy.money - newObj.furn.price
   update_money(main)
end

function cloth_buy(entity)
   print("buy new cloth yaayyyy")
end
