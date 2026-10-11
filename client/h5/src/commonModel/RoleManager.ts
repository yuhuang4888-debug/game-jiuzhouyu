// TypeScript file
import { EventDispatcher } from "../util/EventDispatcher";
import { MainRoleVo } from "../sharedata/MainRoleVo";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { Config } from "../common/Config";
import { TimeUtil } from "../util/TimeUtil";

export class RoleManager extends EventDispatcher {
    public static Instance: RoleManager;

    public static GetInstance() {
        if (!RoleManager.Instance) {
            RoleManager.Instance = new RoleManager();
        }
        return RoleManager.Instance;
    }
    

    mainRoleInfo: MainRoleVo;
    change_career_time = 0;
    role_platform_times_data = {};
    lifelong_counts_dic = {}
    head_img_list

    public constructor() {
        super();
        this.mainRoleInfo = new MainRoleVo();
    }

    GetMainRoleVo = (): MainRoleVo => {
        return this.mainRoleInfo;

    };

    GetMainRoleId = () => {
        return this.mainRoleInfo.role_id;
    };

    //主角头像列表
    SetHeadImgList = (list) => {
        this.head_img_list = list;
        GlobalEventSystem.Fire(EventName.UPDATE_ROLE_HEAD_ICON);
    };

    //主角头像列表
    UpdateHeadImgList = (img_id) => {
        if (!this.head_img_list) {
            this.head_img_list = [];
        }
        let find = false;
        for (let vo of this.head_img_list) {
            if (vo == img_id) {
                find = true;
                break;
            }
        }
        if (!find) {
            this.head_img_list.push(img_id);
        }
        GlobalEventSystem.Fire(EventName.UPDATE_ROLE_HEAD_ICON);
    };

    //该头像是否激活
    HaveActiviteThisHead = (id) => {
        let activite = 0;
        if (this.head_img_list) {
            for (let vo of this.head_img_list) {
                if (vo == id) {
                    activite = 1;
                    break;
                }
            }
        }
        if (id == 1 || id == 3) {
            activite = 1;
        }
        return activite;
    };

    IsActiviteByTypeId = (type_id) => {
        let is_active = false;
        // let config_picture = Config.PRELOAD_SERVER_CONFIG.config_picture;
        // if (config_picture) {
        //     let cfg;
        //     let list;
        //     let id;
        //     for (let key in config_picture) {
        //         cfg = config_picture[key];
        //         list = JSON.parse(cfg.cost);
        //         if (list && list.length > 0) {
        //             for (let vo of list) {
        //                 if (vo[0] == "goods" && vo[1] && vo[1][0]) {
        //                     if (vo[1][0][1] == type_id) {
        //                         id = key;
        //                         break;
        //                     }
        //                 }
        //             }
        //         }
        //     }
        //     if (id) {
        //         is_active = this.HaveActiviteThisHead(id) == 1 ? true : false;
        //     }
        // }
        return is_active;
    };

    GetMainRoleSex = () => {
        return this.mainRoleInfo.sex
    }

    GetMainRoleLevel = () => {
        return this.mainRoleInfo.level
    }

    GetMainRoleCareer = () => {
        return this.mainRoleInfo.career
    }

    GetMainRoleTurn = () => {
        return this.mainRoleInfo.turn
    }

    // 创角天数(自然日)
    GetRoleCreateDay = () => {
        return TimeUtil.naturalDaysBetween(this.mainRoleInfo.create_role_time * 1000, TimeUtil.getServerTime() * 1000)
        // let create_time: number = TimeUtil.getServerTime() - this.mainRoleInfo.create_role_time;
        // let day: number = create_time / (24 * 3600);
        // return Math.ceil(day);
    }

    GetMainRoleDepositState = () =>{
        return this.mainRoleInfo.deposit_state
    }   

    SetLivelongCount(module_id, sub_module, type, count){
        if(!this.lifelong_counts_dic){
            this.lifelong_counts_dic = {}
        }

        if(!this.lifelong_counts_dic[module_id]){
            this.lifelong_counts_dic[module_id] = {}
        }
        
        if(!this.lifelong_counts_dic[module_id][sub_module]){
            this.lifelong_counts_dic[module_id][sub_module] = {}
        }
        this.lifelong_counts_dic[module_id][sub_module][type] = count
    }

    GetLivelongCount(module_id, sub_module, type){
        if(!this.lifelong_counts_dic){
            return 
        }

        if(!this.lifelong_counts_dic[module_id]){
            return
        }

        if(!this.lifelong_counts_dic[module_id][sub_module]){
            return
        }

        return this.lifelong_counts_dic[module_id][sub_module][type]
    }
}
window["RoleManager"] = RoleManager