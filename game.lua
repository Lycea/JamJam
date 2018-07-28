local game = {}
  ui = require("SimpleUI.SimpleUI")
  h  = require("helper")
  c  = require("console")

--short for drawings stuff
gr = love.graphics
lt = love.timer
lm = love.math

rnd = lm.random

--stats base
local draw ={}
local update = {}
local states= {"game","menue","options","pause"}
local state = "menue"

--ingame stats
local opts = {}
opts.gen_lvl = true

local player = {}
player.pos ={x= 0,y=0}

--1d array of base levels
--2d of levels in floor
local maps = {}

scr_w,scr_h = 0,0


    local door_pos={  
      l = {y= 15,x= 0},
      r = {y= 15,x= 29},
      u = {y= 0,x= 15},
      d = {y= 29,x= 15},
      
    }
    
     local dirs_ ={"l","r","u","d",l ={-1,0},r={1,0},u={0,-1},d={0,1}}
  --return op direction
  local function op_dir(dir)
      if dir == "l" then
        return "r"
      elseif dir == "r" then
        return "l"
      elseif dir == "u" then
        return "d"
      elseif dir == "d" then
        return  "u"
      end
    end
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
            opts.gen_lvl = true
        elseif id == gui["menue"][2] then
          
        elseif id == gui["menue"][3] then
        elseif id == gui["menue"][4] then
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
          
      ui.AddButton(" start ",scr_w/2 - 30,40,0,0),
      ui.AddButton(" options ",scr_w/2 - 30,90,0,0),
      ui.AddButton(" shop ",scr_w/2 - 30,140,0,0),
      --ui.AddButton(" score ",scr_w/2 - 30,190,0,0),
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




local move =
{
  function () player.pos.x =player.pos.x-1 end,
  function () player.pos.y =player.pos.y+1 end,
  function () player.pos.x =player.pos.x+1 end,
  function () player.pos.y =player.pos.y-1 end,
  function () ui.SetGroupVisible("pause",true) love.mouse.setVisible(true) state = "pause" end,
  }

function gen()
  maps[opts.actual] = {}
  for i=1,100 do
    maps[opts.actual][i] = {}
  end
  
  local rooms =  rnd(3+opts.actual*2,3+opts.actual*3)
  maps[opts.actual].start = {50,50}
  local from = nil
  
  local pos = {50,50}--x,y
  
  local count = 0
  
  love.graphics.clear()
  --creation loop
  while count < rooms do
    local room
    
    if maps[opts.actual][pos[2]][pos[1]] == nil then
      room = {}
      room.doors ={l=false,r=false,u=false,d=false}
      
      room.w = 30
      room.h = 30
      count = count +1 
    else
      room =  maps[opts.actual][pos[2]][pos[1]]
    end
    
    if from ~= nil then
      -- put a door at that opposite
      room.doors[op_dir(from)] = true
    end
    
    --find next direction 
    local new_dir = from
    while new_dir == from do
      new_dir = dirs_[rnd(1,4)]
    end
      from = new_dir
      room.doors[from] = true
      
      maps[opts.actual][pos[2]][pos[1]] = room
      
      gr.rectangle("fill",pos[1],pos[2],1,1)
     -- love.graphics.present()
      --love.timer.sleep(1)
      pos = {pos[1]+dirs_[from][1],pos[2]+dirs_[from][2]}
  end 
  
  --add last room
  if maps[opts.actual][pos[2]][pos[1]] == nil then
      room = {}
      room.doors ={l=false,r=false,u=false,d=false}
      
      room.w = 30
      room.h = 30
      count = count +1 
      
      room.doors[op_dir(from)]= true
  else
      room =  maps[opts.actual][pos[2]][pos[1]]
  end
    maps[opts.actual][pos[2]][pos[1]] = room
    maps[opts.actual].finish = pos
  print("finished")
end

function change_room(dir)
  opts.act_room = {opts.act_room[1]+dirs_[dir][1],opts.act_room[2]+dirs_[dir][2]}
  local opp_dir = op_dir(dir)
  
  player.pos = 
  {
    x=  door_pos[opp_dir].x*16 + dirs_[dir][1]*16,
    y=  door_pos[opp_dir].y*16 + dirs_[dir][2]*16,
  }
end



function update.game(dt)
  if opts.gen_lvl == true then
    --init level
    gen()
    opts.act_room = maps[opts.actual].start
    opts.gen_lvl = false
    player.pos={x=16*15,y=16*15}
    
  else
    --update directions
    local keys ={"a","s","d","w","escape"}
    local old_x,old_y = player.pos.x,player.pos.y
    
    local moved = false
    for i,k in ipairs(keys) do
      --print(k)
        if love.keyboard.isDown(k) == true then
          move[i]()
        end
    end
    
    
    --changed so check collision
    if old_x ~= player.pos.x or old_y ~= player.pos.y then
        
        if player.pos.x < 1*16 or player.pos.x > 30*15 or player.pos.y < 1*16 or player.pos.y>30*15 then
         -- print("border")
          
            -- if on a door change room and ignore cycle
            --l
            if player.pos.x <= door_pos.l.x*16 +16 and player.pos.y> door_pos.l.y*16 -7 and player.pos.y < door_pos.l.y*16 +7  and maps[opts.actual][opts.act_room[2]][opts.act_room[1]].doors.l==true then
              --print("left door")
              change_room("l")
              return
            elseif player.pos.x+16 >= door_pos.r.x and player.pos.y> door_pos.l.y*16 -7 and player.pos.y < door_pos.l.y*16 +7  and maps[opts.actual][opts.act_room[2]][opts.act_room[1]].doors.r==true then
              --print("right door")
              change_room("r")
              return
            elseif player.pos.y <= door_pos.u.y*16 +18 and player.pos.x> door_pos.u.x*16 -7 and player.pos.x < door_pos.u.x*16 +7  and maps[opts.actual][opts.act_room[2]][opts.act_room[1]].doors.u==true then
              --print("top door")
              change_room("u")
              return
            elseif player.pos.y+16 >= door_pos.d.y and player.pos.x> door_pos.d.x*16 -7 and player.pos.x < door_pos.d.x*16 +7  and maps[opts.actual][opts.act_room[2]][opts.act_room[1]].doors.d==true then
              --print("right door")
              change_room("d")
              return
            end
            
            
            
            player.pos = {x=old_x,y=old_y}
        end
      end
  end
end

function draw.game()
  if opts.gen_lvl == true then
    
  else
    local room = maps[opts.actual][opts.act_room[2]][opts.act_room[1]]
    for i,door in pairs(room.doors) do
      if door == true then
        if i == "l" or i == "u"then
          gr.rectangle("fill",door_pos[i].x*16,door_pos[i].y*16,16,16)
        else
          gr.rectangle("fill",door_pos[i].x*16,door_pos[i].y*16,16,16)
        end
      end
    end
    gr.rectangle("fill",player.pos.x,player.pos.y,16,16)
    gr.rectangle("line",16,16,(30-1)*(16),(30-1)*16)
    gr.rectangle("line",0,0,(30-1)*16,(30-1)*16)
    
    
    local start =  400
    for i=1,100 do
      for j=1,100 do
        if maps[opts.actual][i][j] ~= nil then
          --gr.rectangle("fill",j*3+start, i*3,3,3)
          --gr.points(j*2 + start ,i*2)
        end
      end
    end
    if opts.act_room[1] == maps[opts.actual].finish[1] and opts.act_room[2] == maps[opts.actual].finish[2]then
      print("end room")
    else
      print("some room")
    end
    
    gr.rectangle("fill",opts.act_room[2]*3+start,opts.act_room[1]*3,3,3)
  end
  
end

function draw.menue()
  
end

function update.menue()
  
end

function update.pause()
  
end
function draw.pause()
  
end


--------game callbacks---------

function game.load()
   scr_w,scr_h = love.graphics.getDimensions()
  setupUi()
  opts.actual = 1
end

  
function game.update(dt)
  update[state](dt)
  ui.update(dt)
end

  
function game.draw()
  draw[state]()
  ui.draw()
end

function game.keypressed(k,s,r)
  
end


return game