function init_jims(mod)
   Widget.new_subtype("jims", "create_jims")
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

function create_jims(entity)
   local conntainer = Container.init_entity(entity, "horizontal")
   local ent = conntainer.ent

   Entity.new_func("jims_action", ent, "action")
   ent.background = "rgba: 127 127 127 255"
   ent.entries[0] = Canvas.new_entity().ent  -- game screen
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

   local mn = menu_cnt.ent.entries[0]
   mn.entries[0] = {}
   mn.entries[0].text = "fight-now"
   mn.entries[1] = {}
   mn.entries[1].text = "quit"
   mn.entries[1].action = "FinishGame"

   local statueBar = Canvas.wrapp(menu_cnt.ent.entries[2])
   local ret = conntainer:new_wid()
   statueBar:new_text(10, 10, "life")
   return ret;
end
