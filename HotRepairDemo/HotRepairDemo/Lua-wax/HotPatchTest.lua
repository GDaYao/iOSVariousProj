-- HotPatchTest.lua
WaxClass{"HotTestViewController"}

function setUpUi(self)
    print('Hello, wax!')
    self:view():setBackgroundColor(UIColor:blueColor())
end
