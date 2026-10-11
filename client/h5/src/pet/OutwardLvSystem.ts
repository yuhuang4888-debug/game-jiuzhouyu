import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SkillManager } from "../skill/SkillManager";
import { Message } from "../sysInfo/SysInfoController";
import { GameResPath } from "../util/GameResPath";
import { Runner } from "../util/Runner";
import { Util, GlobalTimerQuest } from "../util/Util";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { PetCrystalView } from "./PetCrystalView";
import { PetEquipOutItem } from "./PetEquipOutItem";
import { PetProptityView } from "./PetProptityView";
import { PetRoundItem } from "./PetRoundItem";
import { ErlangParser } from "../util/ErlangParser";
import { Config } from "../common/Config";
import { TaskTipType } from "../commonModel/TaskModel";
import { CookieWrapper } from "../common/CookieWrapper";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";

export class OutwardLvSystem extends BaseItem1 {
    

    //根据type_id来区分不同的界面
    public type_id

    //子类传入
    public _type
    public _model_type



    private exp_mask: Laya.Sprite

    public max_exp = 0
    public word = `阶`
    public show_type = 0
    protected cur_data

    proptity_view: PetProptityView
    crystal_view: PetCrystalView
    // color_shape

    public tween_ids = []
    public exp_tween_id = []
    public anim_end_list = []
    InitView
    Local_DeleteMe
    Local_InitEvent
    Local_LoadSuccess
    select_tab = 1  //页签
    ChooseView
    UpdateView
    SetLvSkillData
    AutoLvUp
    ShowLvSystemLvUpAni
    InitLvSystem
    Update_eff
    img_eff_run
    img_eff_water
    waterMask
    InitLvSystemSkill
    cur_lv_system_info
    first_show //第一加载特效
    lvsystem_goods
    lvsystem_goods_item
    UpdateLvSystemRed
    lvsystem_is_have_next_lv
    SetBtnGroup1Red
    SetData
    UpdateLvRedOpenState
    red_open_state
    need_fresh
    public constructor(parent) {
        super(parent)

        let skill_list_ = {},
            lv_system_skill_list = {},
            lv_up_skill_list,
            crystal_list_ = {},
            _equip_list_ = new Array<PetEquipOutItem>(),
            lv_system_info,
            lvupIng = false,
            lvup_timer_id,
            will_stop_ani = false,
            now_progress
        this.lvsystem_goods_item = {},
            this.base_file = "pet"
        this.layout_file = "OutwardLvSystem"
        this.layer_value = Enum_UILayer.UI
        // let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mount_level", false)
        let local_outwardModel = OutWardBaseModel
        let local_outwardModelIns = local_outwardModel.GetInstance()
        let local_goodsModel = GoodsModel
        let local_goodsModelIns = local_goodsModel.GetInstance()
        let local_runeIns = Runner.GetInstance()
        this.select_tab = local_outwardModelIns.Choose_Tab
        local_outwardModelIns.Choose_Tab = 1
        this.need_fresh = false
        this.preload_server_config = {
            "config_skill_lv_data": false
        }
        this.first_show = true

        this.load_callback = () => {
            this.InitView()
            this.InitEvent()
            if (this.need_fresh) {
                this.InitLvSystem()
                this.need_fresh = false
            }
        }


        this.InitView = () => {
        }

        this.Local_InitEvent = () => {
            this.BindEvent(local_outwardModelIns, local_outwardModel.CHANGE_VIEW, () => {
                lvupIng = false
                this.lb_btn_group3.text = "一键升级"
                this.lb_btn_group3.strokeColor = "#c95b37"
                this.img_btn_group3.skin = "resource/game/common/texture/com_rect_btn1.png"
                will_stop_ani = true
            }
            )
            this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_BAG_LIST, (goods_list?) => {
                if (this.use_delete_method) {
                    return
                }
                if (!goods_list) {
                    return
                }
                for (let v of goods_list) {
                    for (let type_id in this.lvsystem_goods_item) {
                        if (type_id == v.type_id) {
                            this.UpdateLvSystemRed()
                        }
                    }
                }
            })

            Util.AddClickEvent(this.btn_group3, () => {
                if (!this.lvsystem_is_have_next_lv) {
                    Message.show("已满级")
                    return
                }
                let goods_enough_ = false
                let goods_list = local_outwardModelIns.GetLvSystemGoods(this.type_id, 4)
                for (let goods_id in goods_list) {
                    let vo = goods_list[goods_id]
                    let goods_num = local_goodsModelIns.GetTypeGoodsNum(vo.goods_id)
                    if (goods_num > 0) {
                        goods_enough_ = true
                    }
                }
                if (!goods_enough_) {
                    Message.show("物品不足")
                    return
                }
                lvupIng = !lvupIng
                if (lvupIng) {
                    this.lb_btn_group3.text = "停止升级"
                    this.lb_btn_group3.strokeColor = "#3e9298"
                    this.img_btn_group3.skin = "resource/game/common/texture/com_rect_btn2.png"
                    will_stop_ani = false
                } else {
                    this.lb_btn_group3.text = "一键升级"
                    this.lb_btn_group3.strokeColor = "#c95b37"
                    this.img_btn_group3.skin = "resource/game/common/texture/com_rect_btn1.png"
                    will_stop_ani = true
                }
                this.AutoLvUp()
            }, this, true)

            //开服第8天后才显示
            this._gp_check.visible = ServerTimeModel.GetInstance().GetOpenServerDay() >= 8
            Util.AddClickEvent(this._gp_check, () => {
                let bool = true
                if(local_outwardModelIns.lv_red_open_state_dic && local_outwardModelIns.lv_red_open_state_dic[this.type_id] != null){
                    bool = local_outwardModelIns.lv_red_open_state_dic[this.type_id]
                }
                local_outwardModelIns.ChangeLvRedOpenState(this.type_id, !bool)

            }, this, true)

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_LV_UP_SYSTEM_VIEW, (scmd?, changelv?) => {
                if (changelv) {
                    this.SetLvSkillData()
                }
                this.ShowLvSystemLvUpAni(scmd, changelv)
            })

            this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_LVSYSTEM_SKILL_VIEW, () => {
                this.SetLvSkillData()
            })


            this.BindEvent(local_outwardModelIns, OutWardBaseModel.UPDATE_LV_RED_OPEN_STATE, (type_id) => {
                if(type_id == this.type_id){
                    this.UpdateLvRedOpenState()
                    this.UpdateLvSystemRed()
                }
            })
        }


        this.Local_DeleteMe = () => {
            for (let index in this.lvsystem_goods_item) {
                this.lvsystem_goods_item[index].DeleteMe()
                delete this.lvsystem_goods_item[index]
            }
            this.lvsystem_goods_item = {}

            this.anim_end_list = []

            if (lvup_timer_id) {
                GlobalTimerQuest.CancelQuest(lvup_timer_id)
                lvup_timer_id = null
            }

            if (lv_system_skill_list) {
                for (let key in lv_system_skill_list) {
                    lv_system_skill_list[key].DeleteMe()
                    delete lv_system_skill_list[key]
                }
            }
            lv_system_skill_list = {}

            super.DeleteMe()

        }

        this.InitLvSystem = () => {
            lv_system_info = local_outwardModelIns.GetLvSystemInfo(this.type_id)
            if (!lv_system_info) {
                local_outwardModelIns.Fire(local_outwardModel.REQUEST_LV_INFO, this.type_id)
                return
            }
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_level
            this.cur_lv_system_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_level.name, this.type_id + "@" + lv_system_info.level, false, cfg)// this.preload_server_config["config_mount_level"][this.type_id + "@" + lv_system_info.level]
            this.lvsystem_is_have_next_lv = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_level.name, this.type_id + "@" + (lv_system_info.level + 1), false, cfg)// this.preload_server_config["config_mount_level"][this.type_id + "@" + (lv_system_info.level + 1)]
            let cur_progress = lv_system_info.cur_exp + "/" + this.cur_lv_system_info.need_exp
            this.lb_exp_progress.text = cur_progress.toString()
            ResManager.GetInstance().SetTexture(this, this.down_bg, GameResPath.GetIcon("pet", "ui_shape_42"))
            this.lvsystem_goods = local_outwardModelIns.GetLvSystemGoods(this.type_id, 4)
            for (let goods_id in this.lvsystem_goods) {
                let vo = this.lvsystem_goods[goods_id]
                let item = this.lvsystem_goods_item[vo.goods_id]
                if (!item) {
                    item = new BaseAwardItem(this.goods_group)
                    item.Load()
                    item.SetItemSize(90, 90)
                    item.SetFontSize(30)
                    this.lvsystem_goods_item[vo.goods_id] = item
                }
                let goods_num = local_goodsModelIns.GetTypeGoodsNum(vo.goods_id)
                item.SetData(vo.goods_id, goods_num)
                item.ExcuteCallback(() => {
                    item.ForceSetNumber(goods_num)
                })
            }
            this.img_btn_group3_red.visible = local_outwardModelIns.LvsystemCanLvUp(this.type_id)
            this.waterMask = new Laya.Sprite()
            this.AddUIEffect(`ui_duobao_01_01`, this.glassGp, undefined, 8, true, null, null, null, null, null, null, null, false)
            this.img_eff_run = this.AddUIEffect(`ui_duobao_01_02`, this.runeGp, undefined, 8, true, undefined, undefined,)
            this.img_eff_water = this.AddUIEffect(`ui_duobao_01_03`, this.waterGp, undefined, 9, true, undefined, undefined, () => {
                if (this.first_show) {
                    if (this.lvsystem_is_have_next_lv) {
                        this.Update_eff(lv_system_info.cur_exp / this.cur_lv_system_info.need_exp)
                    } else {
                        this.Update_eff(1)
                        this.lb_exp_progress.text = "已满级"
                    }

                    this.first_show = false
                }
            })
            if (!this.first_show) {
                if (this.lvsystem_is_have_next_lv) {
                    this.Update_eff(Number(lv_system_info.cur_exp / this.cur_lv_system_info.need_exp))
                } else {
                    this.Update_eff(1)
                    this.lb_exp_progress.text = "已满级"
                }

            }
            this.InitLvSystemSkill()
            this.SetLvSkillData()
            this.UpdateLvRedOpenState()
        }
        this.InitLvSystemSkill = () => {
            lv_up_skill_list = local_outwardModelIns.GetLvSystemInfo(this.type_id).skill_list
            let sort_func = (a?, b?) => {
                return a.skill_id < b.skill_id
            }
            table.sort(lv_up_skill_list, sort_func)
            for (let skill_id in lv_up_skill_list) {
                let skill_item = lv_system_skill_list[lv_up_skill_list[skill_id].skill_id]
                if (!skill_item) {
                    skill_item = new PetRoundItem(this.lv_skill_group)
                    skill_item.Load()
                    lv_system_skill_list[lv_up_skill_list[skill_id].skill_id] = skill_item
                }
            }
        }

        this.SetLvSkillData = () => {
            lv_system_info = local_outwardModelIns.GetLvSystemInfo(this.type_id)
            for (let skill_id in lv_system_skill_list) {
                let skill_vo = SkillManager.GetInstance().getSkill(skill_id)
                let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
                let source_str = `resource/game/skillIcon/${show_icon}.png`
                let SkillClickFunc = () => {
                    this.story_model.UpdateTaskStep(TaskTipType.MountLevel, 2)
                    local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "PetLvSystemSkillView", skill_id, this.type_id, local_outwardModelIns.GetLvSystemInfo(this.type_id).level)
                }
                let is_lock = true
                let lock_stage
                let lv
                let is_can_lv_up
                if (lv_system_info) {
                    for (let key in lv_system_info.skill_list) {
                        if (lv_system_info.skill_list[key].skill_id == skill_id) {
                            lv = lv_system_info.skill_list[key].skill_level
                            is_lock = lv == 0 ? true : false
                            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_skill_lv_data", false)
                            let next_skill_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_skill_lv_data.name, skill_id + "@" + (lv + 1), false, cfg)// cfg[skill_id + "@" + (lv + 1)]
                            if (next_skill_vo) {
                                let conditions = ErlangParser.GetInstance().Parse(next_skill_vo.condition)
                                for (let key in conditions) {
                                    if (conditions[key][0] == "mount_upgrade_lv") {
                                        is_can_lv_up = conditions[key][1] <= lv_system_info.level ? true : false
                                        if (is_can_lv_up) break
                                    }
                                }
                                break
                            }
                        }
                    }
                }
                lv_system_skill_list[skill_id].SetData(source_str, SkillClickFunc, is_lock, lock_stage, 0, 0, false, false, null, null, lv, skill_id, is_can_lv_up)
            }
        }

        this.UpdateLvSystemRed = () => {
            if (local_outwardModelIns.LvsystemCanLvUp(this.type_id)) {
                this.img_btn_group3_red.visible = true
            } else {
                this.img_btn_group3_red.visible = false
            }
            for (let key in this.lvsystem_goods_item) {
                let goods_number = local_goodsModelIns.GetTypeGoodsNum(key)
                this.lvsystem_goods_item[key].ExcuteCallback(() => {
                    this.lvsystem_goods_item[key].ForceSetNumber(goods_number)
                })
            }
        }

        this.AutoLvUp = () => {
            if (lvupIng) {
                if (lvup_timer_id) {
                    GlobalTimerQuest.CancelQuest(lvup_timer_id)
                }
                local_outwardModelIns.Fire(local_outwardModel.REQUEST_LV_UP, this.type_id)
            }
        }

        this.ShowLvSystemLvUpAni = (scmd?, changelv?) => {
            if (scmd.type_id != this.type_id) return
            if (lvup_timer_id) {
                GlobalTimerQuest.CancelQuest(lvup_timer_id)
            }
            lvup_timer_id = null
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_level
            let cur_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_level.name, this.type_id + "@" + scmd.level, false, cfg)
            let next_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_level.name, this.type_id + "@" + (lv_system_info.level + 1), false, cfg)
            let endnumber = scmd.cur_exp / cur_cfg.need_exp
            this.lvsystem_is_have_next_lv = next_cfg
            if (!this.lvsystem_is_have_next_lv) {
                endnumber = 1
                this.lb_exp_progress.text = "已满级"
            } else {
                this.lb_exp_progress.text = scmd.cur_exp + "/" + cur_cfg.need_exp
            }
            if (changelv) {
                lvup_timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
                    if (now_progress < 1) {
                        now_progress += 0.05
                        this.Update_eff(now_progress)
                    } else {
                        now_progress = 0
                        this.Update_eff(now_progress)
                        if (lvup_timer_id) {
                            GlobalTimerQuest.CancelQuest(lvup_timer_id)
                        }
                        lvup_timer_id = null
                        lvup_timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
                            if (now_progress < endnumber) {
                                now_progress += 0.05
                                this.Update_eff(now_progress)
                            } else {
                                now_progress = endnumber
                                this.Update_eff(now_progress)
                                if (lvup_timer_id) {
                                    GlobalTimerQuest.CancelQuest(lvup_timer_id)
                                }
                                let canlvup = local_outwardModelIns.LvsystemCanLvUp(this.type_id, true)
                                if (lvupIng && canlvup && !will_stop_ani) {
                                    this.AutoLvUp()
                                } else {
                                    lvupIng = false;
                                    this.lb_btn_group3.text = "一键升级"
                                    this.lb_btn_group3.strokeColor = "#c95b37"
                                    this.img_btn_group3.skin = "resource/game/common/texture/com_rect_btn1.png"
                                }
                            }
                        }, 0.0001, -1)
                    }
                }, 0.0001, -1)
            } else {
                lvup_timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
                    if (now_progress < endnumber) {
                        now_progress += 0.01
                        this.Update_eff(now_progress)
                    } else {
                        now_progress = endnumber
                        this.Update_eff(now_progress)
                        if (lvup_timer_id) {
                            GlobalTimerQuest.CancelQuest(lvup_timer_id)
                        }
                        let canlvup = local_outwardModelIns.LvsystemCanLvUp(this.type_id)
                        if (lvupIng && canlvup && !will_stop_ani) {
                            this.AutoLvUp()
                        } else {
                            lvupIng = false;
                            this.lb_btn_group3.text = "一键升级"
                            this.lb_btn_group3.strokeColor = "#c95b37"
                            this.img_btn_group3.skin = "resource/game/common/texture/com_rect_btn1.png"
                        }
                    }
                }, 0.0001, -1)
            }

            // this.Update_eff(endnumber)
            this.UpdateLvSystemRed()
        }

        this.Update_eff = (end_numb) => {
            now_progress = end_numb
            if (this.use_delete_method) {
                return
            }
            if (this.img_eff_run && this.img_eff_water) {
                if (end_numb > 1) {
                    end_numb = 1
                } else if (end_numb < 0) {
                    end_numb = 0
                }
                this.runeGp.visible = end_numb == 1 ? false : true
                this.waterMask.graphics.clear()
                this.waterMask.graphics.drawCircle(0, 0, this.waterGp.height / 2, "#ff0000");
                this.waterMask.pos(this.img_eff_water.width / 2, this.img_eff_water.height / 2);
                let child = this.waterGp.getChildAt(0)
                if (child)
                    child.mask = this.waterMask;
                this.img_eff_water.centerY = 138 - 138 * end_numb
                if (this.img_eff_water.mask)
                    this.img_eff_water.mask.y = this.img_eff_water.height / 2 - 138 + 138 * end_numb
                let num = 0
                if (1 - end_numb > 0.5) {
                    num = Math.sqrt(68 * 68 - (136 * (1 - end_numb) - 68) * (136 * (1 - end_numb) - 68)) * 2
                } else if (1 - end_numb < 0.5) {
                    num = Math.sqrt(68 * 68 - (68 - 136 * (1 - end_numb)) * (68 - 136 * (1 - end_numb))) * 2
                } else {
                    num = 145
                }
                this.img_eff_run.scaleX = num / 145
                this.img_eff_run.centerY = -69 + 138 * (1 - end_numb)
            }
        }
        this.SetData = (type_id?) => {
            this.type_id = type_id
            if (this.is_loaded) {
                this.InitLvSystem()
            } else {
                this.need_fresh = true
            }
        }
        this.UpdateLvRedOpenState = ()=>{
            let bool = true
            if(local_outwardModelIns.lv_red_open_state_dic && local_outwardModelIns.lv_red_open_state_dic[this.type_id] != null){
                bool = local_outwardModelIns.lv_red_open_state_dic[this.type_id]
            }
            this._img_check.visible = bool
        }
        //第一次添加到舞台的时候调用
        this.createChildren = () => {
            if (this["GetComponents"]) {
                this["GetComponents"]()
                this.is_get = true
            }
            this.story_obj_list = this.story_obj_list || {}


            //         // 100901 坐骑 1
            //         // 100521 侍魂 2
            //         // 101788 羽翼 3
            //         // 101695 御守 4
            //         // 101406 神兵 5
            this.story_obj_list[TaskTipType.MountLevel] = this.story_obj_list[TaskTipType.MountLevel] || []
            this.story_obj_list[TaskTipType.MountLevel][1] = [null, null, this.btn_group3]
            this.story_obj_list[TaskTipType.MountLevel][2] = [null, null, this.btn_group3]
            this.story_obj_list[TaskTipType.MountLevel][3] = [null, null, this.btn_group3]
            this.story_obj_list[TaskTipType.MountLevel][4] = [null, null, this.btn_group3]
            this.story_obj_list[TaskTipType.MountLevel][5] = [null, null, this.btn_group3]
            super.createChildren()
        }

    }
    public LoadSuccess() {
        this.Local_LoadSuccess()
    }


    public InitEvent() {
        this.Local_InitEvent()
    }

    public DeleteMe() {
        this.Local_DeleteMe()
    }

    public SetModel(stage?) {

    }

    down_bg: Laya.Image
    skill_bg: Laya.Image
    lv_skill_group: Laya.HBox
    lv_exp_group: Laya.Box
    Round2: Laya.Image
    waterGp
    runeGp: Laya.Box
    glassGp: Laya.Box
    maxGp: Laya.Box
    lb_exp_progress: Laya.Label
    btn_group3: Laya.Box
    img_btn_group3: Laya.Image
    lb_btn_group3: Laya.Label
    img_btn_group3_red: Laya.Image
    goods_group: Laya.Box
    goods_number: Laya.Label
    goods_icon: Laya.Image
    _gp_check: Laya.Image
    _img_check: Laya.Image
    _lb_check: Laya.Label
    public GetComponents() {
        [
            this.down_bg,
            this.skill_bg,
            this.lv_skill_group,
            this.lv_exp_group,
            this.Round2,
            this.waterGp,
            this.runeGp,
            this.glassGp,
            this.maxGp,
            this.lb_exp_progress,
            this.btn_group3,
            this.img_btn_group3,
            this.lb_btn_group3,
            this.img_btn_group3_red,
            this.goods_group,
            this.goods_number,
            this.goods_icon,
            this._gp_check,
            this._img_check,
            this._lb_check
        ]
            = this.GetChildrenByNames([

                "down_bg",
                "skill_bg",
                "lv_skill_group",
                "lv_exp_group",
                "Round2",
                "waterGp",
                "runeGp",
                "glassGp",
                "maxGp",
                "lb_exp_progress",
                "btn_group3",
                "img_btn_group3",
                "lb_btn_group3",
                "img_btn_group3_red",
                "goods_group",
                "goods_number",
                "goods_icon",
                "_gp_check",
                "_img_check",
                "_lb_check"
            ])
    }
}
window["OutwardLvSystem"] = OutwardLvSystem