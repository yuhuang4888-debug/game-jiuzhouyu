import { Config } from "./Config";
import { ClientConfig } from "../util/DeclareGlobalVar";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { TimeUtil } from "../util/TimeUtil";
import { RoleManager } from "../commonModel/RoleManager";
//一些没有专门模块区分的操作，可以写上这个通用的manager里
export class CommonManager {
    static Instance: CommonManager;
    public player_menu_view;
    public static GetInstance() {
        if (!CommonManager.Instance) {
            CommonManager.Instance = new CommonManager();
        }
        return CommonManager.Instance;
    }
    CheckSpecialCondition;
    GetBoxIconCfg;
    GetValue;
    ShowPlayerMenu;
    GetInstructionState;
    GetWelfareWelcomeOpenState;
    PlayFightingVoice
    public constructor() {
        let local_Config = Config
        //特殊功能特殊条件
        this.CheckSpecialCondition = (_class) => {
            let open = false;
            // if (_class == "MountPetView" || _class == "MountPetIllusionView"
            //     || _class == "OutWardView" || _class == "OutWardIllusionView"
            //     || _class == "PartnerComponentView" || _class == "PartnerIllusionView"
            //     || _class == "HolyDeviceComponentView" || _class == "HolyDeviceIllusionView") {
            //     let illusion_data;
            //     let type_id;
            //     if (_class == "MountPetView" || _class == "MountPetIllusionView") { //坐骑
            //         type_id = 1;
            //     }
            //     else if (_class == "OutWardView" || _class == "OutWardIllusionView") { //翅膀
            //         type_id = 3;
            //     }
            //     else if (_class == "PartnerComponentView" || _class == "PartnerIllusionView") { //伙伴
            //         type_id = 2;
            //     }
            //     else if (_class == "HolyDeviceComponentView" || _class == "HolyDeviceIllusionView") { //武器 
            //         type_id = 5;
            //     }
            //     if (type_id) {
            //         open = true;
            //     }
            // }

            if (_class == "TopPkEnterView") {
                let RoleManager = window["RoleManager"]
                if (RoleManager) {
                    let roleVo = RoleManager.GetInstance().GetMainRoleVo()
                    // let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
                    // if (roleVo.level < 250 && openDay > 15 ) {
                    //     open = true
                    // }
                }
            }

            return open;
        };
        //获取配置
        this.GetBoxIconCfg = (icon_type) => {
            if (local_Config.PRELOAD_CLIENT_CONFIG.ConfigBoxIcon) {
                let cfg = local_Config.PRELOAD_CLIENT_CONFIG.ConfigBoxIcon;
                return cfg[icon_type];
            }
        };
        //获取全局配置value
        this.GetValue = (key) => {
            if (local_Config.PRELOAD_SERVER_CONFIG.config_key_value) {
                let vo = local_Config.PRELOAD_SERVER_CONFIG.config_key_value[key];
                if (vo) {
                    return vo.value;
                }
            }
        };
        this.ShowPlayerMenu = (...args) => {
        };
        /**规则显示是否受渠道影响 */
        this.GetInstructionState = (key) => {
            let Instruction_platform = ClientConfig.Instruction_platform;
            let open_state = 0;
            if (Instruction_platform) {
                if (Instruction_platform[key] != undefined) {
                    open_state = Instruction_platform[key];
                }
                else if (key) {
                    let keyList = key.split("@");
                    if (Instruction_platform[keyList[0]] != undefined) {
                        open_state = Instruction_platform[keyList[0]];
                    }
                }
            }
            return open_state;
        };

        //新手欢迎界面是否开启
        this.GetWelfareWelcomeOpenState = () => {
            let open_state = false
            // let welfare_cfg = Config.PRELOAD_SERVER_CONFIG.config_welfare_cfg
            // if (welfare_cfg) {
            //     let cfg = welfare_cfg[4]
            //     if (cfg) {
            //         let reward_list = JSON.parse(cfg.val)
            //         if (reward_list && reward_list.length > 0) {
            //             open_state = true
            //         }
            //     }
            // }
            return open_state
        }

        //战斗场景 进入场景、战斗结果音频播放
        this.PlayFightingVoice = (state) => {
            let RoleManager = window["RoleManager"]
            let SoundManager = window["SoundManager"]
            let vo = RoleManager.GetInstance().GetMainRoleVo()
            if(!vo)return null
            let sex = vo.sex
            let mp3_name=""
            let head_str=sex==1?"Boy_":"Girl_"
            mp3_name+=head_str
            switch(state){
                case 1://战斗失败、死亡
                    mp3_name+="Lose"
                    break;
                case 2://胜利、击杀boss 
                    mp3_name+="Win1"
                    break;
                case 3://pvp进入场景单次播放
                    mp3_name+="Win2"
                    break;
            }
            //console.warn("测试声音："+mp3_name)
            let voice = SoundManager.GetInstance().PlaySoundEffect(mp3_name, true, null, "role")
            return null//voice 屏蔽页面清理  自然播完
        }

    }
    public GetFunctionIconCfg(icon_type) {
        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFunctionIcon;
        for (const area in cfg) {
            let result = cfg[area][icon_type]
            if (!result) continue;
            return result;
        }
        return null
    }
    /**判断是否开启 */
    public CheckFunctionOpenStatus(icon_type) {
        let icon_cfg = CommonManager.GetInstance().GetFunctionIconCfg(icon_type);
        if(!icon_cfg)return true //没有配置，默认开启
        let day: number = ServerTimeModel.GetInstance().GetOpenServerDay();
        if (RoleManager.GetInstance().GetMainRoleVo().level >= icon_cfg.open_lv && day >= icon_cfg.open_day) {
            return true
        } else {
            return false
        }
    }
    //是否可跳转
    OpenFunCanJump(jump_id, not_alert?: boolean) {
        let open_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition;
        let view_class;
        let vo;
        let is_open = true;
        if (open_cfg) {
            for (let view in open_cfg) {
                vo = open_cfg[view];
                if (vo.open_fun_id != undefined && vo.open_fun_id == jump_id) {
                    view_class = view;
                    break;
                }
            }
        }
        if (view_class) {
            is_open = this.CheckFuncOpenState(view_class, not_alert);
        }
        return is_open;
    };
    //检查自己功能的开放状态
    CheckFuncOpenState(_class, not_alert?: boolean) {
        let open_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition;
        let open = true;
        if (open_cfg) {
            let condition = open_cfg[_class];
            if (condition) {
                if (this.CheckSpecialCondition(_class)) { //特殊功能的开放条件
                    return true;
                }
                //先判断开服天数
                if (condition.open_day > 0) {
                    if (window["ServerTimeModel"].GetInstance().GetOpenServerDay() < condition.open_day) {
                        open = false;
                    }
                }
                let tips_msg = condition.alert_day_str;
                if (open) {
                    //再判断等级
                    if (condition.open_lv > 0) {
                        let RoleManager = window["RoleManager"]
                        if (RoleManager) {
                            let role_mgr = RoleManager.GetInstance()
                            if (role_mgr.mainRoleInfo.level < condition.open_lv) {
                                open = false;
                            }
                        }
                    }
                    tips_msg = condition.alert_lv_str;
                    if (open) {
                        let task_model = window["TaskModel"].GetInstance()
                        //最后判断任务
                        if ("DungeonPartnerView" == _class && Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake) {
                            if (task_model.newest_finish_task_id < Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.ParnterTalkLastTaskId || task_model.HavePartnerAwakeTask()) {
                                open = false
                            }
                        }else if ("BackOrnamentComponentView" == _class || "BackOrnamentIllusionView" == _class){
                            //是否完成了背饰任务.可以获取得到任务数据就是未完成
                            if(task_model.GetAllTaskList(condition.open_task)){
                                open = false
                            }
                        }else if (condition.open_task > 0) {
                            if (task_model.newest_finish_task_id == 0 || task_model.newest_finish_task_id < condition.open_task) {
                                open = false;
                            }
                        }
                        tips_msg = condition.alert_task_str;
                    }
                }
                //弹未开放提示
                if (open == false && !not_alert) {
                    if (tips_msg) {
                        let Message = window["Message"]
                        Message.show(tips_msg)
                    }
                }
            }
        }
        return open;
    };

    CheckOtherPlayerFuncOpenState(_class, data?) {
        let open_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition;
        let open = true;
        if (open_cfg) {
            let condition = open_cfg[_class];
            if (condition) {
                //先判断开服天数
                if (condition.open_day > 0) {
                    if (window["ServerTimeModel"].GetInstance().GetOpenServerDay() < condition.open_day) {
                        open = false;
                    }
                }
                if (open) {
                    //再判断等级
                    if (condition.open_lv > 0) {
                        let role_data = data
                        if (role_data.level < condition.open_lv) {
                            open = false;
                        }
                    }
                }
            }
        }
        return open;
    };
}

window["CommonManager"] = CommonManager