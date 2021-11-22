hs.hotkey.bind({"cmd","alt"},"B",function ()
  -- 中划线转驼峰
  copy_context = string.gsub(hs.pasteboard.getContents(), "-([a-z]?)", string.upper)   
  hs.pasteboard.setContents(copy_context)
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)
