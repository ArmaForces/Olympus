/*
 * Author: Theseus Incorporated
 *
 * initPlayerLocal.sqf
 * Initialization of scripts local to player
 * Executed locally when player joins mission (includes both mission start and JIP)
 * Executed after initServer and before initPlayerServer and init.
 *
 * Arguments: [player:Object, didJIP:Boolean]
 *
 */

#include "script_component.hpp"

// Types a "OLYMPUS" text on the screen, letter by letter, cursor blinking.
[
    [
        ["OLYMPUS", "<t size = '1.5' underline = '1'>%1</t><br/>"],
        ["Theseus Incorporated"],
        ["Hebontes", "<t size = '1' font='puristaMedium'>%1</t>", 70]
    ], 1, 0.75, "<t align = 'center' shadow = '1' size = '1.0'>%1</t>"
] spawn BIS_fnc_typeText;

// Sets default loadout to joining players
[_this select 0] call FUNC(setBasicLoadout);

// Reset stamina on specific course starts
[QTACGVAR(shootingrange,started), {
    params ["", "_name"];

    // Exit if not wanted range
    if  (_name find "Advanced Pistol Course" == -1 &&
        {_name find "Advanced Rifle Course" == -1}
    ) exitWith {};

    ace_advanced_fatigue_ae1Reserve = 4000000; // AE1_MAXRESERVE (advanced fatigue - "script-component.hpp")
    ace_advanced_fatigue_ae2Reserve = 84000; // AE2_MAXRESERVE (advanced fatigue - "script-component.hpp")
    ace_advanced_fatigue_anReserve = 2300; // AN_MAXRESERVE (advanced fatigue - "script-component.hpp")
    ace_advanced_fatigue_anFatigue = 0;
    ace_advanced_fatigue_muscleDamage = 0;
}] call CBA_fnc_addEventHandler;

// Disable weapon jamming on specified markers
["ace_weaponJammed", {
    params ["_unit", "_weapon"];

    // Clear jam instantly if in marker/trigger/location/coordinates
    if  (_unit inArea disableWeaponJam_AdvPistolRifle ||
        {_unit inArea disableWeaponJam_BasicRanges}) then {
        [_unit, _weapon, true] call ace_overheating_fnc_clearJam;
    };
}] call CBA_fnc_addEventHandler;
