import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PlayBigEffect, Util } from "../util/Util"


import "../baby/BabyMainView";
import "../baby/GestateBabyView";
import "../baby/BabyCultivateView";
import "../baby/BabyFamilyView";
import "../baby/BabyIllusionView";
import "../baby/BabyReNameView";
import "../baby/BabyChangedView";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"




export class BabyController extends BaseController {
    public view_dic = {}
    InitInfo
    public constructor() {
        super()
        this.InitInfo = () => {
            let babyModel = BabyModel.GetInstance()
            let user_msg_adapter = UserMsgAdapter.GetInstance()
            let local_Util = Util
            let local_BabyEvent = BabyEvent
            let local_GlobalEventSystem = GlobalEventSystem
            let local_EventName = EventName
            let red_dot_mgr = RedDotManager.GetInstance()
            let local_ModuleType = ModuleType
            let goods_model = GoodsModel.GetInstance()
            let local_GoodsModel = GoodsModel
            let role_mgr = RoleManager.GetInstance()
            let res_mgr = ResManager.GetInstance()
            let On18200 = () => {
                let scmd = user_msg_adapter.GetSCMD(18200)
                local_Util.ErrorCodeShow(scmd.error_code, scmd.args)
            }

            let On18201 = () => {
                let scmd = user_msg_adapter.GetSCMD(18201)
                babyModel.babyUseId = scmd.baby_id
                babyModel.babyName = scmd.baby_name == `` ? `宝宝` : scmd.baby_name
                babyModel.activeTime = scmd.active_time
                babyModel.changedName = scmd.is_change_name
                if (babyModel.activeTime > 0) {
                    babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18203)
                    babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18204)
                    babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18205)
                    babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18206)
                    babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18207)
                }
                babyModel.Fire(local_BabyEvent.UPDATE_BABY_BASIC)
            }

            let On18202 = () => {
                let scmd = user_msg_adapter.GetSCMD(18202)
                if (scmd.info_list.length > 0) {
                    babyModel.babyDataList[scmd.info_list[0].role_id] = scmd.info_list[0]
                    babyModel.Fire(local_BabyEvent.BABY_DATA_LIST, scmd.info_list)
                }
            }

            let On18203 = () => {
                let scmd = user_msg_adapter.GetSCMD(18203)


                let baby_stage_cfgs, baby_value_cfgs

                let call_func = () => {
                    if (baby_stage_cfgs && baby_value_cfgs) {
                        babyModel.babyCultivateData = scmd
                        babyModel.CheckUpStage(baby_stage_cfgs, baby_value_cfgs)
                        babyModel.CheckUpLvRed()
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                        babyModel.Fire(local_BabyEvent.BABY_CULTIVATE)
                        res_mgr.DestoryGameConfig(this, "config_baby_stage", false)
                        res_mgr.DestoryGameConfig(this, "config_baby_value", false)
                    }

                }

                res_mgr.LoadGameConfig(this, "config_baby_stage", false, undefined, (cfgs) => {
                    baby_stage_cfgs = cfgs
                    call_func()
                })


                res_mgr.LoadGameConfig(this, "config_baby_value", false, undefined, (cfgs) => {
                    baby_value_cfgs = cfgs
                    call_func()
                })
            }

            let On18204 = () => {
                let scmd = user_msg_adapter.GetSCMD(18204)


                let baby_stage_cfgs, baby_value_cfgs

                let call_func = () => {
                    if (baby_stage_cfgs && baby_value_cfgs) {
                        babyModel.babyCulStageData = scmd
                        babyModel.CheckUpStage(baby_stage_cfgs, baby_value_cfgs)
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                        babyModel.Fire(local_BabyEvent.BABY_CULSTAGE)
                        res_mgr.DestoryGameConfig(this, "config_baby_stage", false)
                        res_mgr.DestoryGameConfig(this, "config_baby_value", false)
                    }

                }

                res_mgr.LoadGameConfig(this, "config_baby_stage", false, undefined, (cfgs) => {
                    baby_stage_cfgs = cfgs
                    call_func()
                })


                res_mgr.LoadGameConfig(this, "config_baby_value", false, undefined, (cfgs) => {
                    baby_value_cfgs = cfgs
                    call_func()
                })

            }

            let On18205 = () => {
                // let scmd = new SCMD18205(true)
                let baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg
                let adapter = user_msg_adapter
                let len2 = adapter.ReadFmt("h")
                babyModel.babyEquipData.equip_list = {}
                let vo2
                for (let i: number = 1; i <= len2; i++) {
                    vo2 = {}
                    vo2.pos_id = adapter.ReadFmt("c")
                    vo2.id = adapter.ReadFmt("l")
                    vo2.goods_type_id = adapter.ReadFmt("i")
                    vo2.estage = adapter.ReadFmt("h")
                    vo2.estage_lv = adapter.ReadFmt("h")
                    vo2.estage_exp = adapter.ReadFmt("i")
                    vo2.skill_id = adapter.ReadFmt("i")
                    babyModel.babyEquipData.equip_list[vo2.pos_id] = vo2
                }
                babyModel.babyEquipData.power = adapter.ReadFmt("i")
                let call_func = () => {
                    if (baby_value_cfg && baby_equip_stage_cfg && baby_equip_stren_cfg) {
                        for (let key in babyModel.babyEquipData.equip_list) {
                            let vo2 = babyModel.babyEquipData.equip_list[key];
                            red_dot_mgr.SetRedStatus(local_ModuleType.BABY_EQUIP_FOR, vo2.pos_id, babyModel.CanForgeEquip(vo2.pos_id, baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg))
                            RedDotController.ins.add(RedKey.BABY_EQUIP_FOR + vo2.pos_id, RedKey.BABY_EQUIP_FOR)
                            RedDotController.ins.up(RedKey.BABY_EQUIP_FOR + vo2.pos_id, babyModel.CanForgeEquip(vo2.pos_id, baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg) ? 1 : 0)
                        }
                        babyModel.Fire(local_BabyEvent.BABY_EQUIP_DATA)
                        babyModel.Fire(local_BabyEvent.UPDATE_EQUIP_RED)
                        CheckEquipRed()
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                        res_mgr.DestoryGameConfig(this, "config_baby_value", false)
                        res_mgr.DestoryGameConfig(this, "config_baby_equip_stage", false)
                        res_mgr.DestoryGameConfig(this, "config_baby_equip_stren", false)
                    }

                }

                res_mgr.LoadGameConfig(this, "config_baby_value", false, undefined, (cfgs) => {
                    baby_value_cfg = cfgs
                    call_func()
                })


                res_mgr.LoadGameConfig(this, "config_baby_equip_stage", false, undefined, (cfgs) => {
                    baby_equip_stage_cfg = cfgs
                    call_func()
                })

                res_mgr.LoadGameConfig(this, "config_baby_equip_stren", false, undefined, (cfgs) => {
                    baby_equip_stren_cfg = cfgs
                    call_func()
                })



            }

            let On18206 = () => {
                let scmd = user_msg_adapter.GetSCMD(18206)
                res_mgr.LoadGameConfig(this, "config_baby_figure_star", false, undefined, (baby_figure_star_cfg) => {
                    babyModel.IlluDataFinish = true
                    babyModel.babyIllusionData = scmd.active_list
                    babyModel.CheckIlluRed(baby_figure_star_cfg)
                    babyModel.Fire(local_BabyEvent.BABY_ILLUSION_DATA)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                    local_GlobalEventSystem.Fire(local_EventName.CHECK_ITEM_USE)
                    res_mgr.DestoryGameConfig(this, "config_baby_figure_star", false)
                })

            }

            let On18207 = () => {
                let scmd = user_msg_adapter.GetSCMD(18207)
                babyModel.babyFamilyData = scmd.info_list.reverse()
                babyModel.Fire(local_BabyEvent.BABY_FAMILY_DATA)
            }

            let On18208 = () => {
                let scmd = user_msg_adapter.GetSCMD(18208)
                babyModel.likeRank = scmd.praise_list
                babyModel.Fire(local_BabyEvent.BABY_LIKE_RANK)
            }

            let On18209 = () => {
                let scmd = user_msg_adapter.GetSCMD(18209)
                babyModel.belikeData = scmd.praise_record
                let red = false
                for (let vo of scmd.praise_record) {
                    if (vo.is_praise_back == 0) {
                        red = true
                    }
                }
                if (!red && babyModel.babyLikeRed) {
                    babyModel.ChangeVar("babyLikeRed", false, false, true)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                }
                babyModel.Fire(local_BabyEvent.BABY_BELIKE_DATA)
            }

            let On18210 = () => {
                let scmd = user_msg_adapter.GetSCMD(18210)
                if (scmd.code == 1) {
                    babyModel.Fire(local_BabyEvent.OPEN_VIEW, "BabyChangedView", 0)

                    let data = {
                        _type: 182,
                        id: 0,
                        isUse: false, // 是否显示使用按钮
                        // isFirst: isFirst,
                        // cb: () => {
                        //     babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18214, "ci", 1, scmd.baby_id)
                        // }
                    }
                    OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)


                    this.SendFmtToGame(18201)
                    babyModel.Fire(local_BabyEvent.OPEN_VIEW, "BabyMainView")
                    // this.SendFmtToGame(18203)
                    // this.SendFmtToGame(18204)
                    // this.SendFmtToGame(18205)
                    // this.SendFmtToGame(18206)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18211 = () => {
                let scmd = user_msg_adapter.GetSCMD(18211)
                if (scmd.code == 1) {
                    let baby_stage_cfgs, baby_value_cfgs

                    let call_func = () => {
                        if (baby_stage_cfgs && baby_value_cfgs) {
                            babyModel.babyCulStageData = scmd
                            babyModel.CheckUpStage(baby_stage_cfgs, baby_value_cfgs)
                            babyModel.Fire(local_BabyEvent.BABY_CULSTAGE, scmd)
                            local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                            local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                            res_mgr.DestoryGameConfig(this, "config_baby_stage", false)
                            res_mgr.DestoryGameConfig(this, "config_baby_value", false)
                        }

                    }

                    res_mgr.LoadGameConfig(this, "config_baby_stage", false, undefined, (cfgs) => {
                        baby_stage_cfgs = cfgs
                        call_func()
                    })


                    res_mgr.LoadGameConfig(this, "config_baby_value", false, undefined, (cfgs) => {
                        baby_value_cfgs = cfgs
                        call_func()
                    })


                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }



            }

            let On18212 = () => {

            }

            let On18213 = () => {
                let scmd = user_msg_adapter.GetSCMD(18213)
                if (scmd.code == 1) {
                    res_mgr.LoadGameConfig(this, "config_baby_figure_star", false, undefined, (baby_figure_star_cfg) => {
                        // Message.show(" 升星成功")
                        let list = babyModel.babyIllusionData;
                        let isFirst: boolean = !(Object.keys(list)?.length)
                        if (list) {
                            let find = false
                            for (let key in list) {
                                if (list[key].baby_id_a == scmd.baby_id) {
                                    list[key].baby_star = scmd.baby_star
                                    list[key].power = scmd.power
                                    list[key].next_power = scmd.next_power
                                    find = true
                                    break
                                }
                            }
                            if (!find) {
                                let vo: any = {}
                                vo.baby_id_a = scmd.baby_id
                                vo.baby_star = scmd.baby_star
                                vo.power = scmd.power
                                vo.power = scmd.next_power
                                list[vo.baby_id_a] = vo
                                this.SendFmtToGame(18206)
                            }
                            babyModel.Fire(local_BabyEvent.BABY_ILLUSION_DATA, scmd)
                        }
                        if (scmd.baby_star == 1) {
                            let data = {
                                _type: 182,
                                id: scmd.baby_id,
                                isFirst: isFirst,
                                isUse: true,
                                cb: () => {
                                    if (!isFirst) {
                                        babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18214, "ci", 1, scmd.baby_id)
                                    }
                                }
                            }

                            if (isFirst) {
                                babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18214, "ci", 1, scmd.baby_id)
                            }

                            OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
                            PlayBigEffect("ui_ZiTi_Jihuo")
                            // babyModel.Fire(local_BabyEvent.OPEN_VIEW, "BabyChangedView", scmd.baby_id)
                        } else {
                            PlayBigEffect("ui_shengxingchengong")
                        }
                        babyModel.CheckIlluRed(baby_figure_star_cfg)
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                        local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                        res_mgr.DestoryGameConfig(this, "config_baby_figure_star", false)
                    })
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18214 = () => {
                let scmd = user_msg_adapter.GetSCMD(18214)
                if (scmd.code == 1) {
                    if (scmd.type == 2) {
                        babyModel.babyUseId = 0
                    } else {
                        Message.show(`形象应用成功`)
                        babyModel.babyUseId = scmd.baby_id
                    }
                    babyModel.Fire(local_BabyEvent.UPDATE_BABY_BASIC)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18215 = () => {
                let scmd = user_msg_adapter.GetSCMD(18215)
                if (scmd.code == 1) {
                    babyModel.babyName = scmd.baby_name
                    babyModel.changedName = 1
                    babyModel.Fire(local_BabyEvent.UPDATE_BABY_BASIC)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18217 = () => {
                let scmd = user_msg_adapter.GetSCMD(18217)
                if (scmd.code == 1) {
                    if (scmd.opr == 1) {
                        Message.show(`逗弄成功`)
                    } else {
                        Message.show(`点赞成功`)
                        this.SendFmtToGame(18209)
                    }
                    if (scmd.rewards.length > 0) {
                        local_Util.ShowCongratulationView(scmd.rewards)
                    }
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18218 = () => {
                let scmd = user_msg_adapter.GetSCMD(18218)
                let baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg

                let call_func = () => {
                    if (baby_value_cfg && baby_equip_stage_cfg && baby_equip_stren_cfg) {
                        if (scmd.code == 1) {
                            let data = babyModel.babyEquipData.equip_list
                            let find = false
                            if (data) {
                                let posData = data[scmd.pos_id]
                                if (posData) {
                                    find = true
                                    posData.id = scmd.goods_id
                                    posData.goods_type_id = scmd.goods_type_id
                                    posData.skill_id = scmd.skill_id
                                } else {
                                    posData = {}
                                    posData.id = scmd.goods_id
                                    posData.goods_type_id = scmd.goods_type_id
                                    posData.skill_id = scmd.skill_id
                                    posData.pos_id = scmd.pos_id
                                    posData.estage = 0
                                    posData.estage_lv = 0
                                    posData.estage_exp = 0
                                }
                                data[scmd.pos_id] = posData
                            }
                            babyModel.babyEquipData.power = scmd.power
                            CheckEquipRed()
                            red_dot_mgr.SetRedStatus(local_ModuleType.BABY_EQUIP_FOR, scmd.pos_id, babyModel.CanForgeEquip(scmd.pos_id, baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg) ? 1 : 0)
                            babyModel.Fire(local_BabyEvent.BABY_EQUIP_DATA, scmd.pos_id)
                            babyModel.Fire(local_BabyEvent.UPDATE_EQUIP_RED)
                            babyModel.Fire(local_BabyEvent.WEAR_SUCCESS, scmd)
                            local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                            local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                            RedDotController.ins.add(RedKey.BABY_EQUIP_FOR + scmd.pos_id, RedKey.BABY_EQUIP_FOR)
                            RedDotController.ins.up(RedKey.BABY_EQUIP_FOR + scmd.pos_id, babyModel.CanForgeEquip(scmd.pos_id, baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg))
                        } else {
                            local_Util.ErrorCodeShow(scmd.code)
                        }
                        res_mgr.DestoryGameConfig(this, "config_baby_value", false)
                        res_mgr.DestoryGameConfig(this, "config_baby_equip_stage", false)
                        res_mgr.DestoryGameConfig(this, "config_baby_equip_stren", false)
                    }

                }

                res_mgr.LoadGameConfig(this, "config_baby_value", false, undefined, (cfgs) => {
                    baby_value_cfg = cfgs
                    call_func()
                })

                res_mgr.LoadGameConfig(this, "config_baby_equip_stage", false, undefined, (cfgs) => {
                    baby_equip_stage_cfg = cfgs
                    call_func()
                })
                res_mgr.LoadGameConfig(this, "config_baby_equip_stren", false, undefined, (cfgs) => {
                    baby_equip_stren_cfg = cfgs
                    call_func()
                })



            }

            let On18219 = () => {
                let scmd = user_msg_adapter.GetSCMD(18219)
                if (scmd.code == 1) {
                    let data = babyModel.babyEquipData.equip_list
                    let find = false
                    if (data) {
                        let posData = data[scmd.pos_id]
                        if (posData) {
                            find = true
                            posData.id = scmd.goods_id
                            posData.goods_type_id = scmd.goods_type_id
                            posData.pos_id = scmd.pos_id
                            posData.estage = scmd.stage
                            posData.estage_lv = scmd.stage_lv
                            posData.estage_exp = scmd.stage_exp
                            data[scmd.pos_id] = posData
                        } else {
                            this.SendFmtToGame(18205)
                        }
                    }
                    babyModel.babyEquipData.power = scmd.power
                    // RedDotManager.GetInstance().SetRedStatus(ModuleType.BABY_EQUIP_FOR, scmd.pos_id, babyModel.CanForgeEquip(scmd.pos_id))
                    babyModel.Fire(local_BabyEvent.BABY_EQUIP_DATA, scmd.pos_id)
                    babyModel.Fire(local_BabyEvent.UPDATE_EQUIP_RED)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18220 = () => {
                let scmd = user_msg_adapter.GetSCMD(18220)
                if (scmd.code == 1) {
                    if (scmd.skill_id) {
                        let data = babyModel.babyEquipData.equip_list
                        let posData = data[scmd.pos_id]
                        if (posData) {
                            posData.skill_id = scmd.skill_id
                            data[scmd.pos_id] = posData
                        } else {
                            this.SendFmtToGame(18205)
                        }
                        babyModel.babyEquipData.power = scmd.power
                        babyModel.Fire(local_BabyEvent.IMP_SUCCESS, scmd)
                        Message.show(`铭刻成功`)
                        CheckEquipRed()
                        babyModel.Fire(local_BabyEvent.BABY_EQUIP_DATA)
                    } else {
                        Message.show(`铭刻失败`)
                        babyModel.Fire(local_BabyEvent.IMP_FAILED, scmd)
                    }
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }
            let On18221 = () => {
                let scmd = user_msg_adapter.GetSCMD(18221)
                // this.SendFmtToGame(18203)
                if (scmd.finish_state == 1) {
                    this.SendFmtToGame(18203)
                } else {
                    let taskList = babyModel.babyCultivateData && babyModel.babyCultivateData.task_list
                    if (taskList) {
                        for (let vo of taskList) {
                            if (vo.task_id == scmd.task_id) {
                                vo.finish_num = scmd.finish_num
                                vo.finish_state = scmd.finish_state
                                babyModel.Fire(local_BabyEvent.UPDATE_TASK, scmd)
                                break
                            }
                        }
                    }
                }
            }

            let On18222 = () => {
                let scmd = user_msg_adapter.GetSCMD(18222)
                this.SendFmtToGame(18203)
                if (scmd.code == 1) {
                    Message.show(`领取成功`)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let On18223 = () => {
                let scmd = user_msg_adapter.GetSCMD(18223)
                let illuData = babyModel.babyIllusionData[scmd.baby_id]
                if (illuData) {
                    illuData.power = scmd.power
                    illuData.next_power = scmd.next_power
                    // } else if (scmd.baby_star != 0) {
                    //     illuData = {}
                    //     illuData.power = scmd.power
                    //     illuData.baby_star = scmd.baby_star
                    //     illuData.baby_id = scmd.baby_id
                    //     babyModel.babyIllusionData[scmd.baby_id] = illuData
                } else {
                    scmd.baby_star = 0
                }
                babyModel.Fire(local_BabyEvent.UPDATE_ILLU_FIGHT, scmd)
            }

            let On18224 = () => {
                let scmd = user_msg_adapter.GetSCMD(18224)
                if (scmd.praiser_id != role_mgr.GetMainRoleId()) {
                    babyModel.ChangeVar("babyLikeRed", true, false, true)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                }
            }

            this.RegisterProtocal(18200, On18200)
            this.RegisterProtocal(18201, On18201)
            this.RegisterProtocal(18202, On18202)
            this.RegisterProtocal(18203, On18203)
            this.RegisterProtocal(18204, On18204)
            this.RegisterProtocal(18205, On18205)
            this.RegisterProtocal(18206, On18206)
            this.RegisterProtocal(18207, On18207)
            this.RegisterProtocal(18208, On18208)
            this.RegisterProtocal(18209, On18209)
            this.RegisterProtocal(18210, On18210)
            this.RegisterProtocal(18211, On18211)
            this.RegisterProtocal(18212, On18212)
            this.RegisterProtocal(18213, On18213)
            this.RegisterProtocal(18214, On18214)
            this.RegisterProtocal(18215, On18215)
            this.RegisterProtocal(18217, On18217)
            // this.RegisterProtocal(18216, On18216)
            this.RegisterProtocal(18218, On18218)
            this.RegisterProtocal(18219, On18219)
            this.RegisterProtocal(18220, On18220)
            this.RegisterProtocal(18221, On18221)
            this.RegisterProtocal(18222, On18222)
            this.RegisterProtocal(18223, On18223)
            this.RegisterProtocal(18224, On18224)


            babyModel.Bind(local_BabyEvent.OPEN_VIEW, async (view_name: string, ...parms) => {
                let view = this.view_dic[view_name]
                if (!view) {
                    this.view_dic[view_name] = true
                    if (!window[view_name]) {
                        if (!ResManager.GetInstance().IsJsLoad("baby")) {
                            await ResManager.GetInstance().LoadJs("baby")
                        }
                    }
                    if (this.view_dic[view_name] == true) {
                        let view_class = window[view_name]
                        view = new view_class()
                        this.view_dic[view_name] = view
                    }
                }
                if (view && view != true) {
                    if (view_name == "BabyMainView" && view.HasOpen() && parms && parms[0] != undefined) {
                        view.SetIndexParameter(parms[0], parms[1])
                        view.SetSelectIndex(parms[0])
                    } else {
                        view.Open(...parms)
                    }
                }
            })

            babyModel.Bind(local_BabyEvent.REQUEST_PROTO, (id, fmt, ...args) => {
                this.SendFmtToGame(id, fmt, ...args)
            })

            local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {
                babyModel.InitCfg()
            })

            local_GlobalEventSystem.Bind(local_EventName.GAME_START, async () => {
                await babyModel.InitCfg()
                this.SendFmtToGame(18201)
            })

            babyModel.Bind(local_BabyEvent.IMP_GOODS, (pos) => {
                this.WriteBegin(18220)
                this.WriteFMT("c", pos)
                let idList = []
                for (let vo of babyModel.PosToMatList) {
                    if (vo) {
                        idList.push(vo.type_id)
                    }
                }
                this.WriteFMT("h", idList.length)
                for (let vo of idList) {
                    this.WriteFMT("i", vo)
                }
                this.SendToGame()
            })

            let check_red_time_id
            goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
                if (!check_red_time_id)
                    check_red_time_id = setTimeout(() => {

                        let baby_stage_cfgs, baby_value_cfgs, baby_figure_star_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg

                        let call_func = () => {
                            if (baby_stage_cfgs && baby_value_cfgs && baby_figure_star_cfg && baby_equip_stage_cfg && baby_equip_stren_cfg) {
                                babyModel.CheckUpStage(baby_stage_cfgs, baby_value_cfgs)
                                babyModel.CheckIlluRed(baby_figure_star_cfg)
                                for (let vo of BabyModel.BabyEqiupPos) {
                                    red_dot_mgr.SetRedStatus(local_ModuleType.BABY_EQUIP_FOR, vo, babyModel.CanForgeEquip(vo, baby_value_cfgs, baby_equip_stage_cfg, baby_equip_stren_cfg) ? 1 : 0)
                                    RedDotController.ins.add(RedKey.BABY_EQUIP_FOR + vo, RedKey.BABY_EQUIP_FOR)
                                    RedDotController.ins.up(RedKey.BABY_EQUIP_FOR + vo, babyModel.CanForgeEquip(vo, baby_value_cfgs, baby_equip_stage_cfg, baby_equip_stren_cfg))
                                }
                                babyModel.Fire(local_BabyEvent.UPDATE_EQUIP_RED)
                                local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                                local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                                res_mgr.DestoryGameConfig(this, "config_baby_stage", false)
                                res_mgr.DestoryGameConfig(this, "config_baby_value", false)
                                res_mgr.DestoryGameConfig(this, "config_baby_figure_star", false)
                                res_mgr.DestoryGameConfig(this, "config_baby_equip_stage", false)
                                res_mgr.DestoryGameConfig(this, "config_baby_equip_stren", false)
                                check_red_time_id = null
                            }

                        }

                        res_mgr.LoadGameConfig(this, "config_baby_stage", false, undefined, (cfgs) => {
                            baby_stage_cfgs = cfgs
                            call_func()
                        })


                        res_mgr.LoadGameConfig(this, "config_baby_value", false, undefined, (cfgs) => {
                            baby_value_cfgs = cfgs
                            call_func()
                        })

                        res_mgr.LoadGameConfig(this, "config_baby_figure_star", false, undefined, (cfgs) => {
                            baby_figure_star_cfg = cfgs
                            call_func()
                        })

                        res_mgr.LoadGameConfig(this, "config_baby_equip_stage", false, undefined, (cfgs) => {
                            baby_equip_stage_cfg = cfgs
                        })

                        res_mgr.LoadGameConfig(this, "config_baby_equip_stren", false, undefined, (cfgs) => {
                            baby_equip_stren_cfg = cfgs
                            call_func()
                        })
                    }, 1500);

            })



            role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level) => {
                if (level == 305) {
                    babyModel.FirstRed = true
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                    local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
                }
            })

            let CheckEquipRed = () => {
                babyModel.CheckBetterEquip()
                local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
                local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
            }
            goods_model.Bind(local_GoodsModel.CHANGE_BABY_BAG, CheckEquipRed)
        }
        this.InitInfo()
    }


}


window["BabyController"] = BabyController