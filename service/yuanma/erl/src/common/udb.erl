%%% -------------------------------------------------------
%%% @author huangyongxing@yeah.net
%%% @doc
%%% DB相关一些常用辅助接口
%%% @end
%%% -------------------------------------------------------
-module(udb).
-export([
        save_data_list/3
    ]).

%% 保存数据列表
%% 注：
%% 如果可能涉及特殊字符，需要防注入的情况，直接使用db:insert_batch/2
%% 通常情况下不需要防注入，此时可以使用这个接口更直观好用，
%% （DataFmtFun/1返回<<>>时，该数据将被过滤掉）
%%
%% save_data_list(DataList, SqlPrefix, DataFmtFun)
%% DataList为数据列表 DataList :: [Data]
%% SqlPrefix为Sql(insert/replace)的前面部分，不带VALUES
%% DataFmtFun :: function()，并且是单个参数的，
%%     参数为DataList中的每个Data
%%     返回值为单个数据格式化的字符串binary值
%% 使用示例：
%%   SqlPrefix = <<"INSERT INTO `test` (c1,c2,c3)"/utf8>>,
%%   DataFmtFun = fun(#test{c1 = C1, c2 = C2, c3 = C3}) ->
%%           util:fmt_bin("(~w,~w,'~ts')", [C1, C2, C3])
%%   end,
%%   save_data_list(DataList, SqlPrefix, DataFmtFun)
save_data_list([Data], SqlPrefix, DataFmtFun) when is_function(DataFmtFun, 1) ->
    FmtDataBin = DataFmtFun(Data),
    case sql_fmt_data(SqlPrefix, FmtDataBin) of
        <<>> -> ignore;
        Sql  -> db:execute(Sql)
    end;
save_data_list(DataList = [_|_], SqlPrefix, DataFmtFun) when is_function(DataFmtFun, 1) ->
    %% 过滤掉DataFmtFun/1执行结果为<<>>的数据
    FmtDataList = lists:foldr(fun(Data, Acc) ->
                case DataFmtFun(Data) of
                    <<>> -> Acc;
                    FmtData -> [FmtData | Acc]
                end
        end, [], DataList),
    FmtDataBin = util:join_bitstring(FmtDataList, <<",">>),
    case sql_fmt_data(SqlPrefix, FmtDataBin) of
        <<>> -> ignore;
        Sql  -> db:execute(Sql)
    end;
save_data_list(_, _SqlPrefix, _DataFmtFun) ->
    ignore.

sql_fmt_data(_SqlPrefix, <<>>) ->
    <<>>;
sql_fmt_data(SqlPrefix, FmtDataBin) ->
    case is_binary(SqlPrefix) of
        true  -> util:fmt_bin(<<SqlPrefix/binary, " VALUES ~ts"/utf8>>, [FmtDataBin]);
        false -> util:fmt_bin(<<"~ts VALUES ~ts"/utf8>>, [SqlPrefix, FmtDataBin])
    end.

