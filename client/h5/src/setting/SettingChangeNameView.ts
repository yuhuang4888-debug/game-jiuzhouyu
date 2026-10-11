import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SettingModel } from "../commonModel/SettingModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim } from "../util/Util"

export class SettingChangeNameView extends BaseView1 {
    _Image11: Laya.Image
    _Group1: Laya.Box
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Group2: Laya.Box
    _img_uixt_011: Laya.Image
    input: Laya.Box
    _Image1: Laya.Image
    _Rect1: Laya.Box
    InptextDisplay: Laya.TextInput
    Text: Laya.Label
    default: Laya.Label
    _Group3: Laya.HBox
    cancleBtn: Laya.Box
    _Image5: Laya.Image
    _Label1: Laya.Label
    confirmBtn: Laya.Box
    _Image6: Laya.Image
    _Label2: Laya.Label
    free_label: Laya.Label
    cost_conta: Laya.HBox
    _lb_cost: Laya.Label
    icon1: Laya.Box
    cost1: Laya.HTMLDivElement
    extra: Laya.Label
    icon2: Laya.Box
    cost2: Laya.HTMLDivElement
    _close_btn: Laya.Image
    InitEvent

    LoadSuccess
    Local_Open
    SendProtocal

    UpdateView
    click_bg_toClose

    destroy_callback
    destroy_imm

    is_center
    open_callback
    preload_server_config
    show_open_movie
    textDisplay
    use_background

    public constructor() {
        super()

        this.base_file = "setting"
        this.layout_file = "SettingChangeNameView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        let model = SettingModel.GetInstance()
        let platform_mgr = PlatformManager.GetInstance()
        let role_mgr = RoleManager.GetInstance()

        let local_Util = Util
        let global_event_sys = GlobalEventSystem
        let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
        let local_Message = Message
        let data_ = null
        let is_free_ = 2
        let config_change_name_ = null
        let ticket_item_ = null
        let diamond_item_ = null
        let ticket_enough_ = null
        let diamond_enough_ = null
        this.preload_client_config = {
            "ConfigNotNormalGoods": false
        }
        this.preload_server_config = {
            "config_change_name": false
        }
        this.load_callback = () => {
            this.LoadSuccess()

            this.InitEvent()
        }

        this.open_callback = () => {
            this.UpdateView()
        }

        this.destroy_callback = () => {
            if (ticket_item_) {
                ticket_item_.DeleteMe()
                ticket_item_ = null
            }
            if (diamond_item_) {
                diamond_item_.DeleteMe()
                diamond_item_ = null
            }
            config_change_name_ = null
        }

        //this.preload_server_config = [config_change_name = false]
        this.LoadSuccess = () => {
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("common2", "uitc_001"))
            config_change_name_ = ResManager.GetInstance().GetGameConfigFromCache(this, "Changename", false)
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this._close_btn, close_fun, this, true)
            Util.AddClickEvent(this.cancleBtn, close_fun, this, true)
            this.BindEvent(global_event_sys, SettingModel.CHANGE_NAME_SUCCESS, close_fun)
            let click_fun = () => {
                //model:Fire(SettingModel.SETTING_REQUEST_PROTO, 42604)
                this.SendProtocal(42604)
            }

            Util.AddClickEvent(this.confirmBtn, click_fun, this, true)
            let call_fun = (scmd?) => {
                if (scmd.result == 1) {
                    let ok_func = () => {
                        this.SendProtocal(42601)
                    }

                    let str = Util.StrToHTML("是否确定使用<font color='#639c12'>" + scmd.name + "</font>作为你的新名字？")
                    Alert.Show(str, Alert_Type.Two, ok_func, null, "确定", "我再想想")
                }
            }

            let setFocus = () => {
                this.InptextDisplay.focus = false;
            }

            this.BindEvent(global_event_sys, SettingModel.CAN_USE_THIS_NAME, call_fun)
            this.BindEvent(global_event_sys, EventName.SETTING_INPUT_FOCUS, setFocus)
        }

        this.Local_Open = (parms?) => {
            is_free_ = parms
            super.Open()
        }

        this.UpdateView = () => {
            ResManager.GetInstance().LoadGameConfig(this, "config_change_name", false, null, (cfg) => {
                config_change_name_ = cfg
                this.free_label.visible = is_free_ == 1
                this.cost_conta.visible = is_free_ != 1
                let type_id = config_change_name_[2].value
                let diamond_num = config_change_name_[3].value
                if (!ticket_item_) {
                    ticket_item_ = new BaseAwardItem(this.icon1)
                    ticket_item_.Load()
                    ticket_item_.SetItemSize(40, 40)
                    ticket_item_.SetItembgVisible(false)
                }
                ticket_item_.SetData(type_id)
                let myhave = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
                let color_str = local_Enum_ColorUtil_Dark.GREEN
                ticket_enough_ = true
                if (myhave <= 0) {
                    ticket_enough_ = false
                    color_str = local_Enum_ColorUtil_Dark.RED
                }
                this.cost1.innerHTML = Util.StrToHTML("<font color=" + color_str + ">x1</font>")
                if (!diamond_item_) {
                    diamond_item_ = new BaseAwardItem(this.icon2)
                    diamond_item_.Load()
                    diamond_item_.SetItemSize(40, 40)
                    diamond_item_.SetItembgVisible(false)
                }
                diamond_item_.SetData(this.preload_client_config["ConfigNotNormalGoods"][1].goods_id)
                let color_str2 = local_Enum_ColorUtil_Dark.GREEN
                diamond_enough_ = true
                if (Number(diamond_num) > RoleManager.GetInstance().mainRoleInfo.jin) {
                    diamond_enough_ = false
                    color_str2 = local_Enum_ColorUtil_Dark.RED
                }
                this.cost2.innerHTML = Util.StrToHTML("<font color=" + color_str2 + ">" + diamond_num + "</font>")
                // LayoutRebuilder(this.cost_conta)
                ResManager.GetInstance().DestoryGameConfig(this, "config_change_name")
            })

        }

        this.SendProtocal = (_protocal?) => {
            let name = Trim(this.InptextDisplay.text)
            if (name == "") {
                local_Message.show("名字为空")
                return
            }
            // let filter = LanguageFilter.NameFilter(name)
            // if (!filter) {
            //     Message.show("内容有敏感词")
            //     return
            // }
            let call_func = (is_filter) => {
                if (is_filter) {
                    local_Message.show("内容有敏感词")
                    return
                }
                if (is_free_ == 1) {
                    GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, _protocal, "si", name, 1)
                    return
                }
                if (!ticket_enough_ && !diamond_enough_) {
                    if (!ticket_enough_) {
                        local_Message.show("改名卡不足")
                        return
                    }
                    if (!diamond_enough_) {
                        local_Message.show("勾玉不足")
                    }
                    return
                }
                if (ticket_enough_) {
                    GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, _protocal, "si", name, 3)
                    return
                }
                if (diamond_enough_) {
                    GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, _protocal, "si", name, 2)
                    return
                }
            }
            local_Util.HasFilterWord(name, null, call_func, 1)
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }


    public GetComponents() {
        [
            this._Image11,
            this._Group1,
            this._Image2,
            this._Image3,
            this._Image4,
            this._Group2,
            this._img_uixt_011,
            this.input,
            this._Image1,
            this._Rect1,
            this.InptextDisplay,
            this.Text,
            this.default,
            this._Group3,
            this.cancleBtn,
            this._Image5,
            this._Label1,
            this.confirmBtn,
            this._Image6,
            this._Label2,
            this.free_label,
            this.cost_conta,
            this._lb_cost,
            this.icon1,
            this.cost1,
            this.extra,
            this.icon2,
            this.cost2,
            this._close_btn,
        ]
            = this.GetChildrenByNames([

                "_Image11",
                "_Group1",
                "_Image2",
                "_Image3",
                "_Image4",
                "_Group2",
                "_img_uixt_011",
                "input",
                "_Image1",
                "_Rect1",
                "InptextDisplay",
                "Text",
                "default",
                "_Group3",
                "cancleBtn",
                "_Image5",
                "_Label1",
                "confirmBtn",
                "_Image6",
                "_Label2",
                "free_label",
                "cost_conta",
                "_lb_cost",
                "icon1",
                "cost1",
                "extra",
                "icon2",
                "cost2",
                "_close_btn",
            ])
        this.cost1.style.fontSize = 22
        this.cost1.style.color = "#d15e00"
        this.cost2.style.fontSize = 22
        this.cost2.style.color = "#d15e00"
    }
}
window["SettingChangeNameView"] = SettingChangeNameView