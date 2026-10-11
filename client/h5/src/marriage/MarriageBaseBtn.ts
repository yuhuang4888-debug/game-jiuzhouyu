import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

export class MarriageBaseBtn extends BaseItem1 {

    needRefresh
    data
    index = 0
    select_cache
    model
    dot_cache
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage"
        this.layout_file = "MarriageBaseBtn"
        this.model = MarriageModel.GetInstance()
        this.load_callback = () => {
            if (PlatformManager.IsEyouEnPlatform()) {
                this.tab_name.centerX = -3
                this.tab_name.width = 81
                this.tab_name.height = 22
                this.tab_name.fontSize = 18
                this.tab_name.align = "center"
            }else  if (PlatformManager.IsEyouThPlatform()) {
                this.tab_name.centerX = -3
                this.tab_name.width = 81
                this.tab_name.height = 22
                this.tab_name.fontSize = 20
                this.tab_name.align = "center"
            }
            this.LoadSuccess()
            this.InitEvents()
        }
    }

    public DeleteMe() {

        super.DeleteMe()
    }

    public LoadSuccess() {
        if (this.needRefresh) {
            this.SetData(this.data, this.index)
            this.needRefresh = null
        }
        if (this.select_cache != undefined) {
            this.SetSelect(this.select_cache)
            this.select_cache = undefined
        }
        if (this.dot_cache != undefined) {
            this.SetRedDot(this.dot_cache)
            this.dot_cache = undefined
        }
    }

    public InitEvents() {
        Util.AddClickEvent(this.con, () => {
            let is_select = this._img_bg2.visible
            if (is_select){
                return
            }
            let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
            if (role_lv < this.data.open_lv) {
                Message.show("该功能" + this.data.open_lv + "级开启")
                return
            }

            this.SetSelect(!is_select)
        }, this, true)

        let click_fun = (index) => {
            if (this.index != undefined && this.index != index) {
                this.SetSelect(false)
            }
        }
        this.BindEvent(this.model, MarriageEvent.TAB_BTN_CLICK, click_fun)
    }


    public SetData(data, index) {
        this.data = data
        this.index = index
        if (this.is_loaded) {
            this.tab_name.text = data.label
            this.SetSelect(false)

        } else {
            this.needRefresh = true
        }
    }

    public SetSelect(bool, force?) {
        if (this.is_loaded) {
            if ((this._img_bg2.visible == false && bool) || force) {
                this._img_bg2.visible = bool
                this.model.Fire(MarriageEvent.TAB_BTN_CLICK, this.index)
            } else {
                this._img_bg2.visible = bool
            }
            let is_select = this._img_bg2.visible == true
            this.tab_name.color = is_select ? "#3f0000" : "#532926"
            this.tab_name.strokeColor = is_select ? "#ffffff" : "#ffdcd7"
        } else {
            this.select_cache = bool
        }
    }

    public SetRedDot(bool) {
        if (this.is_loaded) {
            this._reddot.visible = bool
        } else {
            this.dot_cache = bool
        }
    }

    con: Laya.Box
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_name: Laya.Image
    tab_name: Laya.Label
    _reddot: Laya.Image
    public GetComponents() {
        [
            this.con,
            this._img_bg,
            this._img_bg2,
            this._img_name,
            this.tab_name,
            this._reddot,
        ]
            = this.GetChildrenByNames([

                "con",
                "_img_bg",
                "_img_bg2",
                "_img_name",
                "tab_name",
                "_reddot",
            ])
    }
}
window["MarriageBaseBtn"] = MarriageBaseBtn