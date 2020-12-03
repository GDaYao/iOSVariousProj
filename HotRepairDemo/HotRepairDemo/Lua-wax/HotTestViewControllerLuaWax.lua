--require('mobdebug').start()

waxClass("ViewController")


function viewDidLoad(self)
    self:ORIGviewDidLoad()
    
end


function executeLuascript(self)
    self:label():setText("This is setted by local luaascipt")
end





