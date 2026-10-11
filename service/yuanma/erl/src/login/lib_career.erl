%% ---------------------------------------------------------------------------
%% @doc lib_career.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-06-10
%% @deprecated 创建角色以及相关接口,代码上根据职业判断的都在这里写,方便增加职业统一修改
%% ---------------------------------------------------------------------------

-module(lib_career).
-compile(export_all).

-include("predefine.hrl").

%% 获得随机职业以及对应的性别
rand_career_and_sex() ->
    Career = urand:list_rand(?CAREER_LIST),
    SexList = data_career:get_sex_list(Career),
    Sex = urand:list_rand(SexList),
    {Career, Sex}.

%% 注册新职业(默认值都是第一个职业)
%% @param ClientCareer 客户端传递的参数,一般来说是一一对应
create_career(ClientCareer) ->
    case ClientCareer of
        ?SOLDIER -> ?SOLDIER;
        ?SWORDGIRL -> ?SWORDGIRL;
        ?KNIGHT -> ?KNIGHT;
        ?ARCHER -> ?ARCHER;
        _ -> ?SOLDIER
    end.
    
%% 根据职业获取头像
get_picture(_Career) ->
    ?INIT_DRESS_UP_PICTURE.
%%    case Career of
%%        ?SOLDIER -> ?SOLDIER_PICTURE;
%%        ?SWORDGIRL -> ?SWORDGIRL_PICTURE
%%        ?KNIGHT -> ?KNIGHT_PICTURE;
%%        ?ARCHER -> ?ARCHER_PICTURE;
%%        _ -> ?SOLDIER_PICTURE
%%    end.

%% 模型id
get_model_id(?LV_MODEL, Part, Career) ->
    case Part of
        ?MODEL_PART_HEAD  when Career == ?SOLDIER       -> 1100;
        ?MODEL_PART_HEAD  when Career == ?SWORDGIRL     -> 1213;
        ?MODEL_PART_HEAD  when Career == ?KNIGHT        -> 1300;
        ?MODEL_PART_HEAD  when Career == ?ARCHER        -> 1400;
        ?MODEL_PART_CLOTH when Career == ?SOLDIER       -> 1111;
        ?MODEL_PART_CLOTH when Career == ?SWORDGIRL     -> 1213;
        ?MODEL_PART_CLOTH when Career == ?KNIGHT        -> 1300;
        ?MODEL_PART_CLOTH when Career == ?ARCHER        -> 1400;
        ?MODEL_PART_WEAPON when Career == ?SOLDIER      -> 1100;
        ?MODEL_PART_WEAPON when Career == ?SWORDGIRL    -> 1200;
        ?MODEL_PART_WEAPON when Career == ?KNIGHT       -> 1300;
        ?MODEL_PART_WEAPON when Career == ?ARCHER       -> 1400;
        _ -> 0 
    end;
get_model_id(_Module, _Part, _Career) ->
    0.