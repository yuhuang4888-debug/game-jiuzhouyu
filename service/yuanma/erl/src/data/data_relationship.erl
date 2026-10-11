%%-----------------------------------------------------------------------------
%% @Module  :       data_relationship
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-06
%% @Description:    社交系统配置
%%-----------------------------------------------------------------------------
-module(data_relationship).
-include("relationship.hrl").

-compile([export_all]).

% get_max_intimacy() ->
%     case data_rela:get_intimacy_lv_cfg_ids() of
%         [MaxIntimacyLvId|_] ->
%             #intimacy_lv_cfg{intimacy = MaxIntimacy} = data_rela:get_intimacy_lv_cfg(MaxIntimacyLvId),
%             MaxIntimacy;
%         _ -> 0
%     end.

get_intimacy_lv(Intimacy) ->
    %% 这里获取到的ids列表是根据所需亲密度降序排列的
    AllIds = data_rela:get_intimacy_lv_cfg_ids(),
    do_get_intimacy_lv(AllIds, Intimacy).

do_get_intimacy_lv([], _) -> 0;
do_get_intimacy_lv([Id|Ids], Intimacy) ->
    case data_rela:get_intimacy_lv_cfg(Id) of
        #intimacy_lv_cfg{intimacy = NeedIntimacy} when Intimacy >= NeedIntimacy -> Id;
        _ -> do_get_intimacy_lv(Ids, Intimacy)
    end.

get_intimacy_attr(Intimacy) ->
    case get_intimacy_lv(Intimacy) of
        Lv when Lv > 0 ->
            #intimacy_lv_cfg{attr = Attr} = data_rela:get_intimacy_lv_cfg(Lv),
            Attr;
        _ -> []
    end.

get_exp_buff(Intimacy) ->
    AttrList = get_intimacy_attr(Intimacy),
    case lists:keyfind(exp, 1, AttrList) of
        {exp, ExpBuff} -> ExpBuff;
        _ -> 0
    end.
