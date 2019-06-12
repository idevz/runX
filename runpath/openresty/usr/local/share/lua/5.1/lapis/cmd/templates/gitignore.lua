local insert, concat
do
  local _obj_0 = table
  insert, concat = _obj_0.insert, _obj_0.concat
end
return function(flags)
  if flags == nil then
    flags = { }
  end
  local lines = {
    "logs/",
    "nginx.conf.compiled"
  }
  if not flags.lua then
    insert(lines, "*.lua")
  end
  if flags.tup then
    insert(lines, ".tup")
  end
  return concat(lines, "\n") .. "\n"
end
