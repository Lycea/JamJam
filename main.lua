function love.load()
  --require("mobdebug").start()
  
  g =require("game")
  g.load()
end

function love.update(dt)
  --require("lurker").update()
  g.update(dt)
end

function love.draw()
  g.draw()
end

function love.keypressed(k,s,r)
    g.keypressed(k,s,r)
end

