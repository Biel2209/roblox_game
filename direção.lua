local npc = workspace:WaitForChild("Dummy")
local humanoid = npc:WaitForChild("Humanoid")
local destino = Vector3.new(50, 0, 50)

humanoid.WalkSpeed = 14
humanoid:MoveTo(destino)

humanoid.MoveToFinished:Connect(function(reached)
    if reached then
        print("NPC chegou ao destino!")
    else
        print("NPC não conseguiu chegar.")
    end
end)   