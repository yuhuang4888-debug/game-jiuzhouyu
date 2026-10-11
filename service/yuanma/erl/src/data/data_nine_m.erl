%% ---------------------------------------------------------------------------
%% @doc data_nine_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿手动配置
%% ---------------------------------------------------------------------------
-module(data_nine_m).
-compile([export_all]).

-include("role_nine.hrl").

%% 获取增加的积分
get_add_score(Att, Die) ->
    #nine_rank{dkill = A} = Att,
    #nine_rank{dkill = D} = Die,
    Score = 80*(1+get_att_args(A+1))*(1+get_die_args(D)),
    umath:floor(Score).

get_att_args(N) when N=<0->0;
get_att_args(N) when 1=<N andalso N=<5 -> 0.1;
get_att_args(N) when 6=<N andalso N=<10 -> 0.2;
get_att_args(N) when 11=<N andalso N=<15 -> 0.35;
get_att_args(N) when 16=<N andalso N=<30 -> 0.5;
get_att_args(N) when 31=<N andalso N=<50 -> 0.7;
get_att_args(_N) -> 1.

get_die_args(N) when N=<0 ->0;
get_die_args(N) when 1=<N andalso N=<5 -> 0.1;
get_die_args(N) when 6=<N andalso N=<10 -> 0.2;
get_die_args(N) when 11=<N andalso N=<15 -> 0.4;
get_die_args(N) when 16=<N andalso N=<30 -> 0.5;
get_die_args(N) when 31=<N andalso N=<50 -> 0.8;
get_die_args(_N) -> 1.
