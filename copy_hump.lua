hs.hotkey.bind({"cmd","alt"},"N",function ()
  copy_context = string.gsub(hs.pasteboard.getContents(), "_([a-z]?)", string.upper)   
  hs.pasteboard.setContents(copy_context)
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)