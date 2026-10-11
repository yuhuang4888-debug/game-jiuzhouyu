%% ---------------------------------------------------------------------------
%% @doc advance_fun

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/9/23
%% @deprecated  功能预告头文件
%% ---------------------------------------------------------------------------
-define(TODAY_MAIL, 1).     %% 今日活动邮件
-define(TOMORROW_MAIL, 2).  %% 明天活动邮件

-record(base_advance_fun, {
    module = 0          %  能读取到活动日历里的开启时间，用于判断是否发邮件
    , module_sub = 0    %  功能id和子功能ID确定唯一活动
    , sure_mail = 2     %  0为不发送，1为当天4:00发送邮件通知，2为前一天4:00和当天4:00都发送邮件通知；默认2
    , mail_title = ""
    , mail_content = ""
}).