import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { LoginStateEvent } from "../common/EventName"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoginManager } from "./LoginManager"
import { LoginModel } from "./LoginModel"
import { LoginSelectRoleView } from "./LoginSelectRoleView"

export class LoginSelectRoleItem extends BaseItem1 {

    model: LoginModel
    select_state = false
    data
    index

    role_head: CustomHeadItem

    need_refresh_data
    need_refresh_select_state

    public constructor(parent) {
        super(parent)
        this.base_file = "login"
        this.layout_file = "LoginSelectRoleItem"
        this.is_delay_callback = true
        this.model = LoginModel.GetInstance()
        this.load_callback = function () {
            this.LoadSuccess()
        }
    }
    public LoadSuccess() {
        this.display_obj.visible = false
        this.role_head = new CustomHeadItem(this._box_con)
        this.role_head.SetActiveFrame(false)
        this.role_head.SetActiveLevel(false)
        this.role_head.SetActiveBg(false)
        this.role_head.CloseClick()
        this.role_head.SetScale(1.19)
        this.role_head.SetPosition(-0.5, -0.5)
        this.role_head.Load()


        Util.AddClickEvent(this._box_con, () => {
            if (this.data) {
                if (this.data.none) {
                    LoginManager.GetInstance().Fire(LoginStateEvent.CLOSE_VIEW, "LoginSelectRoleView")
                    LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginCreateRoleView")
                } else {
                    this.model.Fire(LoginSelectRoleView.SELECT_ROLE_ITEM, this.index)
                }
            }
        }, this, true)

        if (this.need_refresh_data) {
            this.UpdateItem()
            this.need_refresh_data = false
        }

        if (this.need_refresh_select_state) {
            this.UpdateState()
            this.need_refresh_select_state = false
        }
    }

    public SetData(data, index) {
        this.data = data
        this.index = index
        if (this.is_loaded) {
            this.UpdateItem()
        }
        else {
            this.need_refresh_data = true
        }
    }

    public UpdateItem() {
        let data = this.data
        if (data) {
            if (data.none) {
                this._img_bg2.visible = false
                this.role_head.SetVisible(false)
                this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_04")
                this._hbox_lv.visible = false
            } else {
                this._hbox_lv.visible = true
                this._img_bg2.visible = true

 		if (PlatformManager.IsEyouThPlatform()) {
                   	 this._lb_turn.text = `จุติ ${data.turn}`
                    	let is_sc = data.level > 370
                    	this._img_sc.visible = is_sc
                    	this._img_sc.width = is_sc ? 35 : 1
                   	this._lb_lv.text = `Lv.${is_sc ? data.level - 370 : data.level}`
                }else{
                this._lb_turn.text = `${data.turn}转`
                let is_sc = data.level > 370
                this._img_sc.visible = is_sc
                this._img_sc.width = is_sc ? 35 : 1
                this._lb_lv.text = `${is_sc ? data.level - 370 : data.level}级`
		}
                
                this._lb_name.text = data.name
                this.role_head.SetVisible(true)
                this.role_head.SetRoleVoData(data)
            }
        }

        this.display_obj.visible = true

        if(this.index < 4){
            Laya.Tween.clearAll(this._box_con)
            this._box_con.x = LoginModel.ViewTweenData.TabInStartPos
            this._box_con.alpha = LoginModel.ViewTweenData.TabInStartAlpha
            let delay_time = this.index * LoginModel.ViewTweenData.TabInTimeInterval
            setTimeout(() => {
                if(this.use_delete_method) return
                Laya.Tween.to(this._box_con, { x: 0, alpha: 1 }, LoginModel.ViewTweenData.TabInTimeInterval, Laya.Ease.linearNone)
            }, delay_time);
        }
    }

    public SetSelectState(bool) {
        this.select_state = bool
        if (this.is_loaded) {
            this.UpdateState()
        } else {
            this.need_refresh_select_state = true
        }
    }

    public UpdateState() {
        if (this.select_state) {
            this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_02")
            this._img_bg2.skin = GameResPath.GetIcon("login", "ui_Login_05")

            this._lb_name.color = this._lb_lv.color = "#fff8f2"
            this._lb_name.strokeColor = this._lb_lv.strokeColor = "#8f284b"
        }
        else {
            this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_03")
            this._img_bg2.skin = GameResPath.GetIcon("login", "ui_Login_06")

            this._lb_name.color = this._lb_lv.color = "#fff8f2"
            this._lb_name.strokeColor = this._lb_lv.strokeColor = "#541f31"
        }
    }

    DeleteMe() {
        if (this.role_head) {
            this.role_head.DeleteMe()
            this.role_head = null
        }

        if(this._box_con){
            Laya.Tween.clearAll(this._box_con)
        }
        super.DeleteMe()
    }




    _box_con: Laya.Box
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _lb_name: Laya.Label
    _hbox_lv: Laya.HBox
    _lb_turn: Laya.Label
    _img_sc: Laya.Image
    _lb_lv: Laya.Label
    public GetComponents() {
        [
            this._box_con,
            this._img_bg,
            this._img_bg2,
            this._lb_name,
            this._hbox_lv,
            this._lb_turn,
            this._img_sc,
            this._lb_lv,
        ]
            = this.GetChildrenByNames([

                "_box_con",
                "_img_bg",
                "_img_bg2",
                "_lb_name",
                "_hbox_lv",
                "_lb_turn",
                "_img_sc",
                "_lb_lv",
            ])
            this._lb_name.fontSize = 2 * this._lb_name.fontSize
            this._lb_name.scale(0.5, 0.5)
            this._lb_turn.fontSize = 2 * this._lb_turn.fontSize
            this._lb_turn.scale(0.5, 0.5)
            this._lb_lv.fontSize = 2 * this._lb_lv.fontSize
            this._lb_lv.scale(0.5, 0.5)
    }
}
window["LoginSelectRoleItem"] = LoginSelectRoleItem