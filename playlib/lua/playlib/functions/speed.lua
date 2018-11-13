if !PLAYLIB then return end

PLAYLIB.speed = PLAYLIB.speed or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

function PLAYLIB.speed.unitConversion(number,type)


	// Conversions - Josh 'Acecool' Moser
	// 1 unit = 0.75 inches. 
	// 4/3 units = 1 inch - from this we base our calculations.
	
	CONVERSION_UNITS_TO_INCHES 					= 4 / 3; // 4/3 units per 1 inch, 16 units per foot
	CONVERSION_UNITS_TO_FEET 					= CONVERSION_UNITS_TO_INCHES * 12; // 				== 16 in game units

	CONVERSION_UNITS_TO_METERS 					= 0.0254 / CONVERSION_UNITS_TO_INCHES;
	UNITS_PER_METER 							= 39.3701 * CONVERSION_UNITS_TO_INCHES;

	// Crap choices...
	CONVERSION_UNITS_TO_METERS 					= CONVERSION_UNITS_TO_FEET * 0.3048; -- 1 foot = 0.3048 meters. 16 units = 1 foot...
	CONVERSION_UNITS_TO_MILES 					= CONVERSION_UNITS_TO_FEET * 5280;
	CONVERSION_UNITS_TO_KILOMETERS 				= CONVERSION_UNITS_TO_FEET * 3280.84;
	CONVERSION_UNITS_TO_MPH						= CONVERSION_UNITS_TO_INCHES * 17.6;
	CONVERSION_UNITS_TO_KPH						= CONVERSION_UNITS_TO_INCHES * 10.936133;

	CONVERSION_UNITS_KM_TO_MILE 				= 0.62137119223733387264;
	CONVERSION_UNITS_MILE_TO_KM 				= 1.609344;

	if type == "inch" then
		return number/CONVERSION_UNITS_TO_INCHES
	elseif type == "feet" then
		return number/CONVERSION_UNITS_TO_FEET
	elseif type == "meter" then
		return number/CONVERSION_UNITS_TO_METERS	
	elseif type == "mile" then
		return number/CONVERSION_UNITS_TO_MILES
	elseif type == "kilometer" then
		return number/CONVERSION_UNITS_TO_KILOMETERS
	elseif type == "mph" then
		return number/CONVERSION_UNITS_TO_MPH
	elseif type == "kmh" then
		return number/CONVERSION_UNITS_TO_KPH
	end

end