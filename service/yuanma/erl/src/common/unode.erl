%%-----------------------------------------------------------------------------
%% @Module  :       unode.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-02
%% @Description:    节点
%%-----------------------------------------------------------------------------

-module (unode).
-export ([
    apply/4
    ,is_my_node/1
    ]).

apply(undefined, Mod, Fun, Args) ->
    erlang:apply(Mod, Fun, Args);

apply(none, Mod, Fun, Args) ->
    erlang:apply(Mod, Fun, Args);

apply(Node, Mod, Fun, Args) ->
    case node() of
        Node ->
            erlang:apply(Mod, Fun, Args);
        _ ->
            rpc:cast(Node, Mod, Fun, Args)
    end.

is_my_node(Node) ->
    case Node of
        undefined ->
            true;
        none ->
            true;
        _ ->
            node() =:= Node
    end.