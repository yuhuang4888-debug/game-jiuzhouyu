import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { FriendModel } from "../commonModel/FriendModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { TimeUtil } from "../util/TimeUtil";
import { AtlasUrl, Util } from "../util/Util";
import { BanquetModel, BanqEvent } from "../commonModel/BanquetModel";
import { GameResPath } from "../util/GameResPath";
import { ViewManager } from "../common/ViewManager";

export class MarriageMainView extends BaseItem1 {

    LoadSuccess
    InitEvent
    UpdateView
    UpdateIntimacy
    UpdateGiftData
    SetSelfData
    SetMateData
    SetDataVisible
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageMainView"
        let _model = MarriageModel.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            local_GlobalEventSystem = GlobalEventSystem,
            OPEN_VIEW = EventName.OPEN_VIEW,
            role_mgr = RoleManager.GetInstance(),
            friend_model = FriendModel.GetInstance(),
            local_TimeUtil = TimeUtil,
            local_Math = Math,
            local_UI_MODEL_TYPE = UI_MODEL_TYPE,
            _um_self_: UIModelClass3D,
            _um_mate_: UIModelClass3D

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mate, GameResPath.GetIcon("marriage", "uijh_024b"))
            this.InitEvent()
            this.LoadSuccess()

        }
        this.DeleteMe = () => {
            if (_um_self_) {
                _um_self_.DeleteMe()
                _um_self_ = undefined
            }
            if (_um_mate_) {
                _um_mate_.DeleteMe()
                _um_mate_ = undefined
            }
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17232)
            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17238)
            this.SetSelfData()
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("marriage", "ui_marry_bg"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._btn_flower, GameResPath.GetIcon("marriage", "uijh_023b"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._btn_flow, GameResPath.GetIcon("marriage", "uijh_023a"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._btn_banquet, GameResPath.GetIcon("marriage", "uijh_023c"))
            this.banqRed.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.MARRIAGE_ASK, 1)
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_dsgt, () => {
                // Message.show("敬请期待")
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageDsgtView")
            }, this, true)

            local_Util.AddClickEvent(this._btn_break, () => {
                let mate_info = _model.GetMateInfo()
                if (!mate_info) return
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageBreakView", mate_info)
            }, this, true)

            local_Util.AddClickEvent(this._btn_flower, () => {
                let mate_info = _model.GetMateInfo()
                if (!mate_info) return
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageFlowerView", mate_info)
            }, this, true)

            local_Util.AddClickEvent(this._btn_flow, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageFlowView")
            }, this, true)

            local_Util.AddClickEvent(this._btn_again, () => {
                let role_vo = role_mgr.GetMainRoleVo()
                let fri_vo = friend_model.getFriendById(role_vo.marriage_id)
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageAskView", fri_vo)
            }, this, true)

            local_Util.AddClickEvent(this._btn_ask, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageAskView")
            }, this, true)

            local_Util.AddClickEvent(this._btn_find, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageAskListView")
                // local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageBaseView")
            }, this, true)


            Util.AddClickEvent(this._box_info, (evt: Laya.Event) => {

                let mate_info = _model.GetMateInfo()
                if (!mate_info) return
                mate_info.role_name=mate_info.name
                let pos = this._box_info.localToGlobal(new Laya.Point(100, 150))
                evt.stopPropagation()

                if (!ViewManager.GetInstance().GetViewOpenState('MarriageRoleMenuView')) {
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageRoleMenuView", mate_info, pos) 
                }else{
                    GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "MarriageRoleMenuView") 
                }
   
            }, this, true)



            this.BindVar(_model, "_mate_info", () => {
                this.UpdateView()
            })


            this.BindEvent(BanquetModel.GetInstance(), BanqEvent.APPLY_VIEW_DATA, (scmd) => {
                this.UpdateView()
            })


            this.BindVar(_model, "_gift_info", () => {
                this.UpdateGiftData()
            })

            this.BindEvent(_model, local_MarriageEvent.GIVE_GIFT_SUCCESS, (scmd) => {
                this.UpdateIntimacy(scmd.receive_id)
            })

            this.BindEvent(_model, local_MarriageEvent.GET_FLOWER, (scmd) => {
                this.UpdateIntimacy(scmd.role_id)
            })

            local_Util.AddClickEvent(this._btn_banquet, () => {
                // Message.show("敬请期待")
                local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetApplyView",93,1)
                local_GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "MarriageBaseView")
            }, this, true)
     
        }

        this.UpdateView = () => {
            let mate_info = _model.GetMateInfo()
            if (!mate_info) return
            let married = !!mate_info.role_id
            this.SetMateData(mate_info)
            this.SetDataVisible(married)
            if (married) {
                let fri_vo = friend_model.getFriendById(mate_info.role_id)
                if (fri_vo) {
                    this._lb_intimacy.text = fri_vo.intimacy.toString()
                }
                let day = local_Math.floor((local_TimeUtil.getServerTime() - mate_info.anniversary_time) / 86400)
                this._lb_day.text = `${day}天`
            }
            this.banqRed.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.MARRIAGE_ASK, 1)
        }

        this.UpdateIntimacy = (role_id) => {
            let mate_info = _model.GetMateInfo()
            if (!mate_info) return
            if (mate_info.role_id != role_id) return
            let fri_vo = friend_model.getFriendById(mate_info.role_id)
            if (fri_vo) {
                this._lb_intimacy.text = fri_vo.intimacy.toString()
            }
        }

        this.UpdateGiftData = () => {
            let gift_info = _model.GetGiftInfo()
            if (!gift_info) return
            let buy_data = _model.GetGiftDataByType(1)
            let day_data = _model.GetGiftDataByType(2)

            let stime = local_Math.max(gift_info.love_gift_time_s - local_TimeUtil.getServerTime(), 0)
            let otime = local_Math.max(gift_info.love_gift_time_o - local_TimeUtil.getServerTime(), 0)

            this._lb_time_self.text = (stime != undefined) ? `剩余${local_Math.ceil(otime / 86400)}天` : "尚未获得"
            this._lb_time_mate.text = (otime != undefined) ? `剩余${local_Math.ceil(stime / 86400)}天` : "尚未获得"
        }

        this.SetSelfData = () => {
            if (_um_self_) return
            let role_vo = role_mgr.GetMainRoleVo()
            let is_man = role_vo.sex == 1
            this._lb_name_self.text = role_vo.name
            this._img_sex_self.skin = AtlasUrl("marriage", is_man ? "uijh_021b" : "uijh_021a")
            this._img_sex_mate.skin = AtlasUrl("marriage", is_man ? "uijh_021a" : "uijh_021b")

			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
            let weapon_model_id = Util.GetWeaponClotheId(role_vo)
            let wing_id = Util.GetWingClotheId(role_vo)
            let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
            let back_ornament_id = Util.GetBackOrnamentId(role_vo)
            let liveness_id = Util.GetLivenessId(role_vo)

            let data = {
                type: UI_MODEL_TYPE.MAINROLE,
                scale: 1,

                career: role_vo.career,
                sex: role_vo.sex,
                clothe_res_id: model_id,
                fashion_model_id: model_id,
                texture_id: texture_id,

                weapon_res_id: weapon_model_id,
                weapon_clothe_id: 0,
                
                wing_id: wing_id,

                head_wear_id: head_id,
                head_clothe_id: head_texture_id,
                back_ornament_id: back_ornament_id,
                // liveness_id: liveness_id
            }
            ResManager.GetInstance().SetRoleModel(this, this._group_um_self, data)
        }

        this.SetMateData = (mate_info) => {
            let role_vo = role_mgr.GetMainRoleVo()
            let is_man = role_vo.sex == 1
            let married = !!mate_info.role_id
            this._lb_name_mate.text = married ? mate_info.name : "没有伴侣"
            if (!married) {
                if (_um_mate_) {
                    _um_mate_.DeleteMe()
                    _um_mate_ = undefined
                }
                let path = is_man ? "uijh_024b" : "uijh_024a"
                res_mgr.SetTexture(this, this._img_mate, `resource/game/marriage/texture/${path}.png`)
            } else {

                if (_um_mate_) return
                
                let [model_id, texture_id] = Util.GetRoleClotheId(mate_info)
                let weapon_model_id = Util.GetWeaponClotheId(mate_info)
                let wing_id = Util.GetWingClotheId(mate_info)
                let [head_id, head_texture_id] = Util.GetRoleHeadId(mate_info)
                let back_ornament_id = Util.GetBackOrnamentId(mate_info)
                let liveness_id = Util.GetLivenessId(mate_info)

                let data = {
                    type: UI_MODEL_TYPE.ROLE,
                    career: mate_info.career,
                    scale: 1,
                    sex: mate_info.sex,
                    
                    clothe_res_id: model_id,
                    fashion_model_id: model_id,
                    texture_id: texture_id,

                    head_wear_id: head_id,
                    head_clothe_id: head_texture_id,

                    weapon_res_id: weapon_model_id,
                    weapon_clothe_id: 0,

                    wing_id: wing_id,

                    back_ornament_id: back_ornament_id,
                    // liveness_id: liveness_id
                }
                ResManager.GetInstance().SetRoleModel(this, this._group_um_mate, data)
            }
        }

        this.SetDataVisible = (married) => {
            this._btn_break.visible = married
            this._btn_flower.visible = false
            this._btn_banquet.visible = married
            this._btn_flow.visible = !married
            this._group_shadow.visible = !married
            this._group_um_mate.visible = married
            this._group_day.visible = married
            this._btn_ask.visible = !married
            this._btn_again.visible = married
        }
    }


bg_img:Laya.Image
_group_um_self:Laya.Box
_group_um_mate:Laya.Box
_box_info:Laya.Box
_group_shadow:Laya.Box
_img_mate:Laya.Image
_btn_find:Laya.Box
_Image1:Laya.Image
_Label1:Laya.Label
_btn_flower:Laya.Image
_btn_flow:Laya.Image
_btn_banquet:Laya.Image
group1:Laya.Box
img1:Laya.Image
group2:Laya.Box
_img_sex_self:Laya.Image
_lb_name_self:Laya.Label
group3:Laya.Box
img3:Laya.Image
group4:Laya.Box
_img_sex_mate:Laya.Image
_lb_name_mate:Laya.Label
_btn_break:Laya.Image
_btn_dsgt:Laya.Box
img4:Laya.Image
label4:Laya.Label
_btn_ask:Laya.Box
img5:Laya.Image
label5:Laya.Label
_btn_again:Laya.Box
img6:Laya.Image
label6:Laya.Label
_lb_time_self:Laya.Label
_lb_time_mate:Laya.Label
_group_day:Laya.Box
group6:Laya.HBox
label7:Laya.Label
_lb_intimacy:Laya.Label
group7:Laya.HBox
_Label2:Laya.Label
_lb_day:Laya.Label
banqRed:Laya.Image
public GetComponents() {
[
this.bg_img,
this._group_um_self,
this._group_um_mate,
this._box_info,
this._group_shadow,
this._img_mate,
this._btn_find,
this._Image1,
this._Label1,
this._btn_flower,
this._btn_flow,
this._btn_banquet,
this.group1,
this.img1,
this.group2,
this._img_sex_self,
this._lb_name_self,
this.group3,
this.img3,
this.group4,
this._img_sex_mate,
this._lb_name_mate,
this._btn_break,
this._btn_dsgt,
this.img4,
this.label4,
this._btn_ask,
this.img5,
this.label5,
this._btn_again,
this.img6,
this.label6,
this._lb_time_self,
this._lb_time_mate,
this._group_day,
this.group6,
this.label7,
this._lb_intimacy,
this.group7,
this._Label2,
this._lb_day,
this.banqRed,
]
 = this.GetChildrenByNames([

"bg_img",
"_group_um_self",
"_group_um_mate",
"_box_info",
"_group_shadow",
"_img_mate",
"_btn_find",
"_Image1",
"_Label1",
"_btn_flower",
"_btn_flow",
"_btn_banquet",
"group1",
"img1",
"group2",
"_img_sex_self",
"_lb_name_self",
"group3",
"img3",
"group4",
"_img_sex_mate",
"_lb_name_mate",
"_btn_break",
"_btn_dsgt",
"img4",
"label4",
"_btn_ask",
"img5",
"label5",
"_btn_again",
"img6",
"label6",
"_lb_time_self",
"_lb_time_mate",
"_group_day",
"group6",
"label7",
"_lb_intimacy",
"group7",
"_Label2",
"_lb_day",
"banqRed",
])
}
}
 window["MarriageMainView"]= MarriageMainView