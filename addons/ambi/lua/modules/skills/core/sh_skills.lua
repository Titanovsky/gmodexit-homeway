Ambi.Skills.skills = Ambi.Skills.skills or {}

local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Skills.AddSkill( sSkill, sName, sDescription )
    if not sSkill then return end

    sSkill = sSkill:lower()

    sName = sName or ''
    sDescription = sDescription or ''

    local skill = Ambi.Skills.skills[ sSkill ]

    if skill then
        skill.name = sName
        skill.description = sDescription
    else
        Ambi.Skills.skills[ sSkill ] = {
            name = sName,
            description = sDescription,
            nodes = {}
        }
    end
end

function Ambi.Skills.AddNode( nID, sSkill, nCost, sName, sDescription, fCallback )
    if not nID then return end

    local skill = Ambi.Skills.skills[ sSkill or '' ]
    if not skill then return end

    skill.nodes[ nID ] = {
        cost = nCost or 0,
        name = sName or '',
        description = sDescription or '',
        Callback = fCallback
    }
end

function Ambi.Skills.GetSkill( sSkill )
    sSkill = sSkill or ''
    sSkill = sSkill:lower()

    return Ambi.Skills.skills[ sSkill ]
end

function Ambi.Skills.GetSkills()
    return Ambi.Skills.skills
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetSkills()
    return self.skills
end

function PLAYER:GetSkill( sSkill )
    if not sSkill then return 0 end
    return self.skills and self.skills[ sSkill ] or 0
end