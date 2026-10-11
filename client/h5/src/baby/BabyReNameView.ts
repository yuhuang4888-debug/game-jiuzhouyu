import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { Trim, Util } from "../util/Util"

export class BabyReNameView extends BaseView1 {
    language_cfg
    model = BabyModel.GetInstance()
    costItem: BaseAwardItem
    InitView
    Check
    LimitFun
    public constructor() {
        super()
        this.base_file = "setting"
        this.layout_file = "SettingChangeNameView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.destroy_imm = true
        let plat_mgr = PlatformManager.GetInstance()
        let local_Util = Util
        let res_mgr = ResManager.GetInstance()
        let goods_model = GoodsModel.GetInstance()
        let local_Message = Message
        this.preload_client_config = { "ConfigLanguageMask": false }
        this.language_cfg = "ConfigLanguageMask"
        this.preload_server_config = {
            "config_baby_value": false
        }

        this.load_callback = function () {
            this.InitView()
        }

        this.destroy_callback = function () {
            this.InptextDisplay.off(Laya.Event.INPUT, this, this.LimitFun)
        }

        

        
        this.InitView = () => {
            // this._title_lb0.text = `宝宝改名`
            this.InptextDisplay.maxChars = 12

            this.InptextDisplay.on(Laya.Event.INPUT, this, this.LimitFun);

            local_Util.AddClickEvent(this._close_btn, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this.cancleBtn, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this.confirmBtn, () => {
                this.Check()
                
            }, this, true)
            if (this.model.changedName) {
                this.free_label.visible = false
                this.cost_conta.visible = true
                this.extra.visible = false
                this.icon2.visible = false
                this.cost2.visible = false
                let baby_cfg = res_mgr.GetGameConfigFromCache(this, "config_baby_value", false)
                let cost = baby_cfg[7].value
                if (cost) {
                    cost = JSON.parse(cost)
                    if (cost.length > 0) {
                        this.costItem = new BaseAwardItem(this.icon1)
                        this.costItem.Load()
                        this.costItem.SetItemSize(40, 40)
                        let goodsInfo = goods_model.GetMappingTypeId(cost[0][0], cost[0][1])
                        let goodsBasic = goods_model.GetGoodsBasicByTypeId(goodsInfo[0])
                        if (goodsBasic) {
                            this.costItem.SetData(goodsBasic.type_id)
                            this.costItem.SetItembgVisible(false)
                        }
                        this.cost1.innerHTML = `X${cost[0][2]}`
                        // this.extra.includeInLayout = this.free_label.includeInLayout = this.cost2.includeInLayout = this.extra.visible = this.free_label.visible = this.cost2.visible = false
                    }
                }
            } else {
                this.free_label.visible = true
                this.cost_conta.visible = false
            }
        }

        this.LimitFun = () => {
            if (this.InptextDisplay.text.length >= 12) {
                Message.show(`名字不能超过12个字符`)
            }
        }

        this.Check = () => {
            let name = Trim(this.InptextDisplay.text)
            if (name == "") {
                local_Message.show("名字为空");
                return;
            }
            let language_cfg = res_mgr.GetGameConfigFromCache(this, this.language_cfg, true)
            let filter_callback = (is_filter) =>
            {
                if (is_filter) {
                    local_Message.show("内容有敏感词")
                    return
                }
                let len = 0
                for (let i = 0; i < name.length; i++) {
                    var c = name.charCodeAt(i)
                    //单字节加1   
                    if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
                        len++
                    }
                    else {
                        len += 2
                    }
                }
                if (len < 4 || len > 12) {
                    Message.show("角色名称长度为4～12个字符")
                    return
                }
                this.model.Fire(BabyEvent.REQUEST_PROTO, 18215, "s", name)
                this.Close()
            }
            local_Util.HasFilterWord(name, language_cfg, filter_callback, 1)
        }
    }

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
window["BabyReNameView"] = BabyReNameView