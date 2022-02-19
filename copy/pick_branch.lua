function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

hs.hotkey.bind({"cmd","shift"},"V",function ()
  -- 将 xxx:feature/1111 -> feature/1111
  local list = split(hs.pasteboard.getContents(), ":")
  hs.pasteboard.setContents(list[2])
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)


