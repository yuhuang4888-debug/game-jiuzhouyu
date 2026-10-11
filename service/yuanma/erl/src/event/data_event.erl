%% ---------------------------------------------------------------------------
%% @doc 事件管理器
%% @author hek
%% @since  2016-09-09
%% @deprecated 事件管理器,不带玩家PS
%% 
%% Note:
%% 每次都会触发的回调事件，不能进行移除操作
%% 添加暂时触发的事件，触发后可以移除
%% ---------------------------------------------------------------------------

-module (data_event).
-include ("def_event.hrl").
-export ([get_static_event/1]).

%% 注意:需要描述传入参数

%% #event_callback.data: #{role_id=>RoleId, picture=>NewPicture, picture_ver=>NewPictureVer}
get_static_event(?EVENT_PICTURE_CHANGE) ->
    [
        {mod_chat_agent, handle_event, []}
    ];

get_static_event(_Event) ->
    [].
