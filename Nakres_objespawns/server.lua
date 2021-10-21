ESX = nil
local StartAndSpawn = false
local spawned = true
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local perms = 
{
	"steam:11000011513da03",
	"steam:11000014418fa11",
}

Citizen.CreateThread(function ()
	local jsonData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
	local data = json.decode(jsonData)
	if data == nil then
		SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode({}), -1)
	end
	if StartAndSpawn then
		if spawned == flase then
			for j, l in ipairs(data) do	
				obje = CreateObject(l.object.obje.model, l.object.coords.x, l.object.coords.y, l.object.coords.z, true, true, true)
				SetEntityHeading(obje , l.object.coords.h)
				SetEntityRotation(obje,l.object.coords.r.x , l.object.coords.r.y , l.object.coords.r.z,5)
				FreezeEntityPosition(obje, true)
				SetEntityAsMissionEntity(obje,true,true)
			end
		spawned = true
		end
	end
end)

RegisterCommand("build",function (source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local jsonData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
	local data = json.decode(jsonData)
    if checkperm(identifier) then
        TriggerClientEvent("buildon",source,data)
    else
		msg(xPlayer.source)
    end
end)

RegisterCommand('edit', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
    if checkperm(identifier) then
		TriggerClientEvent("editmode",source)
    else
		msg(xPlayer.source)
    end
end)

RegisterCommand('nesnelerisil', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
    if checkperm(identifier) then
        TriggerClientEvent('clearall',source)
    else
		msg(xPlayer.source)
    end
end)

local zatenvar = false
RegisterServerEvent("NewJsonData")
AddEventHandler("NewJsonData",function (event)
	local jsonData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
	local data = json.decode(jsonData)
	for i, k in ipairs(data) do
		if k.name == event.name then
			zatenvar = true
			break
		end
	end    
	if zatenvar then
		TriggerClientEvent("sj",source,event)
		zatenvar = false
		return print("error")
	else
		table.insert(data,event)
		SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode(data), -1)
	end
end)

RegisterServerEvent("SpawnObjdata")
AddEventHandler("SpawnObjdata",function (name)
	local jsonData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
	local data = json.decode(jsonData)
	TriggerClientEvent("spawns:object",source,data,name)
end)

RegisterServerEvent("DeleteObjSon")
AddEventHandler("DeleteObjSon",function (name)
	local jsonData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
	local data = json.decode(jsonData)
	for i, k in ipairs(data) do
		if k.name == name then
			table.remove(data,i)
			break
		end
	end
	SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(data), -1)
end)

function checkperm(psteam)
	for i, v in pairs(perms) do
		if psteam == v then
			return true
		end
	end
	return false
end

function msg(player)
	TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = "Bunun için yetkin yok!!"},4000)	
end

RegisterNetEvent("SaveObjData")
AddEventHandler("SaveObjData",function (e)
	SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(e), -1)
end)


local spawn = {}
ESX.RegisterServerCallback("spawncontrol",function(src,cb,name)
	if spawn[name] == true then
		cb(true)
	elseif spawn[name] == false or spawn[name] == nil  then
		cb(false)
	end
end)
 
RegisterNetEvent("spawnladım")
AddEventHandler("spawnladım",function (e)
	spawn[e] = true
end)