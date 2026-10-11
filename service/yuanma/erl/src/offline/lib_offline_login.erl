%% ---------------------------------------------------------------------------
%% @doc 模拟登陆数据加载-获取离线玩家数据
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_offline_login).
-include("server.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("rec_offline.hrl").
-include("title.hrl").
-include("guild.hrl").
-include("partner.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("vip.hrl").
-include("team.hrl").
-include("common.hrl").
-include("activitycalen.hrl").
-include("reincarnation.hrl").
-include("eudemons.hrl").
-include("marriage.hrl").

-export ([load_player_info/1]).

%% 加载离线玩家数据
%% 注:主要加载以下数据，除此之外的数据一般不需要加载
%% 1.玩家形象、玩家属性战力相关的数据
%% 2.查看离线玩家信息需要用到的数据（如装备信息、伙伴信息）
load_player_info(Id) ->
    %% 玩家玩家数据
    [_GM, _TalkLim, _TalkLimTime, _LastLogoutTime, _TalkLimRight, _RegTime, Source|_]
        = lib_player:get_player_login_data(Id),
    [NickName, Sex, Lv, Career, Realm, Picture, _PictureLim, PictureVer, _CReName,
     _CReNameTime, _CReCareerTime|_] = lib_player:get_player_low_data(Id),
    [_Gold, _BGold, _Coin, _GCoin, _Exp, HightestCombatPower|_] = lib_player:get_player_high_data(Id),
    [_DbScene, _DbX, _DbY, Hp, Quickbar, _, _, _, SkillPoint|_] = lib_player:get_player_state_data(Id),
    [CellNum, StorageNum, _GodBagNum|_] = lib_player:get_player_attr_data(Id),
    ReincarnationStatus = lib_reincarnation:login(Id, Career, Sex),
    LvModel = lib_goods_util:get_lv_model(Id, Career, Sex, ReincarnationStatus#reincarnation.turn, Lv),
    NewFashionModel = lib_fashion:get_equip_fashion_list(Id, Career, Sex),
    StatusGuild = lib_guild:load_status_guild(Id),
    StLiveness = lib_liveness:login(Id),
    JueWeiLv = lib_juewei:get_juewei_id_db(Id),
    VipStatus = lib_vip:login(Id),
    #role_vip{vip_type = VipType,vip_lv = VipLv, vip_hide = VipHide} = VipStatus,
    %MarriageStatus = lib_marriage:marriage_status_login(Id),
    MonPic = lib_mon_pic:login(Id),
    StatusSupVip = lib_supreme_vip:offine_load_status_supvip(Id),
    Figure = #figure{
                name=NickName, sex=Sex, lv=Lv, career=Career, realm=Realm, vip=VipLv,vip_type = VipType,vip_hide = VipHide,
                lv_model = LvModel, fashion_model = NewFashionModel, juewei_lv = JueWeiLv,
                picture = Picture, picture_ver = PictureVer,
                guild_id = StatusGuild#status_guild.id,
                guild_name = StatusGuild#status_guild.name,
                position = StatusGuild#status_guild.position,
                position_name = StatusGuild#status_guild.position_name,
                % liveness = StLiveness#st_liveness.figure_id * StLiveness#st_liveness.display_status,
                turn = ReincarnationStatus#reincarnation.turn,
                turn_stage = ReincarnationStatus#reincarnation.turn_stage,
                is_supvip = lib_supreme_vip:is_supvip(StatusSupVip)
               },
    BA = #battle_attr{hp=max(Hp,1)},
    Skill = lib_skill:skill_online(Id, Career, Lv, SkillPoint),
    %% 物品初始化
    {GoodsStatus, StatusGoods} = login_goods(Id, Lv, VipType, VipLv, CellNum, StorageNum),
    %% 幻兽信息
    Eudemons = lib_eudemons:init_data(Id, GoodsStatus),
    Off = #status_off{goods_status = GoodsStatus},

    PlayerStatus = #player_status{
        id              = Id,
        server_num      = config:get_server_num(),
        server_id       = config:get_server_id(),
        source          = Source,
        c_source        = Source,
        figure          = Figure,
        hightest_combat_power = HightestCombatPower,
        battle_attr     = BA,
        skill           = Skill,
        guild           = StatusGuild,
        goods           = StatusGoods,
        off             = Off,
        st_liveness     = StLiveness,
        flower          = lib_flower:login(Id),
        awakening       = lib_awakening:login(Id),
        guild_skill     = lib_guild_skill:login(Id),
        reincarnation   = ReincarnationStatus,
        vip             = VipStatus,
        eudemons        = Eudemons,
        quickbar        = util:bitstring_to_term(Quickbar),
        mon_pic         = MonPic,
        fairy           = lib_fairy:offlogin(Id),        %%  精灵
        seal_status     = lib_seal:login(Id, Lv, GoodsStatus),
        draconic_status = lib_draconic:login(Id, Lv, GoodsStatus),
        supvip          = StatusSupVip,
        constellation   = lib_constellation_equip:login(Id, Lv, GoodsStatus),
        task_attr       = lib_task:load_attr(Id),
        contract_buff   = lib_contract_challenge:login(Id),
        enchantment_guard = lib_enchantment_guard:offline_login(Id),
        weekly_card_status = lib_weekly_card:offline_login(Id)
        % god             = lib_god:login(Id)
        },
    %% 称号列表初始化
    DsgtPS = lib_designation_util:login(PlayerStatus),
    %% 翅膀初始化
    WingPS = lib_wing:login(DsgtPS),
    %% 法宝初始化
    TalismanPS = lib_talisman:login(WingPS),
    %% 仙灵直购
    FairyBuy = lib_fairy_buy:login(TalismanPS),
    %% 神兵初始化
    GodWeaponPS = lib_godweapon:login(FairyBuy),
    %% 神器初始化
    ArtifactPS = lib_artifact:login(GodWeaponPS),
    %% 个性装扮初始化
    DressUpPS = lib_dress_up:login(ArtifactPS),
    %% 星图初始化
    StarMapPS = lib_star_map:login(DressUpPS),
    %% 坐骑
    MountPS = lib_mount:offline_login(StarMapPS, GoodsStatus),
    CompanionPs = lib_companion:login(MountPS),
    %% 坐骑装备
    MountEquipPS = lib_mount_equip:off_login_init(CompanionPs),
    %% 背饰
    BackDecorPS = lib_back_decoration:off_login(MountEquipPS),
    %% 宠物
    PetPS = lib_pet:login(BackDecorPS, GoodsStatus),
    %% 圣灵
    HolyGhostPs = lib_holy_ghost:login(PetPS),
    %% 宝宝
    BabyPs = lib_marriage:baby_login(HolyGhostPs),
    %% 房子
    HousePs = lib_house:house_login(BabyPs),
    %% 龙珠
    DragonBallPs = lib_dragon_ball:login(HousePs),
    %% 成就
    AchievePs = lib_achievement:login_offline(DragonBallPs),
    %% 灵器
    AnimaEquipPs = lib_anima_equip:login(AchievePs, GoodsStatus),
    %% 头衔
    TitlePS = lib_title:login(AnimaEquipPs),
    %% 勋章
    MedalPs = lib_medal:login(TitlePS),
    %% 魔法阵
    MagicCircle = lib_magic_circle:login(MedalPs),
    %% 属性药剂
    AttrMedicamentPs = lib_attr_medicament:login(MagicCircle),
    %% 幻饰
    DecPs = lib_decoration:login(AttrMedicamentPs, GoodsStatus),
    %% 圣裁
    ArbitramentPs = lib_arbitrament:login(DecPs),
    %% 龙纹
    DragonPs = lib_dragon:login(ArbitramentPs, GoodsStatus),
    %% 结婚
    MarriagePs = lib_marriage:marriage_login_offline(DragonPs, GoodsStatus),
    %% 副本学习技能
    DunLearnSkillPs = lib_dungeon_learn_skill:login(MarriagePs),
    %% 宝宝
    NewBabyPs = lib_baby:login(DunLearnSkillPs),
    GodPS = lib_god:off_login(NewBabyPs),
    RevelationPS = lib_revelation_equip:off_login(GodPS),
    %% 使魔
    DemonsPS = lib_demons:login(RevelationPS),
    %% 3v3
    Role3v3 = lib_3v3_local:login2(DemonsPS),
    %% 时空裂缝
    ChronoRiftPS = lib_local_chrono_rift_act:login(Role3v3),
    %% 日常预约
    ActSignUpPS = lib_act_sign_up:login(ChronoRiftPS),
    %% 公会神像
    GuildGodPS = lib_guild_god:login(ActSignUpPS),
    %% 至尊vip
    SupvipPS = lib_supreme_vip:after_offine_login(GuildGodPS),
    %% 远古奥术
    ArcanaPS = lib_arcana:login(SupvipPS),
    %% 神庭
    GodCourtPs = lib_god_court:login(ArcanaPS),
    %% 资源找回
    ResourceBackPS = lib_resource_back:login(GodCourtPs),
    %% 海域功勋
    SeaExploitPs = lib_seacraft_extra:login_exploit(ResourceBackPS),
    %% 套装收集
    SuitCollectPS = lib_suit_collect:login(SeaExploitPs),
    %% 神殿觉醒
    TemplePs = lib_temple_awaken:offline_login(SuitCollectPS),
    %% 战甲
    AmourPS = lib_armour:login(TemplePs),
    RechargePS = lib_recharge:login(AmourPS),
    %% 属性计算
    CountAttrPS = lib_player:count_player_attribute(RechargePS),
    MountAfterLogin = lib_mount:after_login(CountAttrPS),
    %% 初始化时装套装属性
    FashionSuitPs = lib_fashion_suit:init_conform_num_and_attr(MountAfterLogin),
%%    ?MYLOG("cym", "MountAfterLogin ~p~n", [MountAfterLogin]),
    FashionSuitPs.

%% 物品加载
login_goods(Id, Lv, VipType, VipLv, CellNum, StorageNum) ->
    {GoodsStatus, StatusGoods} = lib_goods:login(Id, [Lv, VipType, VipLv, CellNum, StorageNum]),
    #goods_status{dict = Dict} = GoodsStatus,
    F = fun(_Key, [Value]) -> (Value#goods.type=:=?GOODS_TYPE_EQUIP andalso Value#goods.location=:=?GOODS_LOC_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_PET_EQUIP andalso Value#goods.location=:=?GOODS_LOC_PET_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_MOUNT_EQUIP andalso Value#goods.location=:=?GOODS_LOC_MOUNT_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_MATE_EQUIP andalso Value#goods.location=:=?GOODS_LOC_MATE_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_EQUIP andalso Value#goods.location=:=?GOODS_LOC_ANIMA_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_EUDEMONS andalso Value#goods.location =:= ?GOODS_LOC_EUDEMONS)
                              orelse (Value#goods.type=:=?GOODS_TYPE_GOD_EQUIP andalso Value#goods.location=:=?GOODS_LOC_GOD2_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_GUILD_GOD andalso Value#goods.location=:=?GOODS_LOC_GOD_GUILD_GOD_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_DECORATION andalso Value#goods.location=:=?GOODS_LOC_DECORATION)
                              orelse (Value#goods.type=:=?GOODS_TYPE_REVELATION andalso Value#goods.location=:=?GOODS_LOC_REVELATION)
                              orelse Value#goods.location=:=?GOODS_LOC_SEAL_EQUIP
                              orelse (Value#goods.type =:= ?GOODS_TYPE_DRAGON_EQUIP andalso Value#goods.location =:= ?GOODS_LOC_DRAGON_EQUIP)
                              orelse (Value#goods.type =:= ?GOODS_TYPE_DRACONIC andalso Value#goods.location =:= ?GOODS_LOC_DRACONIC_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_CONSTELLATION andalso Value#goods.location=:=?GOODS_LOC_CONSTELLATION_EQUIP)
                              orelse (Value#goods.type=:=?GOODS_TYPE_RUNE andalso Value#goods.location=:=?GOODS_LOC_RUNE)
        end,
    NewDict = dict:filter(F, Dict),
    RevelationEquipList   = lib_goods_util:get_revelation_equip_list(Id, NewDict),
    RevelationEquipLocation = lib_goods_util:get_equip_location(RevelationEquipList),
    NewGoodsStatus = #goods_status{
                        player_id = Id,
                        dict = NewDict,
                        equip_location = GoodsStatus#goods_status.equip_location,
                        equip_stone_list = GoodsStatus#goods_status.equip_stone_list,
                        equip_stren_list = GoodsStatus#goods_status.equip_stren_list,
                        equip_refine_list = GoodsStatus#goods_status.equip_refine_list,
                        equip_wash_map = GoodsStatus#goods_status.equip_wash_map,
                        equip_casting_spirit = GoodsStatus#goods_status.equip_casting_spirit,
                        equip_awakening_list = GoodsStatus#goods_status.equip_awakening_list,
                        % equip_magic_list = GoodsStatus#goods_status.equip_magic_list,
                        equip_suit_list         = GoodsStatus#goods_status.equip_suit_list,
                        equip_suit_state        = GoodsStatus#goods_status.equip_suit_state,
                        rune = GoodsStatus#goods_status.rune,
                        soul = GoodsStatus#goods_status.soul,
                        ring = GoodsStatus#goods_status.ring,
                        fashion = GoodsStatus#goods_status.fashion,
                        god_equip_list = GoodsStatus#goods_status.god_equip_list,
                        revelation_equip_location = RevelationEquipLocation
                       },
    RevelationEquipAttr = lib_revelation_equip:count_attribute(RevelationEquipList),
    {RevelationEquipSuitAttr, _} = lib_revelation_equip:count_suit_attribute(RevelationEquipList),
    NewStatusGoods = #status_goods{
                        equip_attribute = StatusGoods#status_goods.equip_attribute,
                        fashion_attr = StatusGoods#status_goods.fashion_attr,
                        rune_attr = StatusGoods#status_goods.rune_attr,
                        soul_attr = StatusGoods#status_goods.soul_attr,
                        ring_attr = StatusGoods#status_goods.ring_attr,
                        equip_suit_attr = StatusGoods#status_goods.equip_suit_attr,
                        bag_fusion_attr = StatusGoods#status_goods.bag_fusion_attr,
                        revelation_equip_attr = RevelationEquipAttr,
                        revelation_equip_suit_attr = RevelationEquipSuitAttr
                       },
    {NewGoodsStatus, NewStatusGoods}.
