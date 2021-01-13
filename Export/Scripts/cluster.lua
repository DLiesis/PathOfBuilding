if not loadStatFile then
	dofile("statdesc.lua")
end
loadStatFile("passive_skill_stat_descriptions.txt")

local out = io.open("../Data/ClusterJewels.lua", "w")
out:write('-- This file is automatically generated, do not edit!\n')
out:write('-- Jewel data (c) Grinding Gear Games\n\nreturn {\n')

out:write('\tjewels = {\n')
for jewel in dat("PassiveTreeExpansionJewels"):Rows() do
	out:write('\t\t["', jewel.BaseItemType.Name, '"] = {\n')
	out:write('\t\t\tsize = "', jewel.Size.Id, '",\n')
	out:write('\t\t\tsizeIndex = ', jewel.Size._rowIndex - 1, ',\n')
	out:write('\t\t\tminNodes = ', jewel.MinNodes, ',\n')
	out:write('\t\t\tmaxNodes = ', jewel.MaxNodes, ',\n')
	out:write('\t\t\tsmallIndicies = { ', table.concat(jewel.SmallIndicies, ', '), ' },\n')
	out:write('\t\t\tnotableIndicies = { ', table.concat(jewel.NotableIndicies, ', '), ' },\n')
	out:write('\t\t\tsocketIndicies = { ', table.concat(jewel.SocketIndicies, ', '), ' },\n')
	out:write('\t\t\ttotalIndicies = ', jewel.TotalIndicies, ',\n')
	out:write('\t\t\tskills = {\n')
	for index, skill in ipairs(dat("PassiveTreeExpansionSkills"):GetRowList("JewelSize", jewel.Size)) do
		out:write('\t\t\t\t["', skill.Node.Id, '"] = {\n')
		out:write('\t\t\t\t\tname = "', skill.Node.Name, '",\n')
		out:write('\t\t\t\t\ticon = "', skill.Node.Icon:gsub("dds$","png"), '",\n')
		if skill.Mastery then
			out:write('\t\t\t\t\tmasteryIcon = "', skill.Mastery.Icon:gsub("dds$","png"), '",\n')
		end
		out:write('\t\t\t\t\ttag = "', skill.Tag.Id, '",\n')
		local stats = { }
		for index, stat in ipairs(skill.Node.Stats) do
			stats[stat.Id] = { min = skill.Node["Stat"..index], max = skill.Node["Stat"..index] }
		end
		local desc = describeStats(stats)
		out:write('\t\t\t\t\tstats = { "', table.concat(desc, '", "'), '" },\n')
		out:write('\t\t\t\t\tenchant = {\n')
		for _, line in ipairs(desc) do
			out:write('\t\t\t\t\t\t"Added Small Passive Skills grant: ', line, '",\n')
		end
		out:write('\t\t\t\t\t},\n')
		out:write('\t\t\t\t},\n')
	end
	out:write('\t\t\t},\n')
	out:write('\t\t},\n')
end
out:write('\t},\n')

out:write('\tnotableSortOrder = {\n')
for skill in dat("PassiveTreeExpansionSpecialSkills"):Rows() do
	if skill.Node.Notable then
		out:write('\t\t["', skill.Node.Name, '"] = ', skill.Stat._rowIndex, ',\n')
	end
end
out:write('\t},\n')
out:write('\tkeystones = {\n')
for skill in dat("PassiveTreeExpansionSpecialSkills"):Rows() do
	if skill.Node.Keystone then
		out:write('\t\t"', skill.Node.Name, '",\n')
	end
end
out:write('\t},\n')

out:write('}')
out:close()

print("Cluster jewel data exported.")
