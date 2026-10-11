import { Alert, Alert_Type } from "../alert/Alert";
import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendModel } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { HtmlColorTxt, Util } from "../util/Util";

//伴侣-离婚界面
export class MarriageBreakView extends BaseView1 {


    private _head_self: CustomHeadItem;
    private _head_other: CustomHeadItem;

    Local_Open
    Clear
    LoadSuccess
    InitEvent
    UpdateCostData
    public constructor() {
        super()
        this.base_file = "marriage"
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageBreakView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            dress_model = DressModel.GetInstance(),
            Photo = DressType.Photo,
            local_Util = Util,
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            res_mgr = ResManager.GetInstance(),
            _other_vo_

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("marriage", "uijh_081"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_086, GameResPath.GetIcon("marriage", "ui_marry_30"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uijh_090"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.destroy_callback = function () {
            this.Clear()
        }

        this.Local_Open = (parms) => {
            [_other_vo_] = parms
            super.Open()
        }

        this.Clear = () => {
            if (this._head_self) {
                this._head_self.DeleteMe()
                this._head_self = undefined
            }
            if (this._head_other) {
                this._head_other.DeleteMe()
                this._head_other = undefined
            }
        }

        this.LoadSuccess = () => {
            this._head_self = new CustomHeadItem(this._head_self_con)
            this._head_self.Load()
            this._head_other = new CustomHeadItem(this._head_other_con)
            this._head_other.Load()

            let role_vo = RoleManager.GetInstance().GetMainRoleVo()
            this._head_self.SetRoleVoData(role_vo)
            this._lb_name_self.text = role_vo.name
            //this._lb_power_self.text = `z${role_vo.fighting}`

            let other_vo = _other_vo_
            this._head_other.SetRoleVoData(other_vo)
            this._lb_name_other.text = other_vo.name
            //this._lb_power_other.text = `z${other_vo.combat_power}`
            this.UpdateCostData()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_peace, () => {
                _model.Fire(REQUEST_PROTO, 17234, "c", 1)
            }, this, true)

            //强制离婚
            local_Util.AddClickEvent(this._btn_force, () => {
                // if (show) {
                //     let data = cost_list[0]
                //     let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
                //     let item_name = GoodsModel.GetGoodsName(type_id)

                //     let str = `离婚对象离线未超过48小时,强行离婚<br>需要消耗${data[2]}${HtmlColorTxt(item_name,Enum_ColorUtil_Dark.GREEN)}`
                //     Alert.Show(str, Alert_Type.Two, () => {
                //         let jin_lock = RoleManager.GetInstance().GetMainRoleVo().jinLock
                //        //let jin = RoleManager.GetInstance().GetMainRoleVo().jin
                //         if (jin_lock < data[2] ) {
                //             Message.show("绑钻不足")
                //         } else {
                //             _model.Fire(REQUEST_PROTO, 17234, "c", 2)
                //         }
                //     })
                // } else {
                //     _model.Fire(REQUEST_PROTO, 17234, "c", 2)
                // }
                _model.Fire(REQUEST_PROTO, 17234, "c", 2)
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

        }
        let show
        let cost_list
        this.UpdateCostData = () => {
            cost_list = JSON.parse(_model.GetConstantData(12))
            show = cost_list && cost_list.length > 0

            //对象离线48小时  强制离婚不用消耗
            let m_vo = _model.GetMateInfo()
            let vo = FriendModel.GetInstance().getFriendById(m_vo.role_id)
            let twe_day_sce = TimeUtil.OneDayMs / 1000 * 2
            if (vo.online_flag==0&&vo.offline_time > twe_day_sce) {
                show = false
            }

            this._group_cost.visible = show
            this.labelDisplay111.text=show?"强制离婚":"免费离婚"
            this._lb_msg2.visible =!show
            if (show) {
                let data = cost_list[0]
                let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
                res_mgr.SetTexture(this, this._img_cost, GoodsModel.GetGoodsPath(type_id))
                this._lb_cost.text = data[2]
            }
        }
    }


    public Open(...parms) {
        this.Local_Open(parms)
    }



img1:Laya.Image
_img_bg:Laya.Image
img3:Laya.Image
_img_086:Laya.Image
img4:Laya.Image
_btn_close:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_lb_msg:Laya.Label
_lb_msg2:Laya.Label
group1:Laya.Box
img5:Laya.Image
_lb_name_self:Laya.Label
_head_self_con:Laya.Box
group2:Laya.Box
img6:Laya.Image
_head_other_con:Laya.Box
_lb_name_other:Laya.Label
_btn_peace:Laya.Box
_Image11:Laya.Image
labelDisplay11:Laya.Label
_btn_force:Laya.Box
_Image111:Laya.Image
labelDisplay111:Laya.Label
_group_cost:Laya.Box
_img_cost:Laya.Image
_lb_cost:Laya.Label
public GetComponents() {
[
this.img1,
this._img_bg,
this.img3,
this._img_086,
this.img4,
this._btn_close,
this._Image1,
this.labelDisplay,
this._lb_msg,
this._lb_msg2,
this.group1,
this.img5,
this._lb_name_self,
this._head_self_con,
this.group2,
this.img6,
this._head_other_con,
this._lb_name_other,
this._btn_peace,
this._Image11,
this.labelDisplay11,
this._btn_force,
this._Image111,
this.labelDisplay111,
this._group_cost,
this._img_cost,
this._lb_cost,
]
 = this.GetChildrenByNames([

"img1",
"_img_bg",
"img3",
"_img_086",
"img4",
"_btn_close",
"_Image1",
"labelDisplay",
"_lb_msg",
"_lb_msg2",
"group1",
"img5",
"_lb_name_self",
"_head_self_con",
"group2",
"img6",
"_head_other_con",
"_lb_name_other",
"_btn_peace",
"_Image11",
"labelDisplay11",
"_btn_force",
"_Image111",
"labelDisplay111",
"_group_cost",
"_img_cost",
"_lb_cost",
])
}
}
 window["MarriageBreakView"]= MarriageBreakView