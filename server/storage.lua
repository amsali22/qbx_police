function IsVehicleOwned(plate)
    local count = MySQL.scalar.await('SELECT count(*) FROM player_vehicles WHERE plate = ?', {plate})
    return count > 0
end

function FetchImpoundedVehicles()
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE state = 2')
    if result[1] then
        return result
    end
end

function Unimpound(plate)
    MySQL.update('UPDATE player_vehicles SET state = 0 WHERE plate = ?', {plate})
end

function ImpoundWithPrice(price, body, engine, fuel, plate)
    MySQL.query('UPDATE player_vehicles SET state = 0, depotprice = ?, body = ?, engine = ?, fuel = ? WHERE plate = ?', {price, body, engine, fuel, plate})
end

function ImpoundForever(body, engine, fuel, plate)
    MySQL.query('UPDATE player_vehicles SET state = 2, body = ?, engine = ?, fuel = ? WHERE plate = ?', {body, engine, fuel, plate})
end

--- returns vehicle mods for a given plate
lib.callback.register('police:server:GetVehicleProperties', function(source, plate)
    if not plate then return nil end

    local result = MySQL.scalar.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return json.decode(result)
    end
    return nil
end)