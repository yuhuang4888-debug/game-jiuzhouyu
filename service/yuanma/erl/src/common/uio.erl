%% ---------------------------------------------------------------------------
%% @doc uio
%% @author ming_up@foxmail.com
%% @since  2016-04-08
%% @deprecated 带顺序的string格式化
%% ---------------------------------------------------------------------------

%% eg: "uio:format("you are the no.{1}", [2])" 
%%     = "you are the no.2"
-module(uio).

-export([format/2, thing_to_string/1]).

%% @param Args [<<"参数1"/utf8>>, intger(),...]
format("", _) -> "";
format(Format, []) -> Format;
format(Format, Args) when is_list(Format),is_list(Args) ->
    % 转换成utf8的编码
    FormatBin = ulists:list_to_bin(Format), 
    String = collect(binary_to_list(FormatBin), Args, []),
    lists:reverse(String);
%% 二进制默认是utf8编码
format(Format, Args) when is_binary(Format),is_list(Args) ->
    String = collect(binary_to_list(Format), Args, []),
    lists:reverse(String).

collect([${|T], Args, Head) -> 
    case get_num(T, []) of
        {true, Nth, LT} -> 
            NthArg = case catch lists:nth(Nth, Args) of
                {'EXIT', _} -> ulists:concat(["{",Nth,"}"]);
                Other -> Other
            end,
            collect(LT, Args, lists:reverse(thing_to_string(NthArg)) ++ Head);
        {false, PT, LT} -> collect(LT, Args, PT++[${|Head])
    end;
collect([H|T], Args, Head) -> 
    collect(T, Args, [H|Head]);
collect([], _Args, Head) -> 
    Head.

get_num([$}|T], RNumL) -> 
    case catch list_to_integer(lists:reverse(RNumL)) of 
        Num when is_integer(Num) -> {true, Num, T};
        _ -> {false, [$}|RNumL], T}
    end;
get_num([${|_]=T, RNumL) -> {false, RNumL, T};
get_num([H|T], RNumL)    -> get_num(T, [H|RNumL]);
get_num([], RNumL)       -> {false, RNumL, []}.

thing_to_string(X) when is_integer(X) -> integer_to_list(X);
thing_to_string(X) when is_float(X)   -> float_to_list(X);
thing_to_string(X) when is_atom(X)    -> atom_to_list(X);
thing_to_string(X) when is_binary(X)  -> binary_to_list(X); %unicode:characters_to_list(X,unicode);
thing_to_string(X) when is_tuple(X)   -> io_lib:format("~w", [X]);
% 只能是utf8的列表
thing_to_string(X) when is_list(X)    -> X.
    % XBin = ulists:list_to_bin(X),
    % binary_to_list(XBin).
