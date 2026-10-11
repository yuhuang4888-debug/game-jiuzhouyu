import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GodBeastDefine, GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util";

export class GodBeastTipsView extends BaseView1 {

    Clear
    InitEvent
    UpdateView
    GetOpenPosCost
    delay_id
    public constructor() {
        super()
        let _model = GodBeastModel.GetInstance(),
            local_Util = Util,
            goods_model = GoodsModel.GetInstance(),
            local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark,
            local_Number = Number,
            _item_: BaseAwardItem

        this.base_file = "godBeast"
        this.layout_file = "GodBeastTipsView"
        this.layer_value = Enum_UILayer.UI;
        this.layer_value = Enum_UILayer.Activity;
        this.click_bg_toClose = true
        this.use_background = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true

        this.load_callback = function () {
            SetHtmlStyle(this.lv_txt, { c: "#663519", f: 20, w: 530, ww: false })
            this.InitEvent()
            this.UpdateView()
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        this.preload_server_config = {
            "config_eudemons_cfg": false
        }
        this.Clear = () => {
            if (_item_) {
                _item_.DeleteMe()
                _item_ = undefined
            }
            if (this.delay_id) {
                clearTimeout(this.delay_id)
                this.delay_id = null
            }
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_cancel, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_ok, () => {
                _model.Fire(GodBeastEvent.REQUEST_PROTO, 17306)
            }, this, true)
        }

        this.UpdateView = () => {
            let beast_info = _model.GetBeastInfo()
            if (!beast_info) return

            let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_eudemons_cfg", false)
            let extra = beast_info.fight_count - GodBeastDefine.POS_DEF_COUNT + 1
            let cost_cfg = this.GetOpenPosCost(extra, config)
            if (!cost_cfg) return

            if (!_item_) {
                _item_ = new BaseAwardItem(this._group_item)
                _item_.Load()
            }

            let cfg = JSON.parse(cost_cfg)
            let cdata = cfg[0][1][0]
            let [type_id] = goods_model.GetMappingTypeId(cdata[0], cdata[1])
            let basic = goods_model.GetGoodsBasicByTypeId(type_id)
            let own = goods_model.GetTypeGoodsNum(type_id)
            let color = own >= local_Number(cdata[2]) ? local_Enum_ColorUtil_Dark.GREEN : local_Enum_ColorUtil_Dark.RED
            let str = local_Util.HtmlColorTxt(own, color)
            _item_.SetData(type_id)
            _item_.ExcuteCallback(() => {
                _item_.ForceSetNumberInFlow(local_Util.StrToHTML(`${str}/${cdata[2]}`))
            })

            let str1 = local_Util.HtmlColorTxt(basic.goods_name, ColorUtil.GetColorDark(basic.color))
            let str2 = local_Util.HtmlColorTxt("1个", local_Enum_ColorUtil_Dark.GREEN)
            this._lb_tip1.style.color = "#4a3a32"
            this._lb_tip1.style.fontSize = 24
            this._lb_tip1.width = 530
            this._lb_tip1.style.align = "center"
            this._lb_tip1.innerHTML = local_Util.StrToHTML(`消耗${str1}永久增加${str2}助战蜃妖`)
            SetHtmlCenter(this._lb_tip1, { "x": 0, "w": 643 })

            let main_vo_level = RoleManager.GetInstance().mainRoleInfo.level

            let lv_str = ""
            // let need_lv =extra==1? cfg[1][1]:cfg[2][1]
            let need_lv = cfg[2][1];
            if (local_Number(need_lv) <= main_vo_level) {
                let lv = local_Number(need_lv)
                let level = TransformLevel(lv)
                str1 = local_Util.HtmlColorTxt(level, local_Enum_ColorUtil_Dark.GREEN)
                str2 = local_Util.HtmlColorTxt(extra, local_Enum_ColorUtil_Dark.GREEN)

                lv_str = local_Util.StrToHTML(`${str1}级可额外增加第${str2}个蜃妖扩展位`)
            } else {
                if (cfg[2]) {
                    let lv = RoleManager.GetInstance().GetMainRoleVo().level
                    let color = lv >= need_lv ? local_Enum_ColorUtil_Dark.GREEN : local_Enum_ColorUtil_Dark.RED
                    let level = TransformLevel(need_lv)
                    str1 = local_Util.HtmlColorTxt(level, color)
                    lv_str = local_Util.StrToHTML(`${str1}级后方可提升`)
                }
            }

            this.lv_txt.visible = lv_str != ""
            this.lv_txt.innerHTML = lv_str
            SetHtmlCenter(this.lv_txt, { "x": 0, "w": 643 })

        }

        this.GetOpenPosCost = (pos, config) => {
            let cfg = config[`fight_location_cost@${pos}`]
            return cfg && cfg.value
        }
    }


    _Image111: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _btn_cancel: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    _btn_ok: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _btn_close: Laya.Image
    _group_item: Laya.Box
    _lb_tip1: Laya.HTMLDivElement
    _lb_tip2: Laya.HTMLDivElement
    label1: Laya.Label
    lv_txt: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._Image111,
            this._Image2,
            this._Image3,
            this._btn_cancel,
            this._Image1,
            this.labelDisplay1,
            this._btn_ok,
            this._Image11,
            this.labelDisplay,
            this._btn_close,
            this._group_item,
            this._lb_tip1,
            this._lb_tip2,
            this.label1,
            this.lv_txt,
        ]
            = this.GetChildrenByNames([

                "_Image111",
                "_Image2",
                "_Image3",
                "_btn_cancel",
                "_Image1",
                "labelDisplay1",
                "_btn_ok",
                "_Image11",
                "labelDisplay",
                "_btn_close",
                "_group_item",
                "_lb_tip1",
                "_lb_tip2",
                "label1",
                "lv_txt",
            ])
    }
}
window["GodBeastTipsView"] = GodBeastTipsView