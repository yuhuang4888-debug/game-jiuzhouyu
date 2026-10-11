import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { LoginModel } from "./LoginModel"
export class LoginCreateRoleItem extends BaseItem1 {


    need_refresh_data = false
    need_refresh_select = false
    select_state = false
    vo
    index
    call_back
    public constructor(parent) {
        super(parent)
        this.base_file = "login"
        this.layout_file = "LoginCreateRoleItem"
        this.load_callback = function () {
            this.InitEvent()
            this.LoadSuccess()
        }
    }

    InitEvent() {
    }
    LoadSuccess() {

        Util.AddClickEvent(this._box_head, () => {
            if (this.call_back)
                this.call_back(this.index, true)
        }, this, true)


        if (this.need_refresh_data) {
            this.UpdateView()
            this.need_refresh_data = false
        }
        else{
            this.UpdateSelectState()
        }
    }

    SetData(index, vo, call_back) {
        this.index = index
        this.vo = vo
        this.call_back = call_back
        if (this.is_loaded) {
            this.UpdateView()
        }
        else
        {
            this.need_refresh_data = true
        }
    }

    UpdateView() {
        if (this.vo) {
            this._lb_career.text = this.vo.name
            this.UpdateSelectState()
        }

        Laya.Tween.clearAll(this._box_head)
        this._box_head.x = LoginModel.ViewTweenData.TabInStartPos
        this._box_head.alpha = LoginModel.ViewTweenData.TabInStartAlpha
        let delay_time = this.index * LoginModel.ViewTweenData.TabInTimeInterval
        setTimeout(() => {
            if(this.use_delete_method) return
            Laya.Tween.to(this._box_head, { x: 0, alpha: 1 }, LoginModel.ViewTweenData.TabInTimeInterval, Laya.Ease.linearNone)
        }, delay_time);

    }

    public SetSelectState(bool) {
        this.select_state = bool
        if (this.is_loaded) {
            this.UpdateSelectState()
        }
        else {
            this.need_refresh_select = true
        }
    }

    public UpdateSelectState(){
        let vo = this.vo
        if(vo)
        {
            if(this.select_state){
                this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_02" )
                this._img_icon.skin = GameResPath.GetIcon("login", vo.select_icon )
                this._lb_career.color = "#fff2c3"
                this._lb_career.strokeColor = "#c35011"
            }
            else{
                this._img_bg.skin = GameResPath.GetIcon("login", "ui_Login_03")
                this._img_icon.skin = GameResPath.GetIcon("login", vo.unselect_icon)
                this._lb_career.color = "#ffffff"
                this._lb_career.strokeColor = "#8f284b"
            }
        }
    }

    public DeleteMe() {
        this.call_back = undefined
        this.select_state = false
        this.need_refresh_data = false
        this.need_refresh_select = false
        if(this._box_head){
            Laya.Tween.clearAll(this._box_head)
        }
        super.DeleteMe()
    }

    _box_head: Laya.Box
    _img_bg: Laya.Image
    _img_icon: Laya.Image
    _lb_career: Laya.Label
    public GetComponents() {
        [
            this._box_head,
            this._img_bg,
            this._img_icon,
            this._lb_career,
        ]
            = this.GetChildrenByNames([

                "_box_head",
                "_img_bg",
                "_img_icon",
                "_lb_career",
            ])
            this._lb_career.fontSize = 2 * this._lb_career.fontSize
            this._lb_career.scale(0.5, 0.5)
    }
}
window["LoginCreateRoleItem"] = LoginCreateRoleItem