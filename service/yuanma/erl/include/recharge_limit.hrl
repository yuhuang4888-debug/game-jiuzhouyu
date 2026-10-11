%% ---------------------------------------------------------------------------
%% @doc recharge_limit

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/23
%% @deprecated  充值活动限制头文件
%% ---------------------------------------------------------------------------

-define(ETS_RECHARGE_LIMIT, ets_rechage_limit).

-record(ets_recharge_limit, {
    key = {0, []}, %%{accid, accname}
    role_ids = []
}).
