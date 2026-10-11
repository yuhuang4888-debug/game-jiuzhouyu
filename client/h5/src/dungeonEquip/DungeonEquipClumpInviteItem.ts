import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamModel } from "../commonModel/TeamModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { Util, HtmlColorTxt, GlobalTimerQuest } from "../util/Util"
import { DungeonEquipDefine } from "./DungeonEquipDefine"

export class DungeonEquipClumpInviteItem extends BaseItemRenderer {
    time_id
    role_head
    public WIDTH = 576
    public HEIGT = 104
    is_set
    public constructor(parent) {
        super()

        this.base_file = "dungeonEquip"
        this.layout_file = "DungeonEquipClumpInviteItem"

        this.load_callback = () => {

            this._lb_times.style.color="#0a953e"
            this._lb_times.style.width=100
            this._lb_times.style.fontSize=20
            this._lb_times.style.wordWrap=false

            this.InitEvent()

            if (!this.is_set) {
                this.is_set = true
                this.SetData()
            }
        }
        this.Load()
    }

    public InitEvent() {

        Util.AddClickEvent(
            this._gp_invite, () => {
                let data = this.data
                if (this.data) {
                    let time_id = TeamModel.GetInstance().GetInviteIntervalState(data.role_id)
                    if (time_id && time_id > TimeUtil.getServerTime()) {
                        Message.show("邀请冷却中")
                        return
                    } else {
                        TeamModel.GetInstance().InviteJoinTeam(data.role_id)
                        TeamModel.GetInstance().SetInviteIntervalState(data.role_id)
                        let end_time = TimeUtil.getServerTime() + DungeonEquipDefine.InviteInterval
                        Util.SetImageGray(this._Image4, true)
                        this.StartCountTime(() => {
                            let left_time = end_time - TimeUtil.getServerTime()
                            if (left_time < 0) {
                                this._lb_invite.text = "邀请"
                                this._lb_invite.stroke=2
                                Util.SetImageGray(this._Image4, false)
                                this.CancelCountTime()
                                return
                            }
                            this._lb_invite.stroke=0
                            this._lb_invite.text = left_time + "s"
                        }
                        )
                    }
                }
            },
            this,
            true
        )
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        if (this.is_loaded) {
            this.SetData()
            this.is_set = true
        } else {
            this.is_set = false
        }

    }

    SetData() {
        if(!this.data)return
        let data = this.data
        this._lb_name.text = data.name
        this._lb_fighting.text = "战力:" + data.combat_power
        if (data.max_count && data.max_count > 0) {
            let left_time = data.max_count - data.count
            // [ts2lua]lua中0和空字符串也是true，此处left_time == 0需要确认
            this._lb_times.innerHTML =
                Util.StrToHTML(HtmlColorTxt(left_time, (left_time == 0 && (ColorUtil.GetColorDark(ColorType.RED)) || (ColorUtil.GetColorDark(ColorType.GREEN)))) + "/" + data.max_count)
        } else {
            this._lb_times.innerHTML = "Lv." + data.level
        }
        let time_id = TeamModel.GetInstance().GetInviteIntervalState(data.role_id)
        if (time_id && time_id > TimeUtil.getServerTime()) {
            Util.SetImageGray(this._Image4, true)
            this.StartCountTime(() => {
                let left_time = time_id - TimeUtil.getServerTime()
                if (left_time < 0) {
                    this._lb_invite.text = "邀请"
                    this._lb_invite.stroke=2
                    Util.SetImageGray(this._Image4, false)
                    this.CancelCountTime()
                    return
                }
                this._lb_invite.stroke=0
                this._lb_invite.text = left_time + "s"
            }
            )
        }
        //let picture = data.picture
        //let career = data.career
        //let picture_source = null
        //let _source = career + "001"
        //if (picture && Trim(picture) != "" ) {
        //    // [ts2lua]Config.PRELOAD_SETVER_CONFIG.config_picture下标访问可能不正确
        //    let picture_cfg = Config.Picture[picture]
        //    if (picture_cfg ) {
        //        _source = picture_cfg.resource
        //    }
        //}
        //picture_source = GameResPath.GetIcon("head", _source)
        //lua_resM:SetOutsideImageSprite(this, this._img_head, picture_source)

        if (!this.role_head) {
            this.role_head = new CustomHeadItem(this._img_head)
            this.role_head.Load()
        }
        // data.role_id = data.id
        this.role_head.SetData(data.role_id, data.career, data.sex, data.picture, data.picture_ver)
    }

    public DeleteMe() {

        if (this.role_head) {
            this.role_head.DeleteMe()
            this.role_head = null
        }
        this.CancelCountTime()
        super.DeleteMe()
    }

    public StartCountTime(func?) {

        this.CancelCountTime()
        this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1)
        func()
    }

    public CancelCountTime() {

        if (this.time_id) {
            GlobalTimerQuest.CancelQuest(this.time_id)
            this.time_id = null
        }
    }

  
_Image1:Laya.Image
_img_head:Laya.Box
_lb_name:Laya.Label
_lb_fighting:Laya.Label
_lb_times:Laya.HTMLDivElement
_gp_invite:Laya.Box
_Image4:Laya.Image
_lb_invite:Laya.Label
public GetComponents() {
[
this._Image1,
this._img_head,
this._lb_name,
this._lb_fighting,
this._lb_times,
this._gp_invite,
this._Image4,
this._lb_invite,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_head",
"_lb_name",
"_lb_fighting",
"_lb_times",
"_gp_invite",
"_Image4",
"_lb_invite",
])
}
}
 window["DungeonEquipClumpInviteItem"]= DungeonEquipClumpInviteItem