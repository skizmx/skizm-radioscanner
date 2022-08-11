local QBCore = exports['qb-core']:GetCoreObject()

local function GetFrequencies()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local radius = Config.Radius
    local list = {}
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords(coords, radius)
    for i = 1, #closestPlayers do
        local plyState = Player(GetPlayerServerId(closestPlayers[i])).state
        local proximity = plyState.radioChannel
        if proximity > 1 then
            list[#list+1] = proximity
        end
    end
    return list
end

local function ShowMenu()
    local data = GetFrequencies()
    local menu = {}
    local txt = ''
    menu = {
        {
            header = 'Frequencies',
            icon = 'fas fa-broadcast-tower',
            isMenuHeader = true,
        },
    }
    for i = 1, #data do
        if Config.UseRange.Set then
            txt = QBCore.Shared.Round(data[i]) - math.random(1, Config.UseRange.Min)..' MHz - '..QBCore.Shared.Round(data[i]) + math.random(1, Config.UseRange.Max)..' MHz'
        else
            txt = QBCore.Shared.Round(data[i])..' MHz'
        end
        menu[#menu+1] = {
            header = txt,
            icon = 'fas fa-wave-square',
            params = {
                event = 'skizm-radioscanner:client:closemenu',
            }
        }
    end
    menu[#menu+1] = {
        header = 'Rescan',
        icon = 'fas fa-undo',
        params = {
            event = 'skizm-radioscanner:client:usescanner',
        }
    }
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('skizm-radioscanner:client:usescanner', function()
    TriggerEvent('animations:client:EmoteCommandStart', {'wt'})
    QBCore.Functions.Progressbar('radio_scan', 'Scanning area...', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {'c'})
        ShowMenu()
    end, function()
        TriggerEvent('animations:client:EmoteCommandStart', {'c'})
        QBCore.Functions.Notify('Canceled!', 'error', 3500)
    end)
end)