%%% -------------------------------------------------------
%%% @author huangyongxing@yeah.net
%%% @doc
%%% 字符串编码相关检测和处理
%%%
%%% 主要用于修正后台接口相关字符串被转换为iolist，
%%% 导致不能正确处理编码的问题。
%%% @end
%%% -------------------------------------------------------
-module(text_enc).
-export([
        get_text/1
        ,get_text/2
        ,fix_enc/1
        ,fix_enc/2
        ,is_latin1_bytes/1
        ,is_utf8_bytes/1
    ]).

%% 识别编码，获取可识别到的字符串内容（如果数据有错，则只提取前面可识别部分）
%%
%% 调用此接口时，如果碰上不正确的参数，会忽略掉错误内容，
%% 取得前面可能的部分字符串（可能是空字符串）
%% 如果这不是你希望的行为，则应该调用fix_enc/1,2
get_text(Text) ->
    get_text(Text, binary).
get_text(Text, ReturnType) ->
    case fix_enc(Text, ReturnType) of
        {error, TextPart, _RestData} -> TextPart;
        {incomplete, TextPart, _Binary} -> TextPart;
        CharData -> CharData
    end.

%% 检查字符串list是否是unicode list，如果不是的情况下，
%% 默认转换为utf8编码的binary（可以指定返回unicode list）
%% 前提条件是已知的参数必须是字符串，不可以传入非字符串的list
%% PS: 主要是针对web后台接口调用及源码字符串处理产生的问题
%%     为了兼容处理，可以用这个接口进行简易处理，
%%     避免后面的接口将数据当作unicode:charlist()导致编码错误
%% 注1：程序中字符串有三种不同的输入数据源
%%   1. web后台传入，通过mochijson2:decode/1之后，
%%      list的编码不是unicode:charlist()，而是utf8 binary对应的字节列表，
%%      例如："中国"
%%         unicode:charlist() 为 [20013,22269]
%%         web后台传入数据经转换后结果为 [228,184,173,229,155,189]
%%   2. 客户端通过网络传输过来的字符串为标准utf8编码（或其他地方输入），
%%      其值通常为unicode:unicode_binary()，
%%      也可能是经过binary_to_list转换为utf8字节列表
%%      或调用unicode:characters_to_list转换为unicode:charlist()，例如：
%%      "中国"
%%         utf8 binary   <<228,184,173,229,155,189>>
%%         utf8 字节列表 [228,184,173,229,155,189]
%%         unicode:charlist() 为 [20013,22269]
%%   3. 源码中的字符串（查看unicode模块和 "Erlang Reference Manual" 中的
%%    "Character Set and Source File Encoding"一节）。
%%    源码未指定latin1编码的，如果是list的字符串，
%%    一般是采用 unicode:charlist() 来表示字符串。
%%    （用unicode模块的接口可正确转换）
%%    而这里的fix_enc，一般会判断既不是utf8字节列表也不是latin1字节列表，
%%    从而正确调用到unicode模块的接口，
%%    但是当存在混合了utf8字节列表与unicode:charlist() 的数据时，
%%    调用到unicode模块的接口时会返回错误值{error, binary() | list(), RestData}
%%
%%    这里推荐源码中（尤其是配置中）统一采用unicode:unicode_binary()
%%    来表示字符串，这样就保证了字符串用的是utf8编码的列表数据或二进制数据，
%%    与前面两种数据能很好地进行拼接，不易出现编码混杂问题。
%%
%% 注2：当存在某些接口，需要拼接不同来源的数据，
%%   形成 unicode:charlist() 和 utf8 binary 字节列表的拼接时
%%   （一般情况下没有此类问题），
%%   有可能会出现编码错误的问题
%%   （特定的一些字符，主要是unicode编码为128-255之间
%%   的字符，与latin1是一致的，但是与UTF8编码不一致），
%%   需要注意在拼接前先统一成相同的形式再做处理。
-spec fix_enc(Text :: unicode:chardata()) -> Result when
    Result :: unicode:charlist() |
    {error, unicode:charlist(), RestData :: any()} |
    {incomplete, unicode:charlist(), binary()}.
fix_enc(Text) ->
    fix_enc(Text, binary).

%% 输入参数Text是一个列表，
%% 可能为字节列表，也可能是unicode列表（unicode:charlist()）
%%
%% 在正常编码情况下，这两种情况都可以得到正常的utf8编码字符串
-spec fix_enc(Text, ReturnType) -> Result when
    Text :: unicode:chardata(),
    ReturnType :: binary | list,
    Result :: unicode:charlist() |
    {error, unicode:charlist(), RestData :: any()} |
    {incomplete, unicode:charlist(), binary()}.
fix_enc(Text = [_|_], ReturnType) ->
    case is_utf8_bytes(Text) of
        true  ->
            %% 符合UTF8编码的字节列表，必须先转换为binary，才能正常识别编码
            Utf8Bin = list_to_binary(Text),
            case ReturnType of
                list   -> unicode:characters_to_list(Utf8Bin);
                _      -> Utf8Bin
            end;
        false ->
            case is_latin1_bytes(Text) of
                true  ->
                    %% 符合ISO latin1编码的字节列表
                    Bin = list_to_binary(Text),
                    case ReturnType of
                        list   -> unicode:characters_to_list(Bin, latin1);
                        _      -> unicode:characters_to_binary(Bin, latin1)
                    end;
                false ->
                    %% 其他非字节的列表，或者其他编码的字节列表，
                    %% 直接当作unicode列表进行尝试转换为binary或原样返回list
                    %% 注意：如果传递了混合编码的列表进来，会引发返回错误值
                    %%       本接口无法做准确处理，只能调用方自行纠正
                    case ReturnType of
                        binary -> unicode:characters_to_binary(Text);
                        _      -> unicode:characters_to_list(Text)
                    end
            end
    end;
fix_enc("",     list)   -> "";
fix_enc("",     binary) -> <<>>;
fix_enc(<<>>,   list)   -> "";
fix_enc(<<>>,   binary) -> <<>>;
fix_enc(Bin, ReturnType) when is_binary(Bin) ->
    case is_utf8_bytes(Bin) of
        true  ->
            case ReturnType of
                list -> unicode:characters_to_list(Bin);
                _    -> Bin
            end;
        false ->
            %% 二进制数据，可以适用宽松的latin1编码
            case ReturnType of
                list -> unicode:characters_to_list(Bin, latin1);
                _    -> unicode:characters_to_binary(Bin, latin1)
            end
    end;
%% 错误数据格式，返回空字符串
fix_enc(_, list)   -> "";
fix_enc(_, binary) -> <<>>.

%% 检查是否符合ISO latin1编码标准(每字节0-255)的字节列表、二进制数据
%% 一般而言，字符串中，只有多字节的Unicode编码列表，才会返回false
is_latin1_bytes([C | CharList]) when C >= 0 andalso C =< 255 ->
    is_latin1_bytes(CharList);
is_latin1_bytes([_ | _CharList]) ->
    false;
is_latin1_bytes([]) ->
    true;
is_latin1_bytes(Bin) when is_binary(Bin) ->
    true.

%% 检测是否UTF-8编码的字符串字节列表、二进制数据
is_utf8_bytes([_|_] = CharList) ->
    case CharList of
        %% 单字节的UTF-8编码字符（与ASCII码重合）
        [C1 | Tail] when
        C1 >= 2#00000000 andalso C1 =< 2#01111111 ->
            is_utf8_bytes(Tail);
        %% 两字节的UTF-8编码字符
        [C1, C2 | Tail] when
        C1 >= 2#11000000 andalso C1 =< 2#11011111 andalso
        C2 >= 2#10000000 andalso C2 =< 2#10111111 ->
            is_utf8_bytes(Tail);
        %% 三字节的UTF-8编码字符
        [C1, C2, C3 | Tail] when
        C1 >= 2#11100000 andalso C1 =< 2#11101111 andalso
        C2 >= 2#10000000 andalso C2 =< 2#10111111 andalso
        C3 >= 2#10000000 andalso C3 =< 2#10111111 ->
            is_utf8_bytes(Tail);
        %% 四字节的UTF-8编码字符
        [C1, C2, C3, C4 | Tail] when
        C1 >= 2#11110000 andalso C1 =< 2#11110111 andalso
        C2 >= 2#10000000 andalso C2 =< 2#10111111 andalso
        C3 >= 2#10000000 andalso C3 =< 2#10111111 andalso
        C4 >= 2#10000000 andalso C4 =< 2#10111111 ->
            is_utf8_bytes(Tail);
        _ -> false
    end;
is_utf8_bytes([]) -> true;
is_utf8_bytes(<<_:8, _/binary>> = Binary) ->
    case Binary of
        %% 单字节的UTF-8编码字符（与ASCII码重合）
        <<C1:8, Tail/binary>> when
        C1 >= 2#00000000 andalso C1 =< 2#01111111 ->
            is_utf8_bytes(Tail);
        %% 两字节的UTF-8编码字符
        <<C1:8, C2:8, Tail/binary>> when
        C1 >= 2#11000000 andalso C1 =< 2#11011111 andalso
        C2 >= 2#10000000 andalso C2 =< 2#10111111 ->
            is_utf8_bytes(Tail);
        %% 三字节的UTF-8编码字符
        <<C1:8, C2:8, C3:8, Tail/binary>> when
        C1 >= 2#11100000 andalso C1 =< 2#11101111 andalso
        C2 >= 2#10000000 andalso C2 =< 2#10111111 andalso
        C3 >= 2#10000000 andalso C3 =< 2#10111111 ->
            is_utf8_bytes(Tail);
        %% 四字节的UTF-8编码字符
        <<C1:8, C2:8, C3:8, C4:8, Tail/binary>> when
        C1 >= 2#11110000 andalso C1 =< 2#11110111 andalso
        C2 >= 2#10000000 andalso C2 =< 2#10111111 andalso
        C3 >= 2#10000000 andalso C3 =< 2#10111111 andalso
        C4 >= 2#10000000 andalso C4 =< 2#10111111 ->
            is_utf8_bytes(Tail);
        _ -> false
    end;
is_utf8_bytes(<<>>) -> true;
is_utf8_bytes(_) -> false.

