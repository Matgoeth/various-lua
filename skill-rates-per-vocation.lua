-- replace your own onGainSkillTries function in player.lua (written for TFS1.3) - USE AT YOUR OWN RISK AS I AM NOT SUPPORTING THIS

skillStagesNoVocation = {}
skillStagesNoVocation[SKILL_FIST] = {{0,6},{20,3},{25,2}}
skillStagesNoVocation[SKILL_CLUB] = {{0,6},{20,3},{25,2}}
skillStagesNoVocation[SKILL_SWORD] = {{0,6},{20,3},{25,2}}
skillStagesNoVocation[SKILL_AXE] = {{0,6},{20,3},{25,2}}
skillStagesNoVocation[SKILL_DISTANCE] = {{0,6},{20,3},{25,2}}
skillStagesNoVocation[SKILL_SHIELD] = {{0,6},{20,3},{25,2}}
skillStagesNoVocation[SKILL_FISHING] = {{0,1}}
skillStagesNoVocation[SKILL_MAGLEVEL] = {{0,1}}

skillStagesSorcerer = {}
skillStagesSorcerer[SKILL_FIST] = {{0,6},{30,3},{50,2}}
skillStagesSorcerer[SKILL_CLUB] = {{0,6},{30,3},{50,2}}
skillStagesSorcerer[SKILL_SWORD] = {{0,6},{30,3},{50,2}}
skillStagesSorcerer[SKILL_AXE] = {{0,6},{30,3},{50,2}}
skillStagesSorcerer[SKILL_DISTANCE] = {{0,6},{30,3},{50,2}}
skillStagesSorcerer[SKILL_SHIELD] = {{0,6},{30,3},{50,2}}
skillStagesSorcerer[SKILL_FISHING] = {{0,2}}
skillStagesSorcerer[SKILL_MAGLEVEL] = {{0,8},{35,6},{60,4},{90,3}}

skillStagesDruid = {}
skillStagesDruid[SKILL_FIST] = {{0,6},{30,3},{50,2}}
skillStagesDruid[SKILL_CLUB] = {{0,6},{30,3},{50,2}}
skillStagesDruid[SKILL_SWORD] = {{0,6},{30,3},{50,2}}
skillStagesDruid[SKILL_AXE] = {{0,6},{30,3},{50,2}}
skillStagesDruid[SKILL_DISTANCE] = {{0,6},{30,3},{50,2}}
skillStagesDruid[SKILL_SHIELD] = {{0,6},{30,3},{50,2}}
skillStagesDruid[SKILL_FISHING] = {{0,2}}
skillStagesDruid[SKILL_MAGLEVEL] = {{0,8},{35,6},{60,4},{90,3}}

skillStagesPaladin = {}
skillStagesPaladin[SKILL_FIST] = {{0,8},{30,6},{60,4},{75,2}}
skillStagesPaladin[SKILL_CLUB] = {{0,8},{30,6},{60,4},{75,2}}
skillStagesPaladin[SKILL_SWORD] = {{0,8},{30,6},{60,4},{75,2}}
skillStagesPaladin[SKILL_AXE] = {{0,8},{30,6},{60,4},{75,2}}
skillStagesPaladin[SKILL_DISTANCE] = {{0,8},{30,6},{50,4},{75,3},{100,2}}
skillStagesPaladin[SKILL_SHIELD] = {{0,8},{20,6},{40,4},{80,2}}
skillStagesPaladin[SKILL_FISHING] = {{0,2}}
skillStagesPaladin[SKILL_MAGLEVEL] = {{0,4},{5,3},{20,2}}

skillStagesKnight = {}
skillStagesKnight[SKILL_FIST] = {{0,10},{30,8},{50,6},{70,4},{85,3},{110,2}}
skillStagesKnight[SKILL_CLUB] = {{0,10},{30,8},{50,6},{70,4},{85,3},{110,2}}
skillStagesKnight[SKILL_SWORD] = {{0,10},{30,8},{50,6},{70,4},{85,3},{110,2}}
skillStagesKnight[SKILL_AXE] = {{0,10},{30,8},{50,6},{70,4},{85,3},{110,2}}
skillStagesKnight[SKILL_DISTANCE] = {{0,8},{30,6},{60,4},{70,2}}
skillStagesKnight[SKILL_SHIELD] = {{0,10},{30,8},{50,6},{70,4},{85,3},{110,2}}
skillStagesKnight[SKILL_FISHING] = {{0,2}}
skillStagesKnight[SKILL_MAGLEVEL] = {{0,8},{4,4},{10,2}}

skillVocationTable = {}
skillVocationTable[0] = skillStagesNoVocation --no voc
skillVocationTable[1] = skillStagesSorcerer --sorc
skillVocationTable[2] = skillStagesDruid --dru
skillVocationTable[3] = skillStagesPaladin --pal
skillVocationTable[4] = skillStagesKnight --knight
skillVocationTable[5] = skillStagesSorcerer --ms
skillVocationTable[6] = skillStagesDruid --ed
skillVocationTable[7] = skillStagesPaladin --rp
skillVocationTable[8] = skillStagesKnight --ek  
   
function Player:onGainSkillTries(skill, tries)
    if APPLY_SKILL_MULTIPLIER == false then
        return tries
    end

	local vocation = self:getVocation()
	local skillName
	local skillRate = 1
	
    if(skill==0)then
        skillName=SKILL_FIST
    elseif(skill==1)then
        skillName=SKILL_CLUB
    elseif(skill==2)then
        skillName=SKILL_SWORD
    elseif(skill==3)then
        skillName=SKILL_AXE
    elseif(skill==4)then
        skillName=SKILL_DISTANCE
    elseif(skill==5)then
        skillName=SKILL_SHIELD
    elseif(skill==6)then
        skillName=FISHING
    end
	
	local skillStages = skillVocationTable[vocation:getId()]
	
	if skillStages ~= nil then
		if(skillStages[skill] ~= nil) then
			skillRate = 1
			for i, skillRateInfo in pairs(skillStages[skill]) do
				if(getPlayerSkill(self, skillName) >= skillRateInfo[1]) then
					skillRate = skillRateInfo[2]
				else
					break
				end
			end
		else
		print(string.format("VocationId: %s doesn't have skillrate for skill %d", vocation:getId(), skill))
		end
	else
	print(string.format("Unable to retrieve skillrates for vocationId: %s", vocation:getId()))
	end
	
    if(skillStages[skill] ~= nil) then
        skillRate = 1
        for i, skillRateInfo in pairs(skillStages[skill]) do
            if(getPlayerSkill(self, skillName) >= skillRateInfo[1]) then
                skillRate = skillRateInfo[2]
            else
                break
            end
        end
    end
	
    if skill == SKILL_MAGLEVEL then
        return tries * configManager.getNumber(configKeys.RATE_MAGIC) * skillRate
    end
    return tries * configManager.getNumber(configKeys.RATE_SKILL) * skillRate
end
