function init_jims(mod)
   Widget.new_subtype("jims", "create_jims")
   Entity.wrapp(mod).fight_time = Entity.new_func("swapToFight")
   Entity.wrapp(mod).house_time = Entity.new_func("swapToHouse")
   Entity.wrapp(mod).attack = Entity.new_func("jimsFSAttackGuy")
   --Entity.wrapp(mod).inventary_time = Entity.new_func("swapToInv")
end

function jims_action(entity, eve, arg)
   entity = Entity.wrapp(entity)
   eve = Event.wrapp(eve)

   while eve:is_end() == false do
      if eve:type() == YKEY_DOWN then
	 if eve:key() == Y_ESC_KEY then
	    yFinishGame()
	    return YEVE_ACTION
	 end
      end
      eve = eve:next()
   end
   if doAnimation(entity) then
      return YEVE_ACTION
   end
   return YEVE_NOTHANDLE
end

function swapToHouse(entity)
   local mainMenu = Entity.wrapp(ywCntWidgetFather(entity))
   local main = ywCntWidgetFather(mainMenu:cent())

   setMenuAction(mainMenu, 0, "fight now", "jims.fight_time")
   setMenuAction(mainMenu, 1, "quit", "FinishGame")

   ywReplaceEntry(main, 0, Entity.wrapp(main).mainScreen:cent())
   return YEVE_ACTION
end

function init_room(ent,mainCanvas)
    --mainCanvas:new_img(0, 0, "Male_basic.png", Rect.new(25, 25, 50, 50))
    ent.bed = mainCanvas:new_img(0, 0, "open_tileset.png", Rect.new(416, 102, 64, 90))
    ent.fridge = mainCanvas:new_img(100, 0, "open_tileset.png", Rect.new(0, 97, 32, 61))
    ent.stove = mainCanvas:new_img(132, 17, "open_tileset.png", Rect.new(32, 114, 31, 44))
    ent.wc = mainCanvas:new_img(500, 17, "open_tileset.png", Rect.new(3, 293, 27, 40))
    ent.shower = mainCanvas:new_img(550, 17, "open_tileset.png", Rect.new(64, 256, 32, 90))
    ent.radio = mainCanvas:new_img(300, 17, "open_tileset.png", Rect.new(192, 108, 32, 52))
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
   return YEVE_ACTION
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
   Entity.new_func("jims_action", ent, "action")
   ent.background = "rgba: 127 127 127 255"
   local mainCanvas = Canvas.new_entity(entity, "mainScreen")
   local fightCanvas = Canvas.new_entity(entity, "fightScreen")
   ent.entries[0] = mainCanvas.ent  -- game screen
   ent.entries[0].size = 70
   ent.event_forwarding = "under mouse"
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
   --mainCanvas:new_img(0, 0, "Male_basic.png", Rect.new(25, 25, 50, 50))
   local ret = conntainer:new_wid()
   local mn = menu_cnt.ent.entries[0]
   swapToHouse(mn:cent())
   init_room(ent, mainCanvas)
   return ret
end
