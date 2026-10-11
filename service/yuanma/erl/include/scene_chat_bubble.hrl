%%%------------------------------------------------
%%% File    : scene_chat_bubble.hrl
%%% Author  : liuweichao
%%% Created : 2022-02-14
%%% Description: 场景聊天气泡
%%%------------------------------------------------

-record(base_scene_chat_bubble,{
        bubble_id      = 0,  %% 气泡Id
        object_id      = 0,  %% 对象Id
        object_type    = 0,  %% 对象类型
        bubble_content = "", %% 内容
        condition      = "", %% 条件
        number         = 0,  %% 下一句Id
        min_lv         = 0,  %% 最低触发等级
        max_lv         = 0,  %% 最高触发等级
        bubble_type    = 0   %% 气泡类型
}).