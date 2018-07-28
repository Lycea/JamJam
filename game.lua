local game = {}
  ui = require("SimpleUI.SimpleUI")
  h  = require("helper")
  c  = require("console")



local draw ={}
local update = {}
local states= {"game","menue","options","pause"}
local state = "menue"

scr_w,scr_h = 0,0
--ui setup and things ---
local cb={
    game = function (id) 
       
    end,
    options = function (id) 
        
        end,
    menue  = function (id) 
         if id == gui["menue"][1] then
            state="game"
            ui.SetGroupVisible("menue",false)
            ui.SetGroupVisible("game",true)
            love.mouse.setVisible(false)
        elseif id == gui["menue"][2] then
          
        elseif id == gui["menue"][3] then
        elseif id == gui["menue"][4] then
        elseif id == gui["menue"][5] then
            love.event.quit()
        end
        
        end,
    pause  = function (id) 
        if id == gui["pause"][1] then
            state="game"
            ui.SetGroupVisible("pause",false)
            ui.SetGroupVisible("game",true)
        elseif id == gui["pause"][2] then
            state="options"
            ui.SetGroupVisible("pause",false)
            ui.SetGroupVisible("options",true)
        elseif id == gui["pause"][3] then
        elseif id == gui["pause"][4] then
            state ="menue"
            ui.SetGroupVisible("pause",false)
            ui.SetGroupVisible("menue",true)
            --reset the game/stats
        end
    end
    }





local function button_cb(id,name)
    c.print("clicked:"..id)
    for idx,obj in pairs(gui) do
        for idx2,id_ in ipairs(obj) do
           if id == id_ then
               --print(idx)
               cb[idx](id)
           end
           
        end
    end
    
end

local function setupUi ()
  ui.init()
  ui.AddClickHandle(button_cb)
  
  gui=
  {
      menue={
          
      ui.AddButton(" start run ",scr_w/2 - 30,40,0,0),
      ui.AddButton(" options ",scr_w/2 - 30,90,0,0),
      ui.AddButton(" shop ",scr_w/2 - 30,140,0,0),
      ui.AddButton(" score ",scr_w/2 - 30,190,0,0),
      ui.AddButton(" exit ",scr_w/2 - 30,240,0,0)
     },
     
     options={
         ui.AddButton(" confirm ",scr_w/2 - 30,40,0,0),
         ui.AddButton(" cancel ",scr_w/2 +50,40,0,0),
     },
     
     pause={
         ui.AddButton(" continue ",scr_w/2 - 30,40,0,0),
         ui.AddButton(" restart ",scr_w/2 - 30,90,0,0),
         ui.AddButton(" options ",scr_w/2 - 30,140,0,0),
         ui.AddButton(" back to menue ",scr_w/2 - 30,190,0,0),
     },
     game={}
  }
  
  for idx,obj in pairs(gui)do
    ui.AddGroup(obj,idx)
  end

 ui.SetGroupVisible("menue",true)  
 ui.SetGroupVisible("options",false)  
 ui.SetGroupVisible("pause",false)  
 
end



function draw.game()
  
end
function update.game(dt)
  
end
function draw.menue()
  
end

function update.menue()
  
end

function update.pause()
  
end
function draw.pause()
  
end


function game.load()
   scr_w,scr_h = love.graphics.getDimensions()
  setupUi()
 
end

  
function game.update(dt)
  update[state](dt)
  ui.update(dt)
end

  
function game.draw()
  draw[state]()
  ui.draw()
end

return game