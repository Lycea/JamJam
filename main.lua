function love.load()
  require("mobdebug").start()
  
  g =require("game")
  g.load()
end

function love.update(dt)
  g.update(dt)
end

function love.draw()
  g.draw()
end
