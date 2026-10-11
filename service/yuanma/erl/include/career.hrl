%% ---------------------------------------------------------------------------
%% @doc career.hrl
%% @author ming_up@foxmail.com
%% @since  2016-12-22
%% @deprecated 
%% ---------------------------------------------------------------------------

-define(ETS_CAREER_COUNT, ets_career_count). %% 职业统计表

-record(career, {
          career_id=0,    %% 职业类型
          career_name="", %% 职业名字
          sex = 1         %% 性别
         }).
