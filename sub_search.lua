

-- pre defined macros
HOST= "http://api.makedie.me/v1";

SUB_SEARCH_ACT="sub/search";
SUB_DETAIL_ACT="sub/detail";

TOKEN = "zBoosJHwrn0YYL6xjHCSC3Nott4bM7ll";

-- generate the search sub requset string
function generate_search_req ( keyword)
  return HOST .. "/" .. SUB_SEARCH_ACT .. "?token=" .. TOKEN .. "&q=" .. keyword;
end

-- generate the sub detail request stringqu
function generate_sub_detail_req( id )
  return HOST .. "/" .. SUB_DETAIL_ACT .. "?token=" .. TOKEN .. "&id=" .. id;
end
-- test function generate search request
-- print(generate_search_req("hehahha"))

-- fire a request
function get_request_result( req_str)
  local http =  require("socket.http")
  response, code = http.request(req_str);
  if( code == 200 ) then
    return response
  end
  return nil
end

-- test the get_request_result function
-- local req_str = generate_search_req("haha")
-- print(get_request_result(req_str))
function get_sub_ids_by_keyword( keyword )
  local req = generate_search_req(keyword)
  local response = get_request_result( req )

  -- if faild to request the subs
  if( response == nil ) then
    return nil
  end

  -- pares the ids from response
  local cjson = require 'cjson'
  local data = cjson.decode(response)
  local sub_array = data["sub"]["subs"]
  local ids = {}
  for i = 1, #sub_array do
    ids[i] = sub_array[i]["id"]
  end
  return ids
end

-- local ids = get_sub_ids_by_keyword("haha")
-- for i = 1 , #ids do
--   print(ids[i])
-- end

function get_url_from_id( id )
  local req_str = generate_sub_detail_req(id)
  local response = get_request_result(req_str)

  if( response == nil ) then
    return nil
  end

  local cjson = require 'cjson'
  local data = cjson.decode(response)
  result = {}
  result["title"] = data["sub"]["subs"][1]["title"]
  result["url"] = data["sub"]["subs"][1]["url"]
  print(result["title"])
  print(result["url"])
  return result
end

function get_all_sub_url_by_keyword( keyword )
  local ids = get_sub_ids_by_keyword(keyword)

  if( ids == nil ) then
    return nil
  end

  result = {}
  for i = 1, #ids do
    local urlinfo = get_url_from_id( ids[i] )
    if( urlinfo ~= nil ) then
      result[i] = urlinfo
    end
  end
  return result
end

-- local subs = get_all_sub_url_by_keyword( "haha" )
-- local inspect = require "inspect"
-- print(inspect(subs))
