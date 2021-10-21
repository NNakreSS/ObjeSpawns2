ESX = nil
local display = false
local objeSet = false
local obje = nil
local objeLocked = false
local editMode = false
local Datas = {}
local models = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("buildon")
AddEventHandler("buildon",function (a)
	local dataname = {}
	SetDisplay(not display)
	for i , k in pairs(a) do
	table.insert(dataname,k.name)
	end
	SendNUIMessage({
        action = "open",
        objdata = (dataname)
    })
end)

RegisterNetEvent("clearall")
AddEventHandler("clearall", function()
	local coord = GetEntityCoords(PlayerPedId())
	FreezeEntityPosition(obje, false)
	objeSet = false
	ClearAreaOfEverything(coord.x, coord.y, coord.z, 20.0, 0, 0, 0, 0)
	end)


RegisterNetEvent("editmode")
AddEventHandler("editmode",function ()
	editMode = not editMode
end)

RegisterNUICallback("objectspawn", function(data)
		local playerCoords = GetEntityCoords(PlayerPedId())
		obje = CreateObject(data.objname, playerCoords.x + 1.25, playerCoords.y, playerCoords.z -1, true, true, true)
		models[obje] = data.objname
		ESX.ShowNotification('Obje çıkartıldı')
		FreezeEntityPosition(obje, true)
		SetEntityAsMissionEntity(obje,true,true)
		PlaceObjectOnGroundProperly(obje)
		objeSet = true
		editMode = true
		objeLocked = false
		SetDisplay(not display)
end)

RegisterNUICallback("error", function(data)
	exports["mythic_notify"]:SendAlert("error", data.error, 5000)
end)

RegisterNUICallback("deleteobj", function(objs)
	local playerPed = PlayerPedId()
	local playercoords = GetEntityCoords(playerPed)
	local objname = GetHashKey(objs.objname) 
    if DoesObjectOfTypeExistAtCoords(playercoords, 4.5, objname, true) then
        local obj = GetClosestObjectOfType(playercoords, 4.5, objname, false, false, false)
		FreezeEntityPosition(obj,false)
		local ids = NetworkGetNetworkIdFromEntity(obje)
        DeleteObject(obj)
		ESX.ShowNotification('Obje silindi')
		for i, k in ipairs(Datas) do
			if k.obje.id == ids then
				table.remove(Datas,i)
				break
			end
		end
	else
		ESX.ShowNotification('Yakında obje yok')
    end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
	editMode = false
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Citizen.Wait(500)
	end
	while true do
		local sleep = 1500
		if objeSet and editMode then
			sleep  = 1
			local playerPed = PlayerPedId()
			local playercoords = GetEntityCoords(playerPed)
			local objecoords = GetEntityCoords(obje)
			local Waiting = 1500
			while #(objecoords - playercoords) < 4.0 and editMode and  not objeLocked do
				Waiting = 1
				ESX.ShowHelpNotification('~INPUT_VEH_FLY_PITCH_UD~ : Yukarı & Aşağı ~n~~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ : Yönlendir ~n~~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ : Yön ~n~~INPUT_WEAPON_WHEEL_NEXT~ ~INPUT_WEAPON_WHEEL_PREV~ : Rotasyon ~n~~INPUT_FRONTEND_RDOWN~ : Objeyi Kilitle', true)
				if IsControlPressed(0, 111) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, 0.0, 0.05))
				end
				if IsControlPressed(0, 110) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, 0.0, -0.05))
				end
				if IsControlPressed(0, 172) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, 0.05, 0.0))
				end
				if IsControlPressed(0, 173) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.0, -0.05, 0.0))
				end
				if IsControlPressed(0, 174) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, -0.05, 0.0, 0.0))
				end
				if IsControlPressed(0, 175) then
					SetEntityCoords(obje, GetOffsetFromEntityInWorldCoords(obje, 0.05, 0.0, 0.0))
				end
				if IsControlPressed(0, 117) then
					SetEntityHeading(obje, GetEntityHeading(obje) + 0.5)
				end
				if IsControlPressed(0, 118) then
					SetEntityHeading(obje, GetEntityHeading(obje) - 0.5)
				end
				if IsControlPressed(0, 14) and not IsControlPressed(0, 36) and not IsControlPressed(0, 19) then
					SetEntityRotation(obje, GetEntityRotation(obje ,1).x - 0.5 , GetEntityRotation(obje ,1).y,GetEntityRotation(obje ,1).z)
				end
				if IsControlPressed(0, 15) then
					SetEntityRotation(obje, GetEntityRotation(obje,1).x + 0.5,GetEntityRotation(obje ,1).y,GetEntityRotation(obje ,1).z)
				end
				if IsControlPressed(0, 14) and IsControlPressed(0, 36) then
					SetEntityRotation(obje, GetEntityRotation(obje ,1).x  , GetEntityRotation(obje ,1).y -0.5,GetEntityRotation(obje ,1).z)
				end
				if IsControlPressed(0, 15) and IsControlPressed(0, 36) then
					SetEntityRotation(obje, GetEntityRotation(obje,1).x ,GetEntityRotation(obje ,1).y + 0.5,GetEntityRotation(obje ,1).z)
				end
				if IsControlPressed(0, 14) and IsControlPressed(0, 19) then
					SetEntityRotation(obje, GetEntityRotation(obje,1).x ,GetEntityRotation(obje ,1).y,GetEntityRotation(obje ,1).z- 0.5)
				end
				if IsControlPressed(0, 15) and IsControlPressed(0, 19) then
					SetEntityRotation(obje, GetEntityRotation(obje,1).x ,GetEntityRotation(obje ,1).y,GetEntityRotation(obje ,1).z+ 0.5)
				end
				
				if IsControlJustReleased(0, 191) then
					objeLocked = true
					editMode = not editMode
					SetDisplay(not display)
					FreezeEntityPosition(obje, true)
local coords = GetEntityCoords(obje)
local heading = GetEntityHeading(obje)
local rotation = GetEntityRotation(obje,5)
local objeid = NetworkGetNetworkIdFromEntity(obje)
local jsondata = {obje = {model = models[obje],id = objeid},coords = {x = coords.x , y =  coords.y , z = coords.z , h = heading , r = rotation}}
table.insert(Datas , jsondata)
				end
				Citizen.Wait(Waiting)
			end
			 playerPed = PlayerPedId()
			 playercoords = GetEntityCoords(playerPed)
			 objecoords = GetEntityCoords(obje)
			while #(objecoords - playercoords) < 2.0 and editMode and objeLocked do
				Citizen.Wait(0)
				ESX.ShowHelpNotification('~INPUT_FRONTEND_RDOWN~ : Obje kilidini aç', true)
				if IsControlJustReleased(0, 191) then
					objeLocked = false
					FreezeEntityPosition(obje, true)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

RegisterCommand("kaydet",function (source,args)
	if args[1] ~= nil and args[1] ~= '' then
		local newdata = {
			name = args[1] ,
			objects = Datas
		}
		Datas = {}
		TriggerServerEvent("NewJsonData",newdata)
	else
		ESX.ShowNotification("Bir isim belirlemelisiniz")
	end
end)

RegisterNetEvent("sj")
AddEventHandler("sj",function (data)
	ESX.ShowNotification("Aynı isimde bir veri zaten kayıtlı")
	Datas = data
end)

RegisterNUICallback("SpawnObJson",function (e)
	TriggerServerEvent("SpawnObjdata",e.name)
end)

RegisterNUICallback("DeleteObjSon",function (e)
	TriggerServerEvent("DeleteObjSon",e.name)
end)

RegisterNetEvent("spawns:object")
AddEventHandler("spawns:object",function (data,name)
	ESX.TriggerServerCallback("spawncontrol", function(cb)
		if not cb then 
			for i, k in ipairs(data) do
				if k.name == name then
					for j, l in ipairs(k.objects) do			
						obje = CreateObject(l.obje.model, l.coords.x, l.coords.y, l.coords.z, true, true, true)
						SetEntityHeading(obje , l.coords.h)
						SetEntityRotation(obje,l.coords.r.x , l.coords.r.y , l.coords.r.z,5)
						FreezeEntityPosition(obje, true)
						SetEntityAsMissionEntity(obje,true,true)
						print(NetworkGetNetworkIdFromEntity(obje))
					end
				end
			end
			TriggerServerEvent("spawnladım",name)
		else
		ESX.ShowNotification("Bu kaynak zaten spawnlandı")
		end
	end, name)
end)


RegisterNetEvent("spawns:objectoto")
AddEventHandler("spawns:objectoto",function (data)

end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)
