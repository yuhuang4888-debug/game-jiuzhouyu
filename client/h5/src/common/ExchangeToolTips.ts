import { GoodsModel } from "../commonModel/GoodsModel";
import { GuildModel, GuildEvent } from "../commonModel/GuildModel";
import { Message } from "../sysInfo/SysInfoController";
import { Enum_ColorUtil_Dark, ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { BaseAwardItem } from "./BaseAwardItem";
import { BaseView1 } from "./BaseView1";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { ResManager } from "./ResManager";
import { WordManager } from "./WordManager";

export class ExchangeToolTips extends BaseView1 {


    public static width = 149;
    public static height = 53;

    //function
    InitSubEvent
    FocusOutHandle
    ChangeHandle
    SetCountData
    InitView
    SetScore
    UpdateScore
    UpdateMax
    SetMax
    LoadSuccess
    SetData
    OpenCallback
    public constructor() {
        super()

        let goods_model = GoodsModel.GetInstance(),
            local_Util = Util,
            guild_model = GuildModel.GetInstance(),
            local_Number = Number,
            res_mgr = ResManager.GetInstance(),
            local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark,
            local_Math = Math,
            _def: number,
            _min: number,
            _max: number,
            _score: number,
            _cur_count: number,
            _type_id,
            _pos_x,
            _pos_y,
            _goods_vo,
            _goods_num,
            _goods_icon: BaseAwardItem

        this.base_file = "common";
        this.layout_file = "ExchangeToolTips";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.is_delay_callback = false

        this.load_callback = ()=> {
            this.detail_scroller.vScrollBarSkin = ""
            this.LoadSuccess();
            this.InitSubEvent();
            this.InitView();
        }
        this.open_callback = ()=> {
            this.OpenCallback();
        }
        // this.close_callback = function () {

        // }
        this.destroy_callback = ()=>{
            if (_goods_icon) {
                _goods_icon.DeleteMe();
                _goods_icon = null;
            }
            // if (this._input) {
            //     this._input.removeEventListener(egret.Event.FOCUS_OUT, this.FocusOutHandle, this)
            //     this._input.removeEventListener(egret.Event.CHANGE, this.ChangeHandle, this)
            // }
        }
        this.preload_server_config = {
            "config_equip_attr": false,
            "config_guild_depot_score": false
        }

        this.InitSubEvent = () => {

            local_Util.AddClickEvent(this.exchangeBtn, () => {
                let id = _goods_vo ? _goods_vo.goods_id : 0
                let type_id = _type_id
                let count = _cur_count
                guild_model.Fire(GuildEvent.REQUEST_PROTO, 40103, "lii", id, type_id, count)
            }, this, true);

            local_Util.AddClickEvent(this._btn_sub, () => {
                _cur_count = _cur_count <= _min ? _cur_count : _cur_count - 1
                this._lb_count.text = _cur_count.toString()
                this.UpdateScore(_score * _cur_count)
            }, this, true);

            local_Util.AddClickEvent(this._btn_add, () => {
                _cur_count = _cur_count >= _max ? _cur_count : _cur_count + 1
                this._lb_count.text = _cur_count.toString()
                this.UpdateScore(_score * _cur_count)
            }, this, true);

            local_Util.AddClickEvent(this._btn_max, () => {
                _cur_count = _max
                this._lb_count.text = _cur_count.toString()
                this.UpdateScore(_score * _cur_count)
            }, this, true);

            this.BindVar(guild_model, "depot_score", () => {
                this.UpdateMax()
            })

            // this._input.addEventListener(egret.Event.FOCUS_OUT, this.FocusOutHandle, this)
            // this._input.addEventListener(egret.Event.CHANGE, this.ChangeHandle, this)

            local_Util.AddClickEvent(this._lb_count, () => {
                let pos = [0, -120]
                let change_func = (value) => {
                    if (this.use_delete_method) return
                    _cur_count = value
                    this._lb_count.text = value
                    this.ChangeHandle()
                }
                GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, _max, change_func, pos)
            }, this, true)
        }

        this.FocusOutHandle = () => {

            let num = local_Number(this._lb_count.text)
            if (num < _min) {
                _cur_count = _min
            } else if (num > _max) {
                _cur_count = _max
            }
            this._lb_count.text = _cur_count.toString()
            this.UpdateScore(_score * _cur_count)
        }

        this.ChangeHandle = () => {

            let num = local_Number(this._lb_count.text)
            this.UpdateScore(_score * num)
        }

        this.SetCountData = (def: number, min: number, max: number, score: number) => {
            _def = def
            _min = local_Math.max(min, 1)
            _max = max
            _score = score
        }

        this.InitView = () => {
            this.SetScore()
            _cur_count = _def
            this._lb_count.text = _def.toString()
            // this._input.inputType = egret.TextFieldInputType.TEL;
        }

        this.SetScore = () => {

            if (!_score) {
                let equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)
                let config_guild_depot_score = res_mgr.GetGameConfigFromCache(this, "config_guild_depot_score", false)
                let depot_cfg = guild_model.GetDepotScoreCfgByTypeID(_type_id, equip_attr_cfg, config_guild_depot_score)
                _score = depot_cfg ? depot_cfg.score_cost : 0
            }
            let score = guild_model.GetDepotScore()
            let color = score > _score ? local_Enum_ColorUtil_Dark.WHITE : local_Enum_ColorUtil_Dark.RED

            this._lb_score.color = ColorUtil.GetReplaceChar(color)
            this._lb_score.text = _score + ""

            if (_score <= 0) {
                Message.show("消耗积分不能为0")
                // egret.error("消耗积分不能为0")
            } else {
                this.SetMax()
            }
        }

        this.UpdateScore = (score) => {
            let own_score = guild_model.GetDepotScore()
            let color = own_score > score ? local_Enum_ColorUtil_Dark.WHITE : local_Enum_ColorUtil_Dark.RED
            this._lb_score.color = ColorUtil.GetReplaceChar(color)
            this._lb_score.text = score + ""
        }

        this.UpdateMax = () => {

            this.SetMax()
            _cur_count = _max < _cur_count ? _max : _cur_count
            this._lb_count.text = _cur_count.toString()
            this.UpdateScore(_score * _cur_count)
        }

        this.SetMax = () => {
            let score = guild_model.GetDepotScore()
            _max = local_Math.floor(score / _score)
            _max = local_Math.max(_max, 1)
        }

        this.LoadSuccess = () => {
            // this.detail_scroller.verticalScrollBar.autoVisibility = false;
            // this.detail_scroller.verticalScrollBar.visible = false;
            this.detail_scroller.vScrollBarSkin = ""
        }

        this.SetData = (type_id: number, x?: number, y?: number, goods_vo?: any, goods_num?: number, overdue_time?: number) => {

            _type_id = type_id;
            _goods_vo = goods_vo;
            _pos_x = x
            _pos_y = y
            // _overdue_time = overdue_time || 0
            if (x != undefined && x != undefined) {
                this.is_center = false
            } else {
                this.is_center = true
            }
            _goods_num = goods_num
        }

        this.OpenCallback = () => {

            if (!_type_id) {
                return;
            } else {
                this.PreHtml()
                let basic = goods_model.GetGoodsBasicByTypeId(_type_id);
                if (!basic) {
                    return;
                }
                if (_pos_x != undefined && _pos_y != undefined) {
                    this.display_obj.x = _pos_x
                    this.display_obj.y = _pos_y
                }
                if (!_goods_icon) {
                    _goods_icon = new BaseAwardItem(this.item_group);
                    _goods_icon.Load();
                    _goods_icon.SetItemSize(92, 92)
                    _goods_icon.ChangeCountVisible(false);
                }
                _goods_icon.SetData(basic.type_id, 1);
                _goods_icon.SetShowTips(false)
                let color_str = ColorUtil.GetColorDark(basic.color)

                this.goods_name.color = ColorUtil.GetReplaceChar(color_str)
                this.goods_name.text = (basic.goods_name).trim()
                //this.goods_name.textFlow = local_Util.StrToHTML(`<font color=${color_str}>${(basic.goods_name).trim()}</font>`);
                let style = WordManager.GetGoodsStyle(local_Number(basic.type))

                
                this.type_text.innerHTML =Util.StrToHTML("类型:" + Util.HtmlColorTxt(style, "'#4a3a32'"))// local_Util.StrToHTML(`类型:<font color=\`#4a3a32\`>${style}</font>`);
                let num = (_goods_vo ? (_goods_vo.goods_num ? _goods_vo.goods_num : 1) : 1)
                if (_goods_num) {
                    num = _goods_num
                }
                this.quantity_text.innerHTML = Util.StrToHTML("数量:" + Util.HtmlColorTxt(num, "'#4a3a32'"))//local_Util.StrToHTML(`数量:<font color=\`#4a3a32\`>${num}</font>`);

                this.intro.innerHTML = local_Util.StrToHTML(((basic.intro).trim() != "") ? ((basic.intro).trim()) : "");
                this.tips.visible = false
                //this.tips.includeInLayout = false
                this.intro.height = this.intro.contextHeight

                //物品来源
                let show_source = (basic.source).trim() != ""
                this.line1.visible = show_source
                //this.line1.includeInLayout = show_source
                this.source_txt.visible = show_source
                this.source_txt.innerHTML = local_Util.StrToHTML(show_source ? ((basic.source).trim()) : "");
                this.source_txt.height = this.source_txt.contextHeight
                // this.source_txt.includeInLayout = show_source
                this.source_label.visible = show_source
                // this.source_label.includeInLayout = show_source

                //使用说明文本段
                let show_use_ways = (basic.getway).trim() != ""
                this.line2.visible = show_use_ways
                //this.line2.includeInLayout = show_use_ways
                this.ways.visible = show_use_ways
                this.ways.innerHTML = local_Util.StrToHTML(show_use_ways ? ((basic.getway).trim()) : "");
                this.ways.height = this.ways.contextHeight
                //this.ways.includeInLayout = show_use_ways
                this.label2.visible = show_use_ways
                //this.label2.includeInLayout = show_use_ways
            }
        }
    }


    PreHtml() {
        this.type_text.style.color = "#783528"
        this.type_text.style.fontSize = 20
        this.type_text.style.wordWrap = false
        this.type_text.width = 200


        this.quantity_text.style.color = "#783528"
        this.quantity_text.style.fontSize = 20
        this.quantity_text.style.wordWrap = false
        this.quantity_text.width = 200


        this.source_label.style.color = "#783528"
        this.source_label.style.fontSize = 22
        this.source_label.style.wordWrap = false
        this.source_label.width = 200


        this.source_txt.style.color = "#4a3a32"
        this.source_txt.style.fontSize = 20
        this.source_txt.style.wordWrap = false
        this.source_txt.width = 367
        this.source_txt.style.align="left"
        this.source_txt.style.leading=12


        this.intro.style.color = "#4a3a32"
        this.intro.style.fontSize = 20
        this.intro.style.wordWrap = true
        this.intro.width = 367
        this.intro.style.align="left"
        this.intro.style.leading=12

        this.ways.style.color = "#4a3a32"
        this.ways.style.fontSize = 20
        this.ways.style.wordWrap = true
        this.ways.width = 367
        this.ways.style.align="left"
        this.ways.style.valign="middle"
        this.ways.style.leading=12
    }

    public DeleteMe() {
        super.DeleteMe()
    }



    bg: Laya.Image
    item_group: Laya.Box
    _Image1_title: Laya.Image
    goods_name: Laya.Label
    type_text: Laya.HTMLDivElement
    quantity_text: Laya.HTMLDivElement
    _Image2: Laya.Image
    detail_scroller: Laya.Panel
    detail_group: Laya.VBox
    label1: Laya.Label
    intro: Laya.HTMLDivElement
    tips: Laya.Label
    line1: Laya.Box
    _Image3: Laya.Image
    source_label: Laya.HTMLDivElement
    source_txt: Laya.HTMLDivElement
    line2: Laya.Box
    _Image4: Laya.Image
    label2: Laya.Label
    ways: Laya.HTMLDivElement
    btn_group: Laya.Box
    exchangeBtn: Laya.Box
    _Image1_btn: Laya.Image
    labelDisplay: Laya.Label
    _Group2: Laya.Box
    _Image5: Laya.Image
    _Group1: Laya.HBox
    _Label1: Laya.Label
    _lb_score: Laya.Label
    _btn_sub: Laya.Box
    _Image1_j: Laya.Image
    _btn_add: Laya.Box
    _Image1_s: Laya.Image
    _btn_max: Laya.Box
    _Image1_max: Laya.Image
    _Image6: Laya.Image
    _lb_count: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.item_group,
            this._Image1_title,
            this.goods_name,
            this.type_text,
            this.quantity_text,
            this._Image2,
            this.detail_scroller,
            this.detail_group,
            this.label1,
            this.intro,
            this.tips,
            this.line1,
            this._Image3,
            this.source_label,
            this.source_txt,
            this.line2,
            this._Image4,
            this.label2,
            this.ways,
            this.btn_group,
            this.exchangeBtn,
            this._Image1_btn,
            this.labelDisplay,
            this._Group2,
            this._Image5,
            this._Group1,
            this._Label1,
            this._lb_score,
            this._btn_sub,
            this._Image1_j,
            this._btn_add,
            this._Image1_s,
            this._btn_max,
            this._Image1_max,
            this._Image6,
            this._lb_count,
        ]
            = this.GetChildrenByNames([

                "bg",
                "item_group",
                "_Image1_title",
                "goods_name",
                "type_text",
                "quantity_text",
                "_Image2",
                "detail_scroller",
                "detail_group",
                "label1",
                "intro",
                "tips",
                "line1",
                "_Image3",
                "source_label",
                "source_txt",
                "line2",
                "_Image4",
                "label2",
                "ways",
                "btn_group",
                "exchangeBtn",
                "_Image1_btn",
                "labelDisplay",
                "_Group2",
                "_Image5",
                "_Group1",
                "_Label1",
                "_lb_score",
                "_btn_sub",
                "_Image1_j",
                "_btn_add",
                "_Image1_s",
                "_btn_max",
                "_Image1_max",
                "_Image6",
                "_lb_count",
            ])
    }
}

window["ExchangeToolTips"] = ExchangeToolTips