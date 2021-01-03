--require('mobdebug').start()

waxClass("HotTestViewController")


function viewDidLoad(self)
    self:ORIGviewDidLoad()
    
end


function executeLuascript(self)
    print("wax print test.")
end





