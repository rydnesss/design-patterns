require('libs/batteries'):export()

--Sets up a dummmy class meant just to have an internal value and a function to add to that value.

local pair = class()

function pair:new(n)
    self.n = n 
end 

function pair:sum(b)
    self.n = self.n + b
    return self.n
end 

--

local command = class({name = 'command'}) --This is the command template

function command:new(execute, undo)
    self.execute = execute 
    self.undo = undo
end 

local sumpair = class({name = 'sumpair', extends = command}) --Extends the command template

function sumpair:new(pair, b)
    self:super(
        function() --Execute...
            return pair:sum(b)
        end, 
        function() --And undo.
            return pair:sum(-b)
        end
    )
end 

local p
local cmd
local cmd_log = {}

function love.load()
    p = pair(5)
    cmd = sumpair(p, 15)
end 

function love.keypressed(key)

    if key == 'space' then 
        local res = cmd.execute() --Gets the result
        table.insert(cmd_log, res) --Logs the change
        print("Executed command. Result:", res) --Prints it
    end
    if key == 'z' then 
        if #cmd_log > 0 then 
            local res = cmd.undo() --Undoes the last change
            table.remove(cmd_log) --Gets rid of it in the log
            print("Undid command. Result: ", res) --Prints result
        else
            print("No commands to undo.") 
        end
    end
end 
