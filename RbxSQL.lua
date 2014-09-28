--Copyright(C) Ethan Sweet / Ethancomputermad 2014, All Rights Reserved. Service may be terminated at any time. Permission to use the source below and service may be withdrawn at any time for any reason. This notice shall not be removed from the source, or any variation of the source, removing this notice shall result in immediete loss of permission to use the services and source.
RSQL={}
funcs={
	['connect']=function(...) --host,username,password,database,port,socket
		local data={...}
		local prepped_data={
			['host']=data[1],
			['username']=data[2],
			['password']=data[3],
			['db']=data[4],
			['port']=data[5],
			['socket']=data[6]
		}
		local connection=newproxy(true)
		local m=getmetatable(connection)
		if m==nil then setmetatable(connection,{}) m=getmetatable(connection) end
		local terminated=false
		local constquery=''
		local continue_fixer=''
		m.__index=function(_,i) if terminated==true then return end
			if i=='disconnect' then
				terminated=true
			elseif i=='__sql_link' then
				prepped_data['query']=constquery
				return prepped_data
			elseif i=='__sql_continue' then
				return continue_fixer
			end
		end
		m.__newindex=function(_,i,v)
			if i=='__sql_continue' then
				constquery=constquery..v..'; '
				continue_fixer=v
			end
		end
		return connection
	end,
	['query']=function(...) --link, query
		local data={...}
		local link=data[1]
		local query=data[2]
		if link==nil then error('Missing link') elseif query==nil then error('Missing query') elseif #data>2 then if #data>3 then error('Unexpected arguments, 3 to '..tostring(#data)) else error('Unexpected argument 3') end end
		local data=link.__sql_link
		data['query']=data['query']..query
		local jsondata=game:GetService('HttpService'):JSONEncode(data)
		local resp=game:GetService('HttpService'):PostAsync('http://54.72.38.203/ethan/luasql/sql.php',jsondata,Enum.HttpContentType.ApplicationJson)
		
		local sqlerr=false
		if type(resp)=='string' then
			local succ,nresp=pcall(function() return game:GetService('HttpService'):JSONDecode(resp) end)
			if succ==true then resp=nresp else if resp=='' then resp={} else resp={resp} sqlerr=true end end
		end
		if #resp==0 and sqlerr==false then
			local noc={'drop','delete','insert','append','alter','create','update','union','truncate'}
			local continue=true
			for _, v in pairs(noc) do
				if string.find(query:lower(),v:lower()) then
					continue=false break
				end
			end
			if continue==true then
				local atend=false
				while atend==false do wait()
					if query:sub(#query)=='	' or query:sub(#query)==' ' or query:sub(#query)==';' then
						atend=false
						query=query:sub(#query-1)
					else
						atend=true
					end
				end
				link.__sql_continue=query..'; '
			end
		end
		if sqlerr==true then
			print('MySQL Error: ',resp[1])
		end
		return resp
	end
	}
meta={
	['__index']=function(_,i)
		return funcs[i]
	end,
	['__newindex']=function(_,i,v)
		
	end,
	['__metatable']=function()
		return 'The metatable is locked. (RbxSQL by Ethancomputermad 0.1)'
	end
}
setmetatable(RSQL,meta)
_G.RbxSQL=function()
	getfenv(0)['RbxSQL']=RSQL
end
