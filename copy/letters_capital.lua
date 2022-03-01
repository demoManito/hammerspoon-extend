hs.hotkey.bind({"cmd","alt"},"V",function ()
  -- 将 aa_bb_cc_command -> AaBbCcCommand
  copy_context = string.gsub(string.gsub(hs.pasteboard.getContents(), "_([a-z]?)", string.upper), "^[a-z]?", string.upper)
  hs.pasteboard.setContents(copy_context)
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)
