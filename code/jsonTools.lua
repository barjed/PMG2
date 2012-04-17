module(...,package.seeall);

-- jsonFile() loads json file & returns contents as a string
jsonFile = function( filename, base )

	-- set default base dir if none specified
	if not base then base = system.ResourceDirectory; end

	-- create a file path for corona i/o
	local path = system.pathForFile( filename, base )

	-- will hold contents of file
	local contents

	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	-- read all contents of file into a string
	contents = file:read( "*a" )
	io.close( file ) -- close the file after using it
	end

	return contents
end

-- search() iterates through a table trying to find an element with the desired id
search = function(tab, query)
	for index,value in pairs(tab) do
		if (value.id == query) then
			return value;
		end
	end
end

