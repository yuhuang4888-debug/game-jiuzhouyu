import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { GlobalTimerQuest, Util } from "../util/Util";
import { ClientConfig } from "../util/DeclareGlobalVar";
import { ResManager } from "../common/ResManager";
export class LoginUserAgreementView extends BaseView1 {


    style
    type
    constructor() {
        super()
        this.base_file = "login"
        this.layout_file = "LoginUserAgreementView"
        this.is_center = true
        this.use_background = true
        this.destroy_imm = true
        this.not_show_item_use = true
        this.click_bg_toClose = true
        this.show_open_movie = false
        this.layer_value = Enum_UILayer.Top
        this.load_callback = () => {
            this._panel_content.vScrollBarSkin = ""
        }
        this.open_callback = () => {
            this.InitEvent()
            this.ShowMsg()
        }
    }

    public Open(...params) {
        [this.style, this.type] = params
        super.Open()
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)
    }
    public ShowMsg = async () => {
        let cfg
        if (this.style == 1) {
            cfg = await ResManager.GetInstance().LoadGameConfig(this, "ConfigAgreement1")
        }
        else if (this.style == 2) {
            let config_name = "ConfigAgreement2"
            if (ClientConfig.agreement_name_suffix != undefined && ClientConfig.agreement_name_suffix != "") {
                config_name = "ConfigAgreement2_" + ClientConfig.agreement_name_suffix
            }
            cfg = await ResManager.GetInstance().LoadGameConfig(this, config_name)
        }
        else if (this.style == 3) {
            let config_name = "ConfigAgreement3"
            if (ClientConfig.agreement_name_suffix != undefined && ClientConfig.agreement_name_suffix != "") {
                config_name = "ConfigAgreement3_" + ClientConfig.agreement_name_suffix
            }
            cfg = await ResManager.GetInstance().LoadGameConfig(this, config_name)
        }
        if (this.use_delete_method) return
        if (cfg) {
            let agreement_cfg
            if(this.type == 1 && cfg["agreenment"]){
                agreement_cfg = cfg["agreenment"]
            }
            else if(this.type == 2 && cfg["privacy"])
            {
                agreement_cfg = cfg["privacy"]

            }

            if(!agreement_cfg){
                return
            }
            this._lb_title.text = agreement_cfg["title"]
            let content = agreement_cfg["content"]
            let str = ""
            for (let v of content) {
                str += v + "\n"
            }
            this._lb_content.text = str
        }
    }
    _img_bg: Laya.Image
    _img_close: Laya.Image
    _lb_title: Laya.Label
    _panel_content: Laya.Panel
    _lb_content: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_close,
            this._lb_title,
            this._panel_content,
            this._lb_content,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_close",
                "_lb_title",
                "_panel_content",
                "_lb_content",
            ])
    }
}

window["LoginUserAgreementView"] = LoginUserAgreementView