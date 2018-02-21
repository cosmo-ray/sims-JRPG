function init_jims(mod)
   Widget.new_subtype("jims", "create_jims")

   Entity.wrapp(mod).fight_time = Entity.new_func("swapToFight")
   Entity.wrapp(mod).house_time = Entity.new_func("swapToHouse")
   Entity.wrapp(mod).shop_time = Entity.new_func("swapToShop")
   Entity.wrapp(mod).attack = Entity.new_func("jimsFSAttackGuy")
end

function display_text_timer(main, anim)
   anim = Entity.wrapp(anim)
   main = Entity.wrapp(main)

   anim.animation_frame = anim.animation_frame + 1
   if anim.animation_frame > 30 then
      Canvas.wrapp(anim.wid):remove(anim.text)
      endAnimation(main, "txt_anim")
   end
end

function display_text(main, txt, x, y)
   local canvas = Canvas.wrapp(main.entries[0])

   local anim = startAnimation(main:cent(),
			       Entity.new_func("display_text_timer"), "txt_anim")
   anim.text = canvas:new_text(x, y, Entity.new_string(txt)):cent()
   anim.wid = canvas.ent
end

function jims_action(entity, eve, arg)
   entity = Entity.wrapp(entity)
   eve = Event.wrapp(eve)
   local move = entity.move
   local guy = entity.guy
   local return_not_handle = false

   while eve:is_end() == false do
      if eve:type() == YKEY_DOWN then
	 if eve:key() == Y_ESC_KEY then
	    yFinishGame()
	    return YEVE_ACTION
	 elseif eve:key() == Y_W_KEY then move.up_down = -1
         elseif eve:key() == Y_S_KEY then move.up_down = 1
         elseif eve:key() == Y_A_KEY then move.left_right = -1
         elseif eve:key() == Y_D_KEY then move.left_right = 1
	 elseif eve:key() == Y_UP_KEY or eve:key() == Y_DOWN_KEY then
	    return_not_handle = true
	 elseif eve:key() == Y_LEFT_KEY then
	    move.left_right = -1
	 elseif eve:key() == Y_RIGHT_KEY then
	    move.left_right = 1
         end
      elseif eve:type() == YKEY_UP then
         if eve:is_key_up() or eve:is_key_down() then move.up_down = 0
         elseif eve:is_key_left() or eve:is_key_right() then
	    move.left_right = 0
         end

      end
      eve = eve:next()
   end

   doAnimation(entity, "txt_anim")
   if guy.movable:to_int() == 1 and (move.up_down ~= Entity.new_int(0) or
				     move.left_right ~= Entity.new_int(0)) then
      CanvasObj.wrapp(entity.guy.canvas):move(Pos.new(5 * move.left_right,
						      5 * move.up_down))
      if return_not_handle then
	 return YEVE_NOTHANDLE
      end
      return YEVE_ACTION
   end
   if doAnimation(entity, "cur_anim") then
      return YEVE_ACTION
   end
   if entity.invScreen:cent() == entity.entries[0]:cent() then

      if move.up_down:to_int() ~= 0 then
	 move.left_right = move.up_down * 4
	 move.up_down = 0
      end

      if move.left_right:to_int() ~= 0 then
	 shoop_cursor_move(entity, entity.invScreen, move.left_right:to_int())
	 move.left_right = 0
	 return YEVE_ACTION
      end
   end
   return YEVE_NOTHANDLE
end

function sleep(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))

   statAdd(main.guy, "energy", main.bed.stat.energy)
   statAdd(main.guy, "hygien", -2)
   statAdd(main.guy, "hunger", -5)
   statAdd(main.guy, "bladder", -2)
   statAdd(main.guy, "fun", -2)

end

function wash_yourself(entity)
    local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
    local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))

    statAdd(main.guy, "hygien", main.shower.stat.hygien)
    statAdd(main.guy, "hunger", -2)
    statAdd(main.guy, "bladder", -2)
    statAdd(main.guy, "energy", -2)
    statAdd(main.guy, "fun", -2)
 end

function have_fun(entity)
    local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
    local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))

    statAdd(main.guy, "fun", main.radio.stat.fun)
    statAdd(main.guy, "hygien", -2)
    statAdd(main.guy, "hunger", -2)
    statAdd(main.guy, "bladder", -2)
    statAdd(main.guy, "energy", -2)
end

function eat(entity)
    local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
    local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))

    statAdd(main.guy, "hunger", main.fridge.stat.food)
    statAdd(main.guy, "hygien", -2)
    statAdd(main.guy, "bladder", -2)
    statAdd(main.guy, "energy", -2)
    statAdd(main.guy, "fun", -2)
end

function go_to_the_toilet(entity)
    local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
    local main = Entity.wrapp(ywCntWidgetFather(mainMenu:cent()))

    statAdd(main.guy, "bladder", main.wc.stat.bladder)
    statAdd(main.guy, "hygien", -2)
    statAdd(main.guy, "hunger", -2)
    statAdd(main.guy, "energy", -2)
    statAdd(main.guy, "fun", -2)
end

function swapToHouse(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = ywCntWidgetFather(mainMenu:cent())

   setMenuAction(mainMenu, 0, "fight now", "jims.fight_time")
   setMenuAction(mainMenu, 1, "buy stuff", "jims.shop_time")
   setMenuAction(mainMenu, 2, "sleep", Entity.new_func("sleep"))
   setMenuAction(mainMenu, 3, "wash yourself", Entity.new_func("wash_yourself"))
   setMenuAction(mainMenu, 4, "have_fun", Entity.new_func("have_fun"))
   setMenuAction(mainMenu, 5, "eat", Entity.new_func("eat"))
   setMenuAction(mainMenu, 6, "go_to_the_toilet", Entity.new_func("go_to_the_toilet"))
   setMenuAction(mainMenu, 7, "quit", "FinishGame")

   Entity.wrapp(main).guy.movable = 1

   ywReplaceEntry(main, 0, Entity.wrapp(main).mainScreen:cent())
   return YEVE_ACTION
end

function add_furniture(main, furn_type, t, rect, path, price, name)
   local ft = main[furn_type][t]
   local ftlen = ft:len()

   ft[ftlen] = {}
   ft[ftlen].rect = rect:cent()
   ft[ftlen].path = path
   ft[ftlen].price = price
   ft[ftlen].name = name
   return ft[ftlen]
end

function init_furniture(main)
   main.furniture = {}
   main.furniture.bed = {}
   main.furniture.fridge = {}
   main.furniture.stove = {}
   main.furniture.wc = {}
   main.furniture.shower = {}
   main.furniture.radio = {}

   -- bed time
   add_furniture(main, "furniture", "bed",
		 Rect.new(416, 102, 64, 90), "open_tileset.png",
		 20, "sleepy Pi")
   add_furniture(main, "furniture", "bed",
		 Rect.new(416, 152, 64, 90), "open_tileset.png",
		 35, "besuto bed")
   add_furniture(main, "furniture", "stove",
		 Rect.new(32, 114, 31, 44), "open_tileset.png",
		 15, "hot steve")
   add_furniture(main, "furniture", "fridge",
		 Rect.new(0, 97, 32, 61), "open_tileset.png",
		 15, "cold maiden")
   add_furniture(main, "furniture", "wc",
		 Rect.new(3, 293, 27, 40), "open_tileset.png",
		 15, "free duke")
   add_furniture(main, "furniture", "shower",
		 Rect.new(64, 256, 32, 90), "open_tileset.png",
		 15, "clean clea")
   add_furniture(main, "furniture", "radio",
		 Rect.new(192, 108, 32, 52), "open_tileset.png",
		 15, "blowing rad")

   main.clothes_furn = {}
   main.clothes_furn.uniform = {}
   add_furniture(main, "clothes_furn", "uniform",
		 Rect.new(192, 108, 32, 52), "open_tileset.png",
		 15, "Worker Suit")
end

function push_resource(resources, path, rect)
   local l = resources:len()

   resources[l] = {}
   resources[l].img = path
   resources[l]["img-src-rect"] = rect:cent()
   return l
end

function init_new_cloth(main, path, isBuy)
   local l = main.clothes:len()

   main.clothes[l] = {}
   main.clothes[l].is_buy = isBuy
   main.clothes[l].resources = {}

   local rs = main.clothes[l].resources
   push_resource(rs, path, Rect.new(16, 652, 32, 51))
   return l
end

function init_pj(main, mainCanvas)
   main.clothes = {}

   init_new_cloth(main, "Female_basic.png", 1)
   init_new_cloth(main, "Female_pyjama.png", 1)
   init_new_cloth(main, "Female_dress.png", 0)

   mainCanvas.resources = main.clothes[1].resources
end

function init_room(ent, mainCanvas)
    ent.bed = mainCanvas:new_img(0, 0, "open_tileset.png", Rect.new(416, 102, 64, 90)):cent()
    ent.fridge = mainCanvas:new_img(100, 0, "open_tileset.png", Rect.new(0, 97, 32, 61)):cent()
    ent.stove = mainCanvas:new_img(132, 17, "open_tileset.png", Rect.new(32, 114, 31, 44)):cent()
    ent.wc = mainCanvas:new_img(500, 17, "open_tileset.png", Rect.new(3, 293, 27, 40)):cent()
    ent.shower = mainCanvas:new_img(550, 17, "open_tileset.png", Rect.new(64, 256, 32, 90)):cent()
    ent.radio = mainCanvas:new_img(300, 17, "open_tileset.png", Rect.new(192, 108, 32, 52)):cent()
    ent.door = mainCanvas:new_img(350, 200, "open_tileset.png", Rect.new(161, 288, 31, 44)):cent()
    ent.wall = mainCanvas:new_img(400, 0, "open_tileset.png", Rect.new(0, 32, 33, 64)):cent()

    ent.bed.stat = {}
    ent.fridge.stat = {}
    ent.shower.stat = {}
    ent.radio.stat = {}
    ent.wc.stat = {}

    ent.bed.stat.energy = 50
    ent.fridge.stat.food = 50
    ent.shower.stat.hygien = 50
    ent.radio.stat.fun = 50
    ent.wc.stat.bladder = 50
end

function setMenuAction(mainMenu, idx, text, action)
   mainMenu.entries[0].entries[idx] = {}
   mainMenu.entries[0].entries[idx].action = action
   mainMenu.entries[0].entries[idx].text = text
end

function cleanMenuAction(mainMenu)
   mainMenu.entries[0].entries = {}
end

function pushBar(statueBar, guy, name)

   local rect = Entity.new_array()
   local bypos = 4 + 20 * statueBar.ent.nbBar

   statueBar:new_text(1, bypos, Entity.new_string(name))
   rect[0] = Pos.new(102, 12).ent;
   rect[1] = "rgba: 0 0 0 255";
   statueBar:new_rect(69, bypos + 1, rect)
   rect = Entity.new_array()
   rect[0] = Pos.new(guy[name]:to_int(), 10).ent;
   rect[1] = "rgba: 255 255 255 255";
   local goodBar = statueBar:new_rect(70, bypos + 2, rect)
   guy.bars[name] = goodBar:cent()
   statueBar.ent.nbBar = statueBar.ent.nbBar + 1
end

function statAdd(guy, name, val)
   local statVal = guy[name]:to_int()

   statVal = statVal + val
   if (statVal > 100) then
      statVal = 100
   elseif statVal < 0 then
      statVal = 0
   end
   guy[name] = statVal
   CanvasObj.wrapp(guy.bars[name]):force_size(Pos.new(statVal, 10))
end

function swapToFight(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = ywCntWidgetFather(mainMenu:cent())
   local fScreen = Entity.wrapp(main).fightScreen
   local widSize = Entity.wrapp(main).mainScreen["wid-pix"]
   local badGuy = Entity.new_array()

   -- bad guy creationg
   badGuy.life = 100
   badGuy.name = "The Work"
   badGuy.attack = Entity.new_func("attackOfTheWork")

   -- init combat
   ywReplaceEntry(main, 0, fScreen:cent())
   cleanMenuAction(mainMenu)
   setMenuAction(mainMenu, 0, "work", "jims.attack")
   jimsFSAddGuy(main, Canvas.wrapp(fScreen), widSize, badGuy)

   Entity.wrapp(main).guy.movable = 0
   return YEVE_ACTION
end

function swapToClothShop(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = ywCntWidgetFather(mainMenu:cent())
   local invScreen = Entity.wrapp(main).invScreen

   ywReplaceEntry(main, 0, invScreen:cent())
   cleanMenuAction(mainMenu)
   setMenuAction(mainMenu, 1, "go to leakea",
		 Entity.new_func("swapToShop"))
   setMenuAction(mainMenu, 2, "go home", "jims.house_time")
   main = Entity.wrapp(main)
   init_shop_furnitur(main, invScreen, main.clothes_furn)
   Entity.wrapp(main).guy.movable = 0
end

function swapToShop(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = ywCntWidgetFather(mainMenu:cent())
   local invScreen = Entity.wrapp(main).invScreen

   -- init combat
   ywReplaceEntry(main, 0, invScreen:cent())
   cleanMenuAction(mainMenu)
   setMenuAction(mainMenu, 0, "buy", Entity.new_func("shop_buy"))
   setMenuAction(mainMenu, 1, "go to cloth shop",
		 Entity.new_func("swapToClothShop"))
   setMenuAction(mainMenu, 2, "go home", "jims.house_time")
   main = Entity.wrapp(main)
   init_shop_furnitur(main, invScreen, main.furniture)
   Entity.wrapp(main).guy.movable = 0
   return YEVE_ACTION
end

function update_money(main)
   local statueBar = Canvas.wrapp(main.menuCnt.entries[2])
   local bypos = 4 + 20 * statueBar.ent.nbBar

   statueBar:pop_back()
   statueBar:new_text(69, bypos,
		      Entity.new_string(main.guy.money:to_int()))
end

function create_jims(entity)
   local container = Container.init_entity(entity, "horizontal")
   local ent = container.ent

   -- create good guy
   ent.guy = {}
   ent.guy.bars = {}
   ent.guy.money = 27
   ent.guy.hygien = 100
   ent.guy.fun = 10
   ent.guy.energy = 100
   ent.guy.hunger = 100
   ent.guy.bladder = 100
   ent.guy.attack = Entity.new_func("attackTheWork")

   -- create widget
   ent["turn-length"] = 10000
   ent.move = {}
   ent.move.up_down = 0
   ent.move.left_right = 0
   Entity.new_func("jims_action", ent, "action")
   Entity.new_func("jims_destroy", ent, "destroy")

   ent.background = "rgba: 255 255 127 255"
   local mainCanvas = Canvas.new_entity(entity, "mainScreen")
   local fightCanvas = Canvas.new_entity(entity, "fightScreen")
   local invCanvas = Canvas.new_entity(entity, "invScreen")
   ent.entries[0] = mainCanvas.ent  -- game screen
   ent.entries[0].size = 70
   ent.current = 1
   -- bottom box
   local menu_cnt = Container.new_entity("vertical", entity, "menuCnt")
   ent.entries[1] = menu_cnt.ent
   menu_cnt.ent.background = "rgba: 127 127 255 255"
   menu_cnt.ent.entries[0] = Menu:new_entity().ent
   menu_cnt.ent.entries[0].background = "rgba: 127 255 255 255"
   menu_cnt.ent.entries[0].size = 40
   menu_cnt.ent.entries[1] = Canvas:new_entity().ent
   menu_cnt.ent.entries[1].background = "rgba: 255 255 255 255"
   menu_cnt.ent.entries[1].size = 20
   menu_cnt.ent.entries[2] = Canvas:new_entity().ent
   menu_cnt.ent.entries[2].size = 40
   menu_cnt.ent.entries[2].background = "rgba: 127 127 255 255"

   local statueBar = Canvas.wrapp(menu_cnt.ent.entries[2])

   statueBar.ent.nbBar = 0
   pushBar(statueBar, ent.guy, "hygien")
   pushBar(statueBar, ent.guy, "fun")
   pushBar(statueBar, ent.guy, "energy")
   pushBar(statueBar, ent.guy, "hunger")
   pushBar(statueBar, ent.guy, "bladder")

   -- money
   local bypos = 4 + 20 * statueBar.ent.nbBar
   statueBar:new_text(1, bypos, Entity.new_string("money"))
   ent.money_pos = bypos
   statueBar:new_text(69, bypos, Entity.new_string(ent.guy.money:to_int()))

   local ret = container:new_wid()
   local mn = menu_cnt.ent.entries[0]
   swapToHouse(mn:cent())
   init_furniture(ent)
   init_room(ent, mainCanvas)
   init_pj(ent, mainCanvas.ent)
   ent.guy.canvas = mainCanvas:new_obj(150, 150, 0):cent()

   return ret
end
