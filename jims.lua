function init_jims(mod)
   Widget.new_subtype("jims", "create_jims")
   Entity.wrapp(mod).fight_time = Entity.new_func("swapToFight")
end

function jims_action(entity, eve, arg)
   local eve = Event.wrapp(eve)

   while eve:is_end() == false do
      if eve:type() == YKEY_DOWN then
	 if eve:key() == Y_ESC_KEY then
	    yFinishGame()
	    return YEVE_ACTION
	 end
      end
      eve = eve:next()
   end
   return YEVE_NOTHANDLE
end

function swapToFight(entity)
    local main = ywCntWidgetFather(ywCntWidgetFather(entity))
    print("combat time", main)
    ywReplaceEntry(main, 0, Entity.wrapp(main).fightScreen:cent())
    return YEVE_ACTION
end

function create_jims(entity)
   local conntainer = Container.init_entity(entity, "horizontal")
   local ent = conntainer.ent

   print(entity)
   Entity.new_func("jims_action", ent, "action")
   ent.background = "rgba: 127 127 127 255"
   local mainCanvas = Canvas.new_entity(entity, "mainScreen")
   local fightCanvas = Canvas.new_entity(entity, "fightScreen")
   ent.entries[0] = mainCanvas.ent  -- game screen
   ent.entries[0].size = 70
   ent.event_forwarding = "under mouse"
   local menu_cnt = Container.new_entity("vertical") -- bottom box
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

   local mn = menu_cnt.ent.entries[0]
   mn.entries[0] = {}
   mn.entries[0].text = "fight-now"
   mn.entries[0].action = "jims.fight_time"
   mn.entries[1] = {}
   mn.entries[1].text = "quit"
   mn.entries[1].action = "FinishGame"

   local statueBar = Canvas.wrapp(menu_cnt.ent.entries[2])

   statueBar:new_text(1, 1, Entity.new_string("life"))
   local rect = Entity.new_array()
   rect[0] = Pos.new(52, 12).ent;
   rect[1] = "rgba: 0 0 0 255";
   statueBar:new_rect(49, 4, rect)
   rect = Entity.new_array()
   rect[0] = Pos.new(50, 10).ent;
   rect[1] = "rgba: 255 255 255 255";
   statueBar:new_rect(50, 5, rect)

   mainCanvas:new_img(0, 0, "Male_basic.png")
   return conntainer:new_wid()
end
