# hammerspoon-extend
hammerspoon extend apply （http://www.hammerspoon.org/go/#helloworld）

# Used to introduce
1. install hammerspoon <br>
`brew install hammerspoon`

2. See to .hammerspoon file <br>
`cd  ~/.hammerspoon`

3. create file <br>
`touch init.lua`

4. init.lua import content
```lua
    -- 首字母和下划线首字母转驼峰
    require "hammerspoon-extend.copy.letters_capital"
    -- 下划线转驼峰
    require "hammerspoon-extend.copy.hump_strikethrough"
    -- 中划线转驼峰
    require "hammerspoon-extend.copy.hump"
    -- 剪切历史
    require "hammerspoon-extend.copy.histroy"
   
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
        hs.alert.show("Hello World!")
    end)
```

5. clone hammerspoon-extend folder <br>
`git clone git@github.com:demoManito/hammerspoon-extend.git`

6. refresh hammerspoon config <br>
![image](https://user-images.githubusercontent.com/27986239/142556385-1a97be52-c970-4f5a-b7ef-43def1af4812.png)


# how to use
search project Search in the project: `hs.hotkey.bind`, the binding of key, example:
![image](https://user-images.githubusercontent.com/27986239/142556484-2ba2850f-27d8-405c-8122-c87a83bb2327.png)

# extra
Increase content in a separate folder

