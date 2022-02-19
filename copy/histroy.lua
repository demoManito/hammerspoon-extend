-- 自定义菜单栏
local frequency = 0.8 -- 速度以秒为单位来检查剪贴板的变化。如果你检查过于频繁,就会松性能,如果你检查稀疏松散的副本
local hist_size = 20 -- 历史记录的最大数量
local label_length = 70
local honor_clearcontent = false -- 如果任何应用程序清除纸板,我们也将它从历史中删除 https://groups.google.com/d/msg/hammerspoon/skEeypZHOmM/Tg8QnEj_N68J
local pasteOnSelect = false

local jumpcut = hs.menubar.new()
jumpcut:setTooltip("Clipboard history")
-- 剪贴板 http://www.hammerspoon.org/docs/hs.pasteboard.html
local pasteboard = require("hs.pasteboard")
-- 操作系统底层剪切板需要使用 http://www.hammerspoon.org/docs/hs.settings.html
local settings = require("hs.settings") 
-- 显示粘贴板所有者更改的次数
local last_change = pasteboard.changeCount()

-- clipboard_history 数组，用来存储剪贴板历史记录
-- 如果系统上未保存任何历史记录，创建空历史记录
local clipboard_history = settings.get("so.victor.hs.jumpcut") or {}

function subStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = subStringGetTotalIndex(str) + startIndex + 1
    end
    if endIndex ~= nil and endIndex < 0 then
        endIndex = subStringGetTotalIndex(str) + endIndex + 1
    end
    if endIndex == nil then 
        return string.sub(str, subStringGetTrueIndex(str, startIndex))
    else
        return string.sub(str, subStringGetTrueIndex(str, startIndex), subStringGetTrueIndex(str, endIndex + 1) - 1)
    end
end

-- 返回当前截取字符串正确下标
function subStringGetTrueIndex(str, index)
    local curIndex = 0
    local i = 1
    local lastCount = 1
    repeat 
        lastCount = subStringGetByteCount(str, i)
        i = i + lastCount
        curIndex = curIndex + 1
    until(curIndex >= index)
    return i - lastCount
end

-- 返回当前字符实际占用的字符数
function subStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount
end

function putOnPaste(string,key)
   if (pasteOnSelect) then
      hs.eventtap.keyStrokes(string)
      pasteboard.setContents(string)
      last_change = pasteboard.changeCount()
   else
      if (key.alt == true) then -- If the option/alt key is active when clicking on the menu, perform a "direct paste", without changing the clipboard
         hs.eventtap.keyStrokes(string) -- Defeating paste blocking http://www.hammerspoon.org/go/#pasteblock
      else
         pasteboard.setContents(string)
         last_change = pasteboard.changeCount() -- Updates last_change to prevent item duplication when putting on paste
      end
   end
end

-- 清除剪 贴板/历史 的所有记录
function clearAll()
   pasteboard.clearContents()
   clipboard_history = {}
   settings.set("so.victor.hs.jumpcut",clipboard_history)
   now = pasteboard.changeCount()
   jumpcut:setTitle("✂")
end

-- 扫清了最后添加到历史
function clearLastItem()
   table.remove(clipboard_history,#clipboard_history)
   settings.set("so.victor.hs.jumpcut",clipboard_history)
   now = pasteboard.changeCount()
   jumpcut:setTitle("✂")
end

-- 循环执行限制数量的元素。删除最老的项目
function pasteboardToClipboard(item)
   while (#clipboard_history >= hist_size) do
      table.remove(clipboard_history,1)
   end
   table.insert(clipboard_history, item)
   settings.set("so.victor.hs.jumpcut",clipboard_history) -- updates the saved history
   jumpcut:setTitle("✂")
end

populateMenu = function(key)
    jumpcut:setTitle("✂")
    menuData = {}
    if (#clipboard_history == 0) then
        table.insert(menuData, {title="None", disabled = true}) -- If the history is empty, display "None"
    else
        for k,v in pairs(clipboard_history) do
            if (string.len(v) > label_length) then
                table.insert(menuData,1, {title=subStringUTF8(v,0,label_length).."…", fn = function() putOnPaste(v,key) end }) -- Truncate long strings
            else
                table.insert(menuData,1, {title=v, fn = function() putOnPaste(v,key) end })
            end
        end
    end
    table.insert(menuData, {title="-"})
    table.insert(menuData, {title="Clear All", fn = function() clearAll() end })

    return menuData
end

-- 如果粘贴板被更改，我们将当前项添加到历史记录中并更新计数器
function storeCopy()
   now = pasteboard.changeCount()
   if (now > last_change) then
      current_clipboard = pasteboard.getContents()
      if (current_clipboard == nil and honor_clearcontent) then
        clearLastItem()
      else
        pasteboardToClipboard(current_clipboard)
      end
      last_change = now
   end
end

timer = hs.timer.new(frequency, storeCopy)
timer:start()
jumpcut:setTitle("✂")
jumpcut:setMenu(populateMenu)
hs.hotkey.bind({"cmd", "shift"}, "v", function() jumpcut:popupMenu(hs.mouse.getAbsolutePosition()) end)
