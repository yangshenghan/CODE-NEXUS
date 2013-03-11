nexus.manager.object = {}

local objects = {}

function nexus.manager.object.initialize()
end

function nexus.manager.object.getObjects()
    return objects
end

function nexus.manager.object.attachObject(object)
    table.insert(objects, object)
end
