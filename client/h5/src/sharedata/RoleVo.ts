
import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType, FashionPartPos } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { SceneManager } from "../scene/SceneManager";
import { ResManager } from "../common/ResManager";
import { Config } from "../common/Config";
import { BanquetAniManager } from "../marriage2/BanquetAniManager";
import { ErlangParser } from "../util/ErlangParser";

// console.warn("RoleVo")
// TypeScript file
export enum ModelPartPos {
    Clothe = 1,
    Weapon = 2,
    HeadWear = 3
}
window["ModelPartPos"] = ModelPartPos;
export class RoleVo extends EventDispatcher {
    static FIGURE_CHANGE = "FIGURE_CHANGE";
    static PK_STATUS = {
        Peace: 0,
        Free: 1,
        Guild_Team: 2,
        Local: 3,
        Guild: 4,
        CAMP: 5 //阵营 只能攻击不通阵营的人
    };
    static SHEN_CHUANG_LV = 370
    vo_type = SceneBaseType.Role;
    role_id = 0; //用户ID(int32)
    plat_name = ""; //平台名(string)
    server_unique_id = 0; //int:16 服务器唯一id
    server_id = 0; //服ID(int16)
    server_name = ""; //服务器名字
    name = ""; //玩家名(string)
    sex = 0; //性别(int8)   男1女2
    level = 100; //等级(int16)
    pos_x = 0; //X像素坐标(int16)
    pos_y = 0; //Y像素坐标(int16)
    dsgt_id = 0; //用户称号ID(int32)
    hp = 100; //当前hp(int32)
    maxHp = 100; //最大hp(int32)
    move_speed = 250; //玩家速度(int16)
    weapon = 0; // int:32	武器
    cloth = 0; // int:32	装备
    career = 0; //角色(int8)     //神将=1 、天君=2、罗刹=3
    realm = 0; //国家(int8)
    warGroup = 0; //战斗分组(int8)
    total_title = 0; //称号总数
    title_list = {}; //称号列表
    is_ride = 0; // 是否骑乘状态，0非，1是
    pk_status = 0; //PK状态(int8)
    imageId = 0; //玩家形象(变身形象)(int32)
    vip_flag = 0; //Vip标识(int8)
    is_hide_vip = 0; //是否隐藏vip等级(int8)
    guild_id = 0; //帮派ID(int32)
    guild_name = ""; //帮派名称(string)
    position_name = "";
    position = 0; //帮派职位(int8)
    hide_flag = 0; //是否不可见(int8)
    ghost_mode = 0; //幽灵状态(int8)
    fighting = 0; //战斗力(int32)
    sit_state = 0; //打坐状态(int8) 0未打坐 1打坐
    boss_flag = 0; //是否boss归属 0否 1是
    team_id = 0; //队伍id 32
    team_job = 0; //队伍职位（0 无   1队长   2队员）
    prePoseState = PoseState.STAND;
    poseState = PoseState.STAND;
    sky_flags = {}; //天空战场旗子
    weapon_effect = 0; //装备附魔
    birth_angle = 90; //出生角度  水平向右为0 顺时针一圈为360度
    show_base_info_only = false; //nameBoard只显示名字和血条
    safe_area_state = 0; //1角色处于安全区域状态  2角色处于非安全区域状态  3角色切场景进入安全区域状态
    hatred = 0; //罪恶值
    is_marriage = 0; //婚姻状态(0单身 1恋爱 2已婚)
    marriage_id = 0; //伴侣id
    marriage_name = ""; //伴侣名字
    escort_state = 0; //护送id
    protect_time = 0; //保护时间
    date_role_id = 0;
    ship_model_id = 0; //跨服结社战变形模型ID
    turn = 0; //转生级数
    turn_stage = 0; //转生阶数
    att_speed;
    is_fake_role; //服务端假人
    revelation_suit;
    fashion_model_list;
    level_model_list;
    god_id = 0;
    brick_id = 0;
    figure_list;
    figure_ride_list;
    is_virtual_role = false; //客户端假人
    fazhen_id = 0; //法阵id
    dress_list;
    picture = "";
    demon_id = 0; //使魔id
    supreme_vip = 0;
    invincible_end_time = 0; //免战时间戳
    title_id; //头衔
    camp; //阵营
    mask_id = 0; //面具id
    seaCamp = 0;
    suit_fashion_id = 0						//套装收集时装id
    collect_state = 0
    grade_id = 0
    public constructor() {
        super();
    }
    public ReadFromProtocal() {
        let self = this, _user_msg_adapter = UserMsgAdapter.GetInstance(), team_id, len;
        [
            self.role_id,
            self.plat_name,
            self.server_unique_id,
            self.server_id,
            self.server_name
        ] = _user_msg_adapter.ReadFmt("lshhs");
        let god_id = self.god_id;
        let brick_id = self.brick_id;
        new FigureProtoVo().ReadFmt(self);
        [
            self.pos_x,
            self.pos_y,
            self.hp,
            self.maxHp,
            self.move_speed,
            self.hide_flag,
            self.ghost_mode,
            self.warGroup,
            self.boss_flag,
            team_id,
            self.team_job,
            self.pk_status,
            self.fighting,
            self.hatred,
            self.protect_time,
            self.date_role_id,
            self.ship_model_id,
            self.invincible_end_time,
            self.camp
        ] = _user_msg_adapter.ReadFmt("hhllhcclclcclhiliih");
        self.ChangeVar("team_id", team_id);
        if (god_id != self.god_id) {
            self.ChangeVar("god_id", self.god_id, false, true);
        }
        if (brick_id != self.brick_id) {
            self.ChangeVar("brick_id", self.brick_id);
        }
        // if(self.horse_id == 0)
        // {
        //     self.horse_id = 703001
        // }








        // if(self.wing_id == 0)
        // {
        //     self.wing_id = 104009
        // }
        // self.dsgt_id = 100002
        // console.log("rolevo", self.hp, self.maxHp, self.name)
    }
    public ReadFakeProtacal() {
        let self = this, _user_msg_adapter = UserMsgAdapter.GetInstance();
        [self.role_id,
        self.plat_name,
        self.server_unique_id,
        self.server_id] = _user_msg_adapter.ReadFmt("ishh");
        new FigureProtoVo().ReadFmt(self);
        [self.pos_x,
        self.pos_y,
        self.hp,
        self.maxHp,
        self.move_speed,
        self.hide_flag,
        self.ghost_mode,
        self.warGroup] = _user_msg_adapter.ReadFmt("hhllhccl"); //战斗分组
        console.log("假人数据------------=", self.name, self.warGroup, self.pos_x, self.pos_y, self.hp, self.maxHp, self.ghost_mode);
        self.is_fake_role = true; //是否假人  纯服务端控制的假人
        let vo;
        for (let i = 0, len = this.figure_list.length; i < len; i++) {
            vo = this.figure_list[i];
            if (vo && vo.figure_type == FigureProtoVo.FigureType.Horse) {
                this.figure_list.splice(i, 1);
                break;
            }
        }
        //随机名字
        // if(self.name == "")
        // self.name = LoginModel.GetInstance().GetRandomRoleName(self.sex, true)
    }
    public ResetData() {
        let self = this;
        self.prePoseState = PoseState.STAND;
        self.poseState = PoseState.STAND;
        self.is_fake_role = false;
        self.is_virtual_role = false;

        self.fashion_model_list.length = 0;
        self.level_model_list.length = 0
        self.figure_list.length = 0;
        self.figure_ride_list.length = 0;
        self.dress_list.length = 0

        self.safe_area_state = 0;
    }
    public CheckIsGod() {
        return this.god_id > 0;
    }
    public CheckIsWorker() {
        return this.brick_id > 0;
    }
    //取等级模型id列表的衣服id
    //scene_obj_type 是否是场景对象 还是ui对象
    public GetRoleClotheId(show_mask?) {
        if (show_mask && this.CheckIsGod()) {
            let cfg_god = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god", false)
            let cfg = cfg_god[this.god_id]
            if (cfg) {
                return cfg.model
            }
        }


        // if (!check_mask || this.mask_id == 0 || !mask_scene) {
        //     let res_id = this.GetRoleClotheTextureId()
        //     if (res_id)
        //         return res_id
        // }
        // if (mask_scene && this.mask_id > 0) {
        let model_fun = () => {
            let model_res_list = this.level_model_list;
            if (model_res_list)
                for (let v of model_res_list)
                    if (v.part_pos == ModelPartPos.Clothe)
                        return v.level_model_id;
        };
        if (show_mask) {
            return model_fun();
        }
        else {
            let res_id = this.GetRoleClotheTextureId()[0];
            if (res_id)
                return res_id;
            else
                return model_fun();
            ;
        }
    }
    //取时装衣服贴图id revelation_res 天启套装时装效果
    public GetRoleClotheTextureId() {

        if (!(SceneManager.GetInstance().IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing)) {
            if (this.vo_type && this.CheckIsGod())
                return [0, 0]

            if (this.revelation_suit != 0 && window["Util"]) {
                return window["Util"].GetRevelationClothesRes(this.revelation_suit, this.sex)
            }

            if (this.suit_fashion_id != 0) {
                return window["Util"].GetSuitActivityClothesRes(this.suit_fashion_id, this.career)
            }

            if (this.CheckIsTempleAwaken()) {
                let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_suit
                if (cfg) {
                    return [Number(cfg["1001@" + this.career].figure_id), 0]
                }
            }
        }


        let model_res_list = this.fashion_model_list;
        if (model_res_list)
            for (let v of model_res_list)
                if (v.part_pos == ModelPartPos.Clothe){
                    var fashion_chartlet_id = v.fashion_chartlet_id
                    if(fashion_chartlet_id == null){
                        fashion_chartlet_id = 0
                    }
                    return [v.fashion_model_id, fashion_chartlet_id]
                }

        return [0, 0]
    }

    //--block: 1屏蔽时装 2 屏蔽神兵
    //先去时装模型列表的 再取等级模型id列表的武器id
    public GetWeaponClotheId(scene_obj_type?, block?) {
        // if (!check_mask || this.mask_id == 0 || !mask_scene) {
        //     let model_res_list = this.fashion_model_list;
        //     if (model_res_list)
        //         for (let v of model_res_list)
        //             if (v.part_pos == ModelPartPos.Weapon)
        //                 return v.fashion_model_id;
        //     let weapon_id = this.GetFigureId(FigureProtoVo.FigureType.Weapon);
        //     if (weapon_id)
        //         return weapon_id;
        // }


        if (scene_obj_type && this.CheckIsGod()) {
            let god_id = this.GetAlphaModelGodID()
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_god[god_id]
            if (cfg) {
                return cfg.model
            }
        }

        let weapon_id = (!block || (block != 2)) && this.GetFigureId(FigureProtoVo.FigureType.Weapon)
        if (weapon_id && weapon_id != 0) {
            return weapon_id
        }

        let model_res_list = (!block || block != 1) && this.fashion_model_list
        if (model_res_list) {
            let v
            for (let k in model_res_list) {
                v = model_res_list[k]
                if (v.part_pos == FashionPartPos.Weapon) {
                    return v.fashion_model_id
                }
            }
        }


        model_res_list = this.level_model_list;
        if (model_res_list)
            for (let v of model_res_list)
                if (v.part_pos == ModelPartPos.Weapon)
                    return v.level_model_id;
    }

    //通过figure_type来获取对应的值
    public GetFigureId(figure_type) {
        if (this.figure_list)
            for (let v of this.figure_list)
                if (v.figure_type == figure_type)
                    return v.figure_id;
        return 0
    }
    public SetFigureId(figure_type, figure_id, not_fire?) {
        if (this.figure_list) {
            for (let v of this.figure_list) {
                if (v.figure_type == figure_type) {
                    v.figure_id = figure_id;
                    if (!not_fire) {
                        this.Fire(RoleVo.FIGURE_CHANGE, figure_type, figure_id);
                    }
                    return;
                }
            }
            this.figure_list.push({ figure_type: figure_type, figure_id: figure_id });
            if (!not_fire) {
                this.Fire(RoleVo.FIGURE_CHANGE, figure_type, figure_id);
            }
        }
    }
    public SetFigureRideState(figure_type, is_ride) {
        if (this.figure_ride_list) {
            let figure_id = this.GetFigureId(figure_type);
            for (let v of this.figure_ride_list) {
                if (v.figure_type == figure_type) {
                    v.is_ride = is_ride;
                    if (figure_id != undefined) {
                        this.Fire(RoleVo.FIGURE_CHANGE, figure_type, figure_id);
                    }
                    return;
                }
            }
            this.figure_ride_list.push({ figure_type: figure_type, is_ride: is_ride });
            if (figure_id != undefined) {
                this.Fire(RoleVo.FIGURE_CHANGE, figure_type, figure_id);
            }
        }
    }
    public GetFigureRideState(figure_type) {
        let is_ride = 1
        if (this.figure_ride_list) {
            for (let v of this.figure_ride_list) {
                if (v.figure_type == figure_type) {
                    is_ride = v.is_ride;
                    break;
                }
            }
        }
        return is_ride;
    }
    public SetFaZhenId(fazhen_id) {
        this.fazhen_id = fazhen_id;
        this.Fire("fazhen_id", fazhen_id);
    }
    //装扮列表
    public SetDressList(dress_list) {
        this.ChangeVar("dress_list", dress_list);
    }
    public GetDressByType(dress_type) {
        let dress_id;
        if (this.dress_list) {
            for (let dress of this.dress_list) {
                if (dress.dress_type == dress_type) {
                    dress_id = dress.dress_id;
                    break;
                }
            }
        }
        return dress_id;
    }
    public GetRoleHeadId(block?) {
        let model_res_list = !block && this.fashion_model_list || null
        if (!SceneManager.GetInstance().IsWeddingScene()) {
            if (this.revelation_suit != 0 && window["Util"]) {
                return window["Util"].GetRevelationHairRes(this.revelation_suit, this.sex)
            }
            if (this.suit_fashion_id != 0 && window["Util"]) {
                return window["Util"].GetSuitActivityHairRes(this.suit_fashion_id, this.career)
            }
            if (this.CheckIsTempleAwaken()) {
                let cfg_kv = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv
                if (cfg_kv) {
                    let head_model_id = Number(ErlangParser.GetInstance().Parse(cfg_kv[7].value)[this.sex - 1][1])
                    return [head_model_id, 0]
                }
            }
        }

        if (model_res_list) {
            for (let k = 0; k < model_res_list.length; k++) {
                var v = model_res_list[k]
                if (v.part_pos == FashionPartPos.Head) {
                    return [v.fashion_model_id, v.fashion_chartlet_id]
                }
            }
        }

        // //审核模式下 取指定非正式资源 没有数据的话 就拿服务器下发的数据
        // if (ClientConfig.alpha_mode &&  IOSShiledConfig.OpenNotFormalAsset  ) {
        //     let res_id = this.GetAlphaModelHeadId()
        //     if (res_id ) {
        //         return res_id
        //     }
        // }

        model_res_list = this.level_model_list
        if (model_res_list) {
            for (let k = 0; k < model_res_list.length; k++) {
                var v = model_res_list[k]
                if (v.part_pos == FashionPartPos.Head) {
                    return [v.level_model_id, 0]
                }
            }
        }

        return [0, 0]
    }


    public GetGodModelScale() {
        let god_id = this.GetAlphaModelGodID()
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_god[god_id]
        if (cfg) {
            return cfg.model_ratio2 || 1
        }
        return 1
    }

    public GetAlphaModelGodID() {
        let god_id = this.god_id
        return god_id
    }

    public CheckIsTempleAwaken() {
        let is_wear = false
        if (this.figure_list) {
            let v
            for (let _tmpi in this.figure_list) {
                v = this.figure_list[_tmpi]
                if (v.figure_type == 11 && v.figure_id && v.figure_id != 0) {
                    is_wear = true
                    return is_wear
                }
            }
        }
        return is_wear
    }

    public CheckIsMoveBrick() {
        return this.brick_id > 0
    }
}

window["RoleVo"] = RoleVo