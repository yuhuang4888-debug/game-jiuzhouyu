import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { TurnTableModel } from "../commonModel/TurnTableModel"
import { Role } from "../scene/sceneobj/Role"
import { SkillManager } from "../skill/SkillManager"
import { SkillVo } from "../skill/SkillVo"
import { Message } from "../sysInfo/SysInfoController"
import { TaskFinishView } from "../task/TaskFinishView"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TaskTipType } from "../commonModel/TaskModel"
import { StoryModel } from "../commonModel/StoryModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"

export class PetLvSystemSkillView extends BaseView1 {

    skill_bg: Laya.Image
    icon_bg: Laya.Image
    icon: Laya.Image
    name_text: Laya.Label
    lv_text: Laya.HTMLDivElement
    cur_info: Laya.Box
    _Image1: Laya.Image
    des_text0: Laya.Label
    des_scroller: Laya.Panel
    des_group: Laya.VBox
    des_text: Laya.HTMLDivElement
    next_info: Laya.Box
    _Image11: Laya.Image
    des_text01: Laya.Label
    des_scroller1: Laya.Panel
    des_group1: Laya.VBox
    des_text1: Laya.HTMLDivElement
    fight_text: Laya.Label
    enter_btn: Laya.Box
    enter_img: Laya.Image
    enter_lb: Laya.Label
    max_lv: Laya.Image
    lv_up_red: Laya.Image
    SetMountLv
    SetIsCanLvUp
    InitEvent
    SetData
    Local_Open
    is_can_lv_up
    SetBtn
    UpdateTaskStep
    public constructor() {
        super()

        this.base_file = "pet"
        this.layout_file = "PetLvSystemSkillView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        let local_skillMgr = SkillManager.GetInstance()
        let need_refresh_ = false
        let skill_id_ = null
        let type_id_ = null
        let mount_lv_ = null
        let lv = null
        let max_lv = false
        let is_activity = false
        let is_can_activity = false
        let condition_lv = 0
        this.preload_server_config = {
            "config_skill_lv_data": false
        }
        this.load_callback = () => {
            // ResManager.GetInstance().SetTexture(this, this._Image1, GameResPath.GetIcon("common2", "uity_016j"))
            this.InitEvent()
            if (need_refresh_) {
                this.SetData(skill_id_, type_id_, mount_lv_)
            }
        }

        this.Local_Open = (...parm) => {
            super.Open()

            let skill_id = parm[0]
            let type_id = parm[1]
            let mount_lv = parm[2]
            if (skill_id && type_id != null) {
                this.SetData(skill_id, type_id, mount_lv)
            }
        }

        this.UpdateTaskStep = () => {
            if (!this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
                return
            }
            let step = this.story_model.GetTaskStep(TaskTipType.MountLevel)
            //0级未激活  写死
            // 1402001 坐骑 1
            // 2901001 侍魂 2
            // 1501001 羽翼 3
            // 1601001 御守 4
            // 1701001 神兵 5
            let list = [1402001, 2901001, 1501001, 1601001, 1701001]
            let task_vo = this.task_model.GetMainLineTaskVo()
            if (!task_vo) return
            let task_id = task_vo.id
            if (lv == 0 && list[Number(task_id) - 1] == Number(skill_id_) && step == 2) {
                //还没激活状态
                let step1 = { "direction": 8, "text": "<font color='#0a9f42'>技能</font>需要激活才生效哦", "effect_scaleX": 0.65, "effect_scaleY": 0.9 }
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.enter_btn, "UI", null, null, null, null, step1, true)
            }
        }
        this.SetData = (skill_id?, type_id?, mount_lv?) => {

            skill_id_ = skill_id
            type_id_ = type_id
            mount_lv_ = mount_lv
            for (let key in OutWardBaseModel.GetInstance().GetLvSystemInfo(type_id_).skill_list) {
                if (skill_id_ == OutWardBaseModel.GetInstance().GetLvSystemInfo(type_id_).skill_list[key].skill_id) {
                    lv = OutWardBaseModel.GetInstance().GetLvSystemInfo(type_id_).skill_list[key].skill_level
                    break
                }
            }
            if (this.is_loaded) {
                this.UpdateTaskStep()
                this.lv_text.width = 150
                this.des_text.width = 290
                this.des_text1.width = 290
                need_refresh_ = false
                max_lv = false
                is_activity = false
                is_can_activity = false
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_skill_lv_data", false)
                let skill_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_skill_lv_data.name, skill_id + "@" + lv, false, cfg)// cfg[skill_id + "@" + lv]
                let next_skill_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_skill_lv_data.name, skill_id + "@" + (lv+1), false, cfg)// cfg[skill_id + "@" + (lv + 1)]
                if (skill_vo) {
                    is_activity = true
                    this.name_text.text = skill_vo.lv_name
                    this.lv_text.innerHTML = "等级：<font color='#0a953e'>" + lv + "级</font>"
                    let show_icon = skill_vo.icon
                    if (show_icon) {
                        let url = "resource/game/skillIcon/" + show_icon + ".png"
                        ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, url)
                    }
                    let lv_desc
                    if(window["ChatModel"]){
                        lv_desc = window["ChatModel"].GetInstance().FormatColorTag(skill_vo.desc, false);
                    }
                    else{
                        lv_desc = skill_vo.desc
                    }
                    this.des_text.innerHTML = lv_desc
                    if (next_skill_vo) {
                        this.next_info.visible = true
                        this.display_obj.height = 408
                        this.skill_bg.height = 408
                        this.enter_btn.y = 346
                        let lv_desc
                        if(window["ChatModel"]){
                            lv_desc = window["ChatModel"].GetInstance().FormatColorTag(next_skill_vo.desc, false);
                        }
                        else{
                            lv_desc = next_skill_vo.desc
                        }
                        this.des_text1.innerHTML = lv_desc
                        this.SetIsCanLvUp(next_skill_vo)
                    } else {
                        this.next_info.visible = false
                        this.display_obj.height = 298
                        this.skill_bg.height = 298
                        this.enter_btn.y = 226
                        max_lv = true
                    }
                } else {
                    this.next_info.visible = false
                    skill_vo = cfg[skill_id + "@" + (lv + 1)]
                    this.name_text.text = skill_vo.lv_name
                    this.lv_text.innerHTML = "等级：<font color='#0a953e'>" + lv + "级</font>"
                    let show_icon = skill_vo.icon
                    if (show_icon) {
                        let url = "resource/game/skillIcon/" + show_icon + ".png"
                        ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, url)
                    }
                    let lv_desc
                    if(window["ChatModel"]){
                        lv_desc = window["ChatModel"].GetInstance().FormatColorTag(skill_vo.desc, false);
                    }
                    else{
                        lv_desc = skill_vo.desc
                    }
                    this.des_text.innerHTML = lv_desc
                    this.display_obj.height = 298
                    this.skill_bg.height = 298
                    this.enter_btn.y = 226
                    this.SetIsCanLvUp(skill_vo)
                    if (this.is_can_lv_up) {
                        is_can_activity = true
                    }
                }
                this.SetBtn()
                if (is_can_activity || this.is_can_lv_up) {
                    this.lv_up_red.visible = true
                } else {
                    this.lv_up_red.visible = false
                }
            } else {
                need_refresh_ = true
            }
        }

        this.SetMountLv = (mount_lv) => {
            mount_lv_ = mount_lv_
        }

        this.SetBtn = () => {
            if (max_lv) {
                this.enter_btn.visible = false
                this.max_lv.visible = true
                return
            } else {
                this.enter_btn.visible = true
                this.max_lv.visible = false
            }
            if (this.is_can_lv_up || is_activity) {
                this.enter_lb.text = "升级"
            } else if (!is_activity) {
                this.enter_lb.text = "激活"
            }
        }

        this.SetIsCanLvUp = (info?) => {
            let conditions = ErlangParser.GetInstance().Parse(info.condition)
            for (let key in conditions) {
                if (conditions[key][0] == "mount_upgrade_lv") {
                    this.is_can_lv_up = conditions[key][1] <= mount_lv_ ? true : false
                    condition_lv = conditions[key][1]
                }
            }
        }

        this.InitEvent = () => {
            let Request_lv_up = () => {
                if (is_activity && !this.is_can_lv_up) {
                    Message.show(condition_lv + "级可升级")
                    return
                } else if (max_lv) {
                    Message.show("已满级")
                    return
                } else if (!is_activity && !is_can_activity) {
                    Message.show(condition_lv + "级可激活")
                    return
                }
                OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_LV_UP_SKILL, type_id_, skill_id_)
            }

            Util.AddClickEvent(this.enter_btn, Request_lv_up, this, true)

            let update_fun = (skill_id?, type_id?, skill_lv?) => {
                if (skill_id == skill_id_) {
                    this.SetData(skill_id_, type_id_, mount_lv_)
                }
            }
            this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_LVSYSTEM_SKILL_VIEW, (skill_id?, type_id?, skill_lv?) => {
                update_fun(skill_id, type_id, skill_lv)
                if (this.story_model.GetTaskStep(TaskTipType.MountLevel) > 0) {
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.enter_btn)
                    this.story_model.curr_view_story_step = 3
                    GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
                    this.story_model.UpdateTaskStep(TaskTipType.MountLevel, 0)
                    this.Close()
                }
            })

            this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_LV_UP_SYSTEM_VIEW, (scmd?) => {
                for (let key in scmd.skill_list) {
                    if (scmd.skill_list[key].skill_id == skill_id_) {
                        this.SetData(skill_id_, type_id_, scmd.level)
                        return
                    }
                }
            })
            this.BindEvent(this.story_model, StoryModel.EventName.UPDATE_TASK_STEP, () => {
                this.UpdateTaskStep()
            })
        }
        this.close_callback = () => {
            let step = this.story_model.GetTaskStep(TaskTipType.MountLevel)
            if (step != 0) {
                this.story_model.UpdateTaskStep(TaskTipType.MountLevel, 1)
            }
        }

    }

    public Open(...parm) {
        this.Local_Open(...parm)
    }





    public GetComponents() {
        [
            this.skill_bg,
            this.icon_bg,
            this.icon,
            this.name_text,
            this.lv_text,
            this.cur_info,
            this._Image1,
            this.des_text0,
            this.des_scroller,
            this.des_group,
            this.des_text,
            this.next_info,
            this._Image11,
            this.des_text01,
            this.des_scroller1,
            this.des_group1,
            this.des_text1,
            this.fight_text,
            this.enter_btn,
            this.enter_img,
            this.enter_lb,
            this.max_lv,
            this.lv_up_red
        ]
            = this.GetChildrenByNames([

                "skill_bg",
                "icon_bg",
                "icon",
                "name_text",
                "lv_text",
                "cur_info",
                "_Image1",
                "des_text0",
                "des_scroller",
                "des_group",
                "des_text",
                "next_info",
                "_Image11",
                "des_text01",
                "des_scroller1",
                "des_group1",
                "des_text1",
                "fight_text",
                "enter_btn",
                "enter_img",
                "enter_lb",
                "max_lv",
                "lv_up_red"
            ])
        this.des_text.style.fontSize = 18
        this.des_text.style.color = "#663915"
        this.des_text.style.leading = 5
        this.lv_text.style.fontSize = 20
        this.lv_text.style.color = "#663915"
        this.des_scroller.vScrollBar.visible = false

        this.des_text1.style.fontSize = 18
        this.des_text1.style.color = "#663915"
        this.des_text1.style.leading = 5
        this.des_scroller1.vScrollBar.visible = false
    }
}
window["PetLvSystemSkillView"] = PetLvSystemSkillView