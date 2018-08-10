--[[------------------------------------------------------------
zhCN locale by 163UI
---------------------------------------------------------------]]

local name, KT = ...
KT.L = CoreBuildLocale()

local cNote = "|cff00ffe3"

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    --------------- Filters.lua -----------------
    KT.L["Filter"] = "筛选"
    KT.L[" Quests"] = " 任务"
    KT.L[" Achievements"] = " 成就"
    KT.L["Quests"] = "任务"
    KT.L["All"] = "全部"
    KT.L["|cff00ff00Auto|r Zone"] = "|cff00ff00自动|r 当前地图"
    KT.L["Zone"] = "当前地图"
    KT.L["Daily"] = "日常"
    KT.L["Instance"] = "副本"
    KT.L["Complete"] = "已完成"
    KT.L["Untrack All"] = "取消全部追踪"
    KT.L["Achievements"] = "成就"
    KT.L["Categories"] = "分类"
    KT.L["World Event"] = "世界事件"
    KT.L["WEvent"] = "世界事件"
    KT.L["Pets"] = "宠物"
    KT.L["Check All"] = "选择全部"
    KT.L["There is currently no World Event."] = "当前没有世界事件"
    KT.L["World Event - "] = "世界事件 - "

    ------------- KalielsTracker.lua ----------------
    KT.L[name] = "任务追踪增强"
    KT.L["Alt+Click - addon Options"] = "ALT点击\n打开设置面板"
    KT.L["%d/%d Quests  -  %d Dailies"] = "%d/%d 任务 - %d 日常"

    ------------- Options.lua -----------------------
    KT.L["Supported addons"] = "额外支持插件"
    KT.L["|cffff7fff[Beta]|r"] = "|cffff7fff[测试版]|r"
    KT.L["Warning:|r UI will be re-loaded!"] = "警告: 即将重新加载界面"
    KT.L["Options"] = "选项"
    KT.L["Info"] = "信息"
    KT.L[" |cffffd100Version:|r  "] = " |cffffd100版本号:|r  "
    KT.L["Position / Size"] = "位置 / 尺寸"
    KT.L["Anchor point"] = "锚点"
    KT.L["X offset"] = "横向位置"
    KT.L["Y offset"] = "纵向位置"
    KT.L["Max. height"] = "最大高度"
    KT.L[" Max. height is related with value Y offset.\n"..
            " Content is lesser ... tracker height is automatically increases.\n"..
            " Content is greater ... tracker enables scrolling."] = " 最大高度与纵向位置相关：\n 如果条目少, 追踪窗口会自动适应高度\n 如果条目继续增多，则支持滚动"
    KT.L["Show scroll indicator"] = "显示滚动条"
    KT.L["Strata"] = "滚动条优先级"
    KT.L["Background / Border"] = "背景 / 边框"
    KT.L["Background texture"] = "背景材质"
    KT.L["Background color"] = "背景颜色"
    KT.L[" For a custom background\n texture set white color."] = "自定义材质请使用白色"
    KT.L["Border texture"] = "边框材质"
    KT.L["Border color"] = "边框颜色"
    KT.L["Border color by |cff%sClass|r"] = "边框使用|cff%s职业|r颜色"
    KT.L["Border transparency"] = "边框透明度"
    KT.L["Border thickness"] = "边框粗细"
    KT.L["Background inset"] = "背景缩进"
    KT.L["Texts"] = "文本"
    KT.L["Font"] = "字体"
    KT.L["Font size"] = "文字大小"
    KT.L["Font flag"] = "字体风格"
    KT.L["Font shadow"] = "文字阴影"
    KT.L["Color by difficulty"] = "使用难度颜色"
    KT.L["Wrap long texts"] = "长文本换行"
    KT.L["Long texts shows on two lines or on one line with ellipsis (...)."] = "长文本多行显示或者单行在末尾显示省略号(...)"
    KT.L["Objective numbers at the beginning "] = "目标数字在前面"
    KT.L["Changing the position of objective numbers at the beginning of the line. "..
            cNote.."Only for deDE, esES, frFR, ruRU locale."] = cNote.."中文已经是这样了"
    KT.L["Headers"] = "标题栏"
    KT.L[" Texture"] = "材质"
    KT.L["Color"] = "颜色"
    KT.L["Use border color"] = "使用边框颜色"
    KT.L["Use border |cff"] = "使用边框|cff"
    KT.L["color|r"] = "颜色|r"
    KT.L[" Text"] = "文本"
    KT.L[" Buttons"] = "按钮"
    KT.L[" Collapsed\n text"] = "窗口收起时的文本"
    KT.L["None"] = "无"
    KT.L["%d/%d Quests"] = "%d/%d 任务"
    KT.L["Show Quest Log and Achievements buttons"] = "显示任务日志和成就按钮"
    KT.L["Key - Minimize button"] = "热键 - 最小化"
    KT.L["Quest item buttons"] = "任务物品按钮"
    KT.L["Show buttons block background and border"] = "显示物品按钮区的背景和边框"
    KT.L["Enable Active button "] = "启用自动按钮"
    KT.L["Key - Active button"] = "热键 - 自动按钮"
    KT.L["Show Quest item button for CLOSEST quest as \"Extra Action Button\". "..
            cNote.."Key bind is shared with EXTRAACTIONBUTTON1."] = "在'额外快捷键1'上显示最近任务的物品\n"..cNote.."与'额外快捷键1'共享热键"
    KT.L["Other options"] = "其他选项"
    KT.L["Show tooltips"] = "显示鼠标提示"
    KT.L["Show ID"] = "显示任务ID"
    KT.L["Wowhead URL"] = "数据库链接"
    KT.L["Wowhead URL click modifier"] = "数据库链接功能键"
    
    KT.L["Hide empty tracker"] = "没有追踪条目时隐藏"
    KT.L["Collapse in instance"] = "副本中自动收起"
    KT.L["Output for tracker messages"] = "任务进度通报频道"
    KT.L["Show number of Quests"] = "显示任务数量"
    KT.L["Show Achievement points"] = "显示成就点数"
    KT.L["Show number of owned Pets"] = "显示战斗宠物数"
    KT.L[" /kt|r  |cff808080...............|r  Toggle (expand/collapse) the tracker\n"] = " /kt|r  |cff808080...............|r  收起/展开任务追踪框"
    KT.L[" /kt config|r  |cff808080...|r  Show this config window\n"] = " /kt config|r  |cff808080...|r  显示现在这个配置窗口"

    KT.L["Legion Invasion Monitor"] = "军团入侵监控"
    KT.L["Legion Invasion"] = "军团入侵"
    KT.L["Special"] = "特别奉献"
end