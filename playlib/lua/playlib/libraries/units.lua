if !PLAYLIB then return end
PLAYLIB.units = PLAYLIB.units or {}

SECOND = 1
MINUTE = SECOND * 60
HOUR = MINUTE * 60
DAY = HOUR * 24
WEEK = DAY * 7
MONTH = DAY * 31 // Most Month have 31 Days - 31 Days: 7 Month - 30 Days: 4 Month - 28/29 Days: 1 Month
YEAR = DAY * 365
DECADE = YEAR * 10
CENTURY = DECADE * 10
MILLENIUM = CENTURY * 10

MILLIMETER = 0.0533
CENTIMETER = MILLIMETER * 10
DECIMETER = CENTIMETER * 10
METER = DECIMETER * 10
KILOMETER = METER*1000

MPH_FACTOR = 0.056818181
KMH_FACTOR = 1.6093
MS_FACTOR = 0.277778

function PLAYLIB.units:ToMPH(number)
    if not number or not isnumber(number) then return end

    return number*MPH_FACTOR
end

function PLAYLIB.units:ToKMH(number) 
    if not number or not isnumber(number) then return end

    return (self:ToMPH(number)*KMH_FACTOR)
end

function PLAYLIB.units:ToMS(number)
    if not number or not isnumber(number) then return end

    return (self:ToKMH(number)*MS_FACTOR)
end