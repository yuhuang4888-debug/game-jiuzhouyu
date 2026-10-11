%% ---------------------------------------------------------------------------
%% @doc lib_timer_custom.erl

%% @author hjh
%% @since  2016-09-22
%% @deprecated 定时器定制函数
%% ---------------------------------------------------------------------------
-module(lib_timer_custom).

-export([make_record/2]).

-include("timer_custom.hrl").

make_record(timer_custom, [Type, Subtype, TimeType, Time, OtherData]) ->
    #timer_custom{
        key = {Type, Subtype, TimeType},
        type = Type,
        subtype = Subtype,
        time_type = TimeType,
        time = Time,
        other_data = OtherData
    }.