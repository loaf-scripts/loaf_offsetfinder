local shell, oldcoords

Notify = function(txt)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(txt)
    DrawNotification(0, 1)
end

TestShell = function(object, name)
    if DoesEntityExist(shell) then 
        DeleteEntity(shell)
    else
        oldcoords = GetEntityCoords(PlayerPedId())
    end

    Wait(50)

    shell = CreateObject(object, GetEntityCoords(PlayerPedId()) + vec3(0.0, 0.0, 50.0), true, true)
    FreezeEntityPosition(shell, true)
    SetEntityHeading(shell, 0.0)
    SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(shell))

    while DoesEntityExist(shell) do
        Wait(0)

        local myCoords, shellCoords = GetEntityCoords(PlayerPedId()) - vec3(0.0,0.0,0.99), GetEntityCoords(shell)
        local offset = myCoords-shellCoords

        SetTextFont(4)
        SetTextScale(0.4, 0.4)
        SetTextDropShadow()
        SetTextEntry("STRING")
        AddTextComponentString(("Offset: vector3(%.2f, %.2f, %.2f)"):format(table.unpack(offset)))
        DrawText(0.16, 0.175)

        BeginTextCommandDisplayHelp(GetCurrentResourceName())
        EndTextCommandDisplayHelp(0, 0, false, -1)

        if IsDisabledControlJustReleased(0, 51) then 
            DeleteEntity(shell)
            Notify("Shell deleted.")
            if oldcoords then
                SetEntityCoords(PlayerPedId(), oldcoords)
            end
        elseif IsControlJustReleased(0, 191) then
            SendNUIMessage({coords = ("vector3(%f, %f, %f)"):format(table.unpack(offset))})
            Notify("Offset copied to clipboard.")
        end
    end
end

RegisterCommand("testshell", function(src, args)
    AddTextEntry(GetCurrentResourceName(), "Press ~INPUT_CONTEXT~ to delete the shell object.\nPress ~INPUT_FRONTEND_RDOWN~ to copy the offset.")
    if args[1] and Shells[args[1]] then
        TestShell(Shells[args[1]].obj, args[1])
    else
        Notify(("No such shell \"%s\"."):format(args[1] or ""))
    end
end)