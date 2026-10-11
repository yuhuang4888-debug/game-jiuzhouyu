%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             补丁版本
%%% @end
%%% Created : 25. 7月 2022 9:31
%%%-------------------------------------------------------------------
-module(lib_fix_ver).
-author("xzj").

%% API
-compile(export_all).

-include("custom_act.hrl").
-include("common.hrl").
-include("fix_ver.hrl").
-include("server.hrl").
-include("rush_rank.hrl").
-include("def_fun.hrl").

init_fix() ->
    case db:get_all(io_lib:format(?sql_fix_ver_select, [?current_patch_key])) of
        [[Value]] ->
            PatchId = util:bitstring_to_term(Value);
        _ ->
            PatchId = ?current_patch_id
    end,
    #fix_state{current_patch_id = PatchId}.

start_fix(State)->
    #fix_state{current_patch_id = CurrentPatch} = State,
    F = fun() ->
            fix(CurrentPatch)
        end,
    case catch db:transaction(F) of
        {ok, NewPatch} ->
            case NewPatch =/= CurrentPatch of
                true ->
                    db:execute(io_lib:format(?sql_fix_ver_replace, [?current_patch_key, util:term_to_string(NewPatch)]));
                _ -> skip
            end,
            #fix_state{current_patch_id = NewPatch};
        Err ->
            ?ERR("err = ~w~n",[Err]),
            State

    end.

%% 后续有补丁可在次数向上添加，例如下一个分支可写为 fix(Patch = 1)
fix(Patch = 0) ->
    fix_picture(),
    fix(Patch + 1);

fix(Patch) -> {ok, Patch}.

%% 头像修复
fix_picture() ->
    lib_dress_up:gm_migration_picture(),
    ok.


