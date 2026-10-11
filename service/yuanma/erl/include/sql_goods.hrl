%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-13
%% Description: 物品装备SQL定义
%% --------------------------------------------------------

%% --------------------------------- 生成物品%% ---------------------------------

-define(SQL_LAST_INSERT_ID,         <<"SELECT LAST_INSERT_ID() ">>).

-define(SQL_GOODS_INSERT,
        <<"insert into `goods` set id=~p, player_id=~p, type=~p, subtype=~p, price_type=~p, price=~p,
           suit_id=~p, skill_id=~p, expire_time=~p, `lock_time`=~p, create_time=UNIX_TIMESTAMP() ">>).

-define(SQL_GOODS_LOW_INSERT,
        <<"insert into `goods_low` set gid=~p, pid=~p, gtype_id=~p, equip_type=~p, bind=~p, trade=~p, sell=~p,
           level=~p, color=~p, addition = '~s', extra_attr = '~s', other_data = '~s'">>).

-define(SQL_GOODS_HIGHT_INSERT,
        <<"insert into `goods_high` set gid=~p, pid=~p, goods_id=~p, guild_id=~p, location=~p, sub_location=~p, cell=~p, num=~p ">>).

%% --------------------------------- 获取物品 ---------------------------------

-define(SQL_GOODS_SELECT_BY_ID,
        <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
           sell, level, suit_id, skill_id, location, sub_location, cell, num, color, expire_time,
           lock_time, addition, extra_attr, other_data, create_time
           from `goods` left join `goods_low` gl on id=gl.gid left join `goods_high` gh on id=gh.gid where id=~p ">>).

-define(SQL_GOODS_LIST_BY_LOCATION,
        <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
           sell, level, suit_id, skill_id, location, sub_location, cell, num, color, expire_time,
           lock_time, addition, extra_attr, other_data, create_time
           from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid left join `goods` g on gh.gid=g.id where gh.pid = ~p and location = ~p ">>).

-define(SQL_GOODS_LIST_BY_LOCATION_TYPE,
        <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
           sell, level, suit_id, skill_id, location, sub_location, cell, num, color, expire_time, lock_time, addition, extra_attr, other_data, create_time
           from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid left join `goods` g on gh.gid=g.id where gh.pid = ~p and location = ~p and type = ~p">>).

-define(SQL_GOODS_LIST_BY_TYPE2,
        <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
           sell, level, suit_id, skill_id, location, sub_location, cell, num, color, expire_time, lock_time, addition, extra_attr, other_data, create_time
           from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid left join `goods` g on gh.gid=g.id where gh.pid = ~p and location = ~p and goods_id = ~p and (expire_time = 0 or expire_time > ~p) ">>).

-define(SQL_GOODS_LIST_BY_TYPE3,
        <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
           sell, level, suit_id, skill_id, location, sub_location, cell, num, color, expire_time, lock_time, addition, extra_attr, other_data, create_time
           from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid left join `goods` g on gh.gid=g.id where gh.pid = ~p and location = ~p and bind = ~p and goods_id = ~p and (expire_time = 0 or expire_time > ~p) ">>).

%% -define(SQL_GOODS_LIST_BY_SELL,
%%         <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
%%     sell, level, suit_id, skill_id, location, cell, num, color, expire_time, lock_time, addition, extra_attr, other_data from `goods_high` gh
%%           left join `goods_low` gl on gh.gid=gl.gid left join `goods` g on gh.gid=g.id where gh.location = ~p and g.type=~p ">>).

-define(SQL_GOODS_GET_EQUIP,
        <<"select goods_id from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid left join `goods` g on gh.gid=g.id
           where gh.pid = ~p and location = ~p and type = ~p and equip_type = ~p limit 1">>).

%% -define(SQL_GOODS_LIST_BY_GUILD,
%%         <<"select id, player_id, guild_id, goods_id, type, subtype, equip_type, price_type, price, bind, trade,
%%            sell, level, suit_id, skill_id, location, cell, num, color, expire_time from `goods_high` gh left join `goods_low` gl
%%           on gh.gid=gl.gid left join `goods` g on gh.gid=g.id where gh.guild_id = ~p ">>).

%% --------------------------------- 获取物品 ---------------------------------
%%
-define(SQL_GOODS_LIST_BY_EXPIRE,   <<"select g.id,gh.goods_id,gh.num,gh.location,g.type,gl.equip_type from `goods` g left join `goods_high` gh on g.id=gh.gid left join `goods_low` gl on g.id=gl.gid where g.player_id = ~p and g.expire_time > 0 and g.expire_time <= ~p ">>).

-define(SQL_STORAGE_LIST_BY_GUILD,  <<"select gid, cell, num from `goods_high` where guild_id = ~p and goods_id = ~p and num < ~p for update ">>).
-define(SQL_STORAGE_LIST_BY_TYPE,   <<"select gh.gid, gh.cell, gh.num from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid where  gh.pid = ~p and gh.location = ~p and gh.goods_id = ~p and gl.bind = ~p and gh.num < ~p ">>).
-define(SQL_STORAGE_LIST_BY_GID,    <<"select pid, guild_id, num from `goods_high` where gid = ~p for update ">>).
-define(SQL_STORAGE_TYPE_COUNT1,    <<"select sum(num) from `goods_high` where guild_id = ~p and goods_id = ~p ">>).
-define(SQL_STORAGE_TYPE_COUNT2,    <<"select sum(gh.num) from `goods_high` gh left join `goods_low` gl on gh.gid=gl.gid  where gh.pid = ~p and gh.location = ~p and gh.goods_id = ~p and gl.bind = ~p ">>).
-define(SQL_STORAGE_COUNT1,         <<"select count(gid) from `goods_high` where guild_id = ~p ">>).
-define(SQL_STORAGE_COUNT2,         <<"select count(gid) from `goods_high` where pid = ~p and location = ~p ">>).

-define(SQL_GOODS_UPDATE_NUM,       <<"update `goods_high` set num = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_CELL,      <<"update `goods_high` set location = ~p, cell = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_SUB_LOCATION,      <<"update `goods_high` set location = ~p, sub_location = ~p, cell = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_CELL_NUM,  <<"update `goods_high` set location = ~p, cell = ~p, num = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_CELL_USENUM,<<"update `goods_high` set location = ~p, cell = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_BIND,      <<"update `goods_low` set bind = ~p, trade = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_LEVEL_EXTRA_ATTR,    <<"update `goods_low` set level = ~p, extra_attr = '~s' where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_OTHER,    <<"update `goods_low` set other_data = '~s' where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_EXPIRE,    <<"update `goods` set expire_time = ~p where id = ~p ">>).
-define(SQL_GOODS_UPDATE_SKILL,     <<"update `goods` set skill_id = ~p where id = ~p ">>).

-define(SQL_GOODS_UPDATE_GUILD2,    <<"update `goods_low` set pid = ~p, bind = ~p, trade = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_GUILD3,     <<"update `goods_high` set pid = ~p, guild_id = ~p, location = ~p, cell = ~p, num = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_PLAYER1,   <<"update `goods` set player_id = ~p where id = ~p ">>).
-define(SQL_GOODS_UPDATE_PLAYER2,   <<"update `goods_low` set pid = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_PLAYER3,   <<"update `goods_high` set pid = ~p, location = ~p, cell = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_GOODS1,    <<"update `goods_high` set goods_id = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_GOODS2,    <<"update `goods_low` set gtype_id = ~p, color = ~p where gid = ~p ">>).
-define(SQL_GOODS_UPDATE_GOODS3,    <<"update `goods_low` set gtype_id = ~p, bind = ~p, trade = ~p where gid = ~p ">>).

-define(SQL_GOODS_DELETE_BY_ID,     <<"delete `goods_high`,`goods_low`,`goods` from `goods_high`,`goods_low`,`goods` where `goods_high`.gid=`goods_low`.gid and `goods_high`.gid=`goods`.id and `goods_high`.gid = ~p">>).
-define(SQL_GOODS_DELETE_BY_PLAYER, <<"delete `goods_high`,`goods_low`,`goods` from `goods_high`,`goods_low`,`goods` where `goods_high`.gid=`goods_low`.gid and `goods_high`.gid=`goods`.id and `goods_high`.pid = ~p">>).
-define(SQL_GOODS_DELETE_BY_LOCATION,<<"delete `goods_high`,`goods_low`,`goods` from `goods_high`,`goods_low`,`goods` where `goods_high`.gid=`goods_low`.gid and `goods_high`.gid=`goods`.id and `goods_high`.pid = ~p and `goods_high`.location = ~p ">>).
-define(SQL_GOODS_DELETE_BY_GUILD,  <<"delete `goods_high`,`goods_low`,`goods` from `goods_high`,`goods_low`,`goods` where `goods_high`.gid=`goods_low`.gid and `goods_high`.gid=`goods`.id and `goods_high`.guild_id = ~p">>).

-define(SQL_PLAYER_UPDATE_POINT,	<<"update `player_low` set `point`=~p where `id`=~p">>).
-define(SQL_PLAYER_UPDATE_CELL,     <<"update `player_attr` set cell_num=~p where id=~p">>).
-define(SQL_PLAYER_UPDATE_STORAGE_NUM, <<"update `player_attr` set storage_num=~p where id=~p">>).
-define(SQL_PLAYER_UPDATE_GOD_BAG_NUM, <<"update `player_attr` set god_bag_num=~p where id=~p">>).

%% --------------------------------- 装备模块%% ---------------------------------

-define(SQL_GOODS_UPDATE_ADDITION,              <<"update `goods_low` set color = ~p, addition ='~s' where gid=~p">>).
-define(SQL_GOODS_UPDATE_LEVEL,                 <<"update `goods_low` set level = ~p where gid=~p">>).
-define(SQL_EQUIP_STREN,                        <<"replace into equip_stren(player_id, equip_pos, stren) values(~p, ~p, ~p)">>).
-define(SQL_STREN_LIST,                         <<"select equip_pos, stren from  equip_stren where player_id = ~p">>).

%% 精炼装备
-define(SQL_EQUIP_REFINE,                        <<"replace into equip_refine(player_id, equip_pos, refine) values(~p, ~p, ~p)">>).
-define(SQL_REFINE_LIST,                         <<"select equip_pos, refine from  equip_refine where player_id = ~p">>).


-define(SQL_UNEQUIP_STONE_BY_EQUIP_POS,         <<"delete from equip_stone where player_id = ~p and equip_pos = ~p">>).
-define(SQL_UNEQUIP_STONE,                      <<"delete from equip_stone where player_id = ~p and equip_pos = ~p and stone_pos = ~p">>).
-define(SQL_STONE_LIST,                         <<"select equip_pos, stone_pos, stone_id, bind from equip_stone where player_id = ~p">>).
-define(SQL_STONE_REFINE_LIST,                  <<"select equip_pos, refine_lv, exp from equip_stone_refine where player_id = ~p">>).
-define(SQL_EQUIP_STONE,                        <<"replace into equip_stone(player_id, equip_pos, stone_pos, stone_id, bind) values(~p, ~p, ~p, ~p, ~p)">>).
-define(SQL_EQUIP_STONE_REFINE,                 <<"replace into equip_stone_refine(player_id, equip_pos, refine_lv, exp) values(~p, ~p, ~p, ~p)">>).

% -define(SQL_EQUIP_MAGIC,                        <<"replace into equip_magic(player_id, equip_pos, type, goods_id, end_time) values(~p, ~p, ~p, ~p, ~p)">>).
% -define(SQL_MAGIC_LIST,                         <<"select equip_pos, type, goods_id, end_time from equip_magic where player_id = ~p">>).
% -define(SQL_DELETE_MAGIC,                       <<"delete from equip_magic where player_id = ~p and equip_pos = ~p and type = ~p">>).
% -define(SQL_DELETE_MAGIC_BY_ENDTIME,            <<"delete from equip_magic where player_id = ~p and end_time <= ~p">>).

%% 洗练
-define(SQL_EQUIP_WASH_LIST,                    <<"select equip_pos, duan, wash_rating, attr from equip_wash where role_id = ~p">>).
-define(SQL_EQUIP_WASH,                         <<"replace into equip_wash(role_id, equip_pos, duan, wash_rating, attr) values(~p, ~p, ~p, ~p, '~s')">>).

%%-define(SQL_EQUIP_UPGRADE_DIVISION,             <<"update equip_wash set division = ~p where role_id = ~p and equip_pos = ~p">>).

%% 铸灵
-define(SQL_SELECT_EQUIP_CASTING_SPIRIT,        <<"select pos, stage, lv from equip_casting_spirit where role_id = ~p">>).
-define(SQL_INSERT_EQUIP_CASTING_SPIRIT,        <<"insert into equip_casting_spirit(role_id, pos, stage, lv) values(~p, ~p, ~p, ~p)">>).
-define(SQL_UPDATE_EQUIP_CASTING_SPIRIT,        <<"update equip_casting_spirit set stage = ~p, lv = ~p where role_id = ~p and pos = ~p">>).

%% 护灵
-define(SQL_SELECT_EQUIP_SPIRIT,                <<"select lv from equip_spirit where role_id = ~p">>).
-define(SQL_UPDATE_EQUIP_SPIRIT,                <<"replace into equip_spirit(role_id, lv) values(~p, ~p)">>).

%% 装备觉醒
-define(SQL_SELECT_EQUIP_AWAKENING,             <<"select equip_pos, lv from equip_awakening where role_id = ~p">>).
-define(SQL_INSERT_EQUIP_AWAKENING,             <<"insert into equip_awakening(role_id, equip_pos, lv) values(~p, ~p, ~p)">>).
-define(SQL_UPDATE_EQUIP_AWAKENING,             <<"update equip_awakening set lv = ~p where role_id = ~p and equip_pos = ~p">>).

%% 装备唤魔
-define(SQL_SELECT_EQUIP_SKILL,                 <<"select pos, skill_id, skill_lv from equip_skill where role_id = ~p">>).
-define(SQL_INSERT_EQUIP_SKILL,                 <<"insert into equip_skill(role_id, pos, skill_id, skill_lv) values(~p, ~p, ~p, ~p)">>).
-define(SQL_UPDATE_EQUIP_SKILL,                 <<"update equip_skill set skill_id = ~p, skill_lv = ~p where role_id = ~p and pos = ~p">>).
-define(SQL_UPDATE_EQUIP_SKILL_LV,              <<"update equip_skill set skill_lv = ~p where role_id = ~p and pos = ~p">>).
-define(SQL_DELETE_EQUIP_SKILL,                 <<"delete from equip_skill where role_id = ~p and pos = ~p">>).

%% gift_list 已屏蔽，请看gift.hrl
% -define(SQL_GIFT_QUEUE_INSERT,                  <<"insert into `gift_list` set player_id=~p, gift_id=~p, give_time=~p, status=~p ">>).
% -define(SQL_GIFT_QUEUE_INSERT_FULL,             <<"insert into `gift_list` set player_id=~p, gift_id=~p, give_time=~p, get_num=~p, get_time=~p, status=~p ">>).
% -define(SQL_GIFT_QUEUE_UPDATE_GIVE,             <<"update `gift_list` set give_time=~p, get_time=0, status=~p where player_id=~p and gift_id=~p ">>).
% -define(SQL_GIFT_QUEUE_UPDATE_GET,              <<"update `gift_list` set get_num=get_num+1, get_time=~p, status=1 where player_id=~p and gift_id=~p ">>).
% -define(SQL_GIFT_QUEUE_UPDATE_OFFLINE,          <<"update `gift_list` set offline_time=~p where player_id=~p and gift_id=~p ">>).
% -define(SQL_GIFT_QUEUE_SELECT,                  <<"select gift_id, give_time from `gift_list` where player_id=~p and gift_id=~p limit 1 ">>).
% -define(SQL_GIFT_QUEUE_SELECT_ONLINE,           <<"select gift_id, give_time, offline_time from `gift_list` where player_id=~p and status=0 limit 1 ">>).
% -define(SQL_GIFT_QUEUE_DELETE,                  <<"delete from `gift_list` where player_id=~p ">>).

%% gift_card
-define(SQL_GIFT_CARD_INSERT,                   <<"insert into `gift_card` set player_id=~p, card_no='~s', type=~p, time=~p, status=1 ">>).
-define(SQL_GIFT_CARD_SELECT,                   <<"select status from `gift_card` where card_no='~s' ">>).
-define(SQL_GIFT_CARD_BASE_SELECT,              <<"select card_no from `base_gift_card` where accname='~s' limit 1 ">>).

-define(SQL_CHARGE_SELECT,                      <<"select id from `charge` where player_id=~p and status=1 limit 1 ">>).

-define (SQL_INSERT_CURRENCY,                   <<"INSERT INTO `player_special_currency`(`player_id`, `currency_id`, `num`) VALUES (~p, ~p, ~p)">>).

-define (SQL_UPDATE_CURRENCY,                   <<"UPDATE `player_special_currency` SET `num`=~p WHERE `player_id` = ~p AND `currency_id` = ~p">>).

-define (SQL_REPLACE_CURRENCY,                   <<"REPLACE INTO `player_special_currency`(`player_id`, `currency_id`, `num`) VALUES (~p, ~p, ~p)">>).

-define (LOAD_CURRENCY,                         <<"SELECT `currency_id`, `num` FROM `player_special_currency` WHERE `player_id` = ~p">>).

-define (SQL_DELETE_CURRENCY_BY_CURRENCY_ID,    <<"DELETE FROM `player_special_currency` WHERE `currency_id` = ~p">>).

%% 装备吞噬和洗练
-define(SQL_SELECT_EQUIP_FUSION,           <<"select level, exp from `equip_bag_fusion` where role_id=~p">>).
-define(SQL_BATCH_REPLACE_EQUIP_FUSION,         "replace into `equip_bag_fusion`(`role_id`, `level`, `exp`) values (~p, ~p, ~p)").

%% --------------------------------- 全身奖励 ---------------------------------
-define(SQL_WHOLE_AWARD_SELECT, <<"select type, whole_lv from equip_whole_award_lv where role_id = ~p">>).
-define(SQL_WHOLE_AWARD_REPLACE, <<"replace into equip_whole_award_lv (`role_id`, `type`, `whole_lv`) values (~p, ~p, ~p)">>).