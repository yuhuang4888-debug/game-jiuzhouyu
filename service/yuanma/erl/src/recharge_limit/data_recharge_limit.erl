%% ---------------------------------------------------------------------------
%% @doc data_recharge_limit

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/23
%% @deprecated  充值活动限制手动配置（暂时使用手动配置，之后做成php配置）
%% ---------------------------------------------------------------------------
-module(data_recharge_limit).

%% API
-compile([export_all]).

%% 是否开启
is_open() -> true.

%% 开启时间
duration_time() -> {0, 99999999999}.

%% 开启天数
duration_opday() -> {3, 5}.


