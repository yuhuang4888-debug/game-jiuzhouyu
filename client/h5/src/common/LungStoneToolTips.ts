import { GoodsModel } from "../commonModel/GoodsModel";
import { LungModel } from "../commonModel/LungModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { HtmlColorTxt, RefBoxVLayout, SetHtmlStyle, Util } from "../util/Util";
import { BaseAwardItem } from "./BaseAwardItem";
import { BaseView1 } from "./BaseView1";
import { CommonManager } from "./CommonManager";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { OpenFun } from "./OpenFun";
import { ResManager } from "./ResManager";

export class LungStoneToolTips extends BaseView1 {

    closeObj
    protected type_id;
    protected goods_vo;
    protected goods_icon: BaseAwardItem;
    protected model: LungModel;

    LoadSuccess
    InitEvent
    SetData
    InitView
    SetLungInfo
    SourceClickFunc

    init_scroll_height
    SetTipsHeight

    public constructor() {
        super();
        // let local_egret = egret,
        let local_Util = Util,
            goods_model = GoodsModel.GetInstance(),
            local_Message = Message,
            local_ColorUtil = ColorUtil,
            res_mgr = ResManager.GetInstance(),
            common_mgr = CommonManager.GetInstance()

        this.base_file = "common";
        this.layout_file = "LungStoneToolTips";
        this.layer_value = Enum_UILayer.Top;
        this.destroy_imm = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.is_delay_callback = false
        this.model = LungModel.GetInstance();
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();

        }
        this.open_callback = () => {
            this.InitView();
        }
        this.close_callback = () => {
            if (this.goods_icon) {
                this.goods_icon.DeleteMe();
                this.goods_icon = null;
            }
            this.closeObj = undefined
            // this.source_txt.removeEventListener(local_egret.TextEvent.LINK, this.SourceClickFunc, this)
            this.source_txt.off(Laya.Event.LINK, this, this.SourceClickFunc);
            GlobalEventSystem.Fire(EventName.CLOSE_TIPS_VIEW)
        }
        this.destroy_callback = () => {

        }
        this.preload_client_config = {
            "GoodsSourceConfig": false
        }
        this.LoadSuccess = () => {
            this.init_scroll_height = this.detail_scroller.height
            SetHtmlStyle(this.source_txt, { c: "#d15e00", f: 20, w: 300, ww: false, lh: 25 })
            this.detail_scroller.vScrollBar.visible = false
        }


        this.InitEvent = () => {

            let close_fun = () => {
                this.Close();
            }
            local_Util.AddClickEvent(this.okBtn, close_fun, this, true);

            let composeBtn = () => {
                if (this.goods_vo && this.goods_vo.type == LungModel.LungMaterialGoodsType) {
                    let [can_compose, cost_num, id, is_recommend, target_type_id] = this.model.ChipCanComposeDot(this.goods_vo.type_id)
                    if (can_compose) {
                        if (is_recommend) {
                            goods_model.Fire(GoodsModel.EXCHANGE_GOODS, id, 1)
                            this.Close()
                        } else {
                            local_Message.show("已拥有同类型神纹")
                        }
                    } else {
                        local_Message.show("物品不足")
                    }
                }
            }
            local_Util.AddClickEvent(this.composeBtn, composeBtn, this, true)
            // this.source_txt.addEventListener(local_egret.TextEvent.LINK, this.SourceClickFunc, this)

            this.source_txt.on(Laya.Event.LINK, this, this.SourceClickFunc);

        }

        this.SetData = (type_id: number, goods_vo?: any) => {

            this.type_id = type_id;
            this.goods_vo = goods_vo;
        }

        this.InitView = () => {

            if (!this.type_id) {
                return;
            } else {
                let basic = goods_model.GetGoodsBasicByTypeId(this.type_id);
                if (!basic) {
                    return;
                }
                let bg_name = `ui_tips_pz_${basic.color}`
                ResManager.GetInstance().SetImageSprite(this, this._img_title_bg, "common4", bg_name)
                ResManager.GetInstance().SetOutsideImageSprite(this, this._line, GameResPath.GetIcon("common", "com_line_71"))

                if (!this.goods_icon) {
                    this.goods_icon = new BaseAwardItem(this.item_group);
                    this.goods_icon.Load();
                    this.goods_icon.SetItemSize(92, 92)
                    this.goods_icon.ChangeCountVisible(false);
                }
                this.goods_icon.SetData(basic.type_id, 1);
                this.goods_icon.SetShowTips(false)
                // let color_str = local_ColorUtil.GetColorDark(basic.color, false)
                // this.goods_name.color = color_str
                this.goods_name.text = local_Util.StrToHTML(`${(basic.goods_name).trim()}`);

                SetHtmlStyle(this.type_text, { f: 22, c: "#ffffff", w: 380, ww: false })
                this.type_text.innerHTML = local_Util.StrToHTML(`系别：${HtmlColorTxt(this.model.GetSeriesDesc(basic.subtype), "'#ffe222'")}`)
                let num
                if (!this.goods_vo) {
                    num = goods_model.GetTypeGoodsNum(basic.type_id)
                } else {
                    num = this.goods_vo.goods_num ? this.goods_vo.goods_num : 1
                }
                SetHtmlStyle(this.quantity_text, { f: 22, c: "#ffffff", w: 380, ww: false })
                this.quantity_text.innerHTML = local_Util.StrToHTML(`已拥有：${HtmlColorTxt(num, "'#ffe222'")}`);

                //物品来源
                let show_source = ErlangParser.GetInstance().Parse(basic.getway_url.trim())
                let ShowSource = show_source.length > 0
                this.sourceGp.visible = ShowSource
                let Str = ``
                let ClientSourceCfg = res_mgr.GetGameConfigFromCache(this, "GoodsSourceConfig", true)
                let count = 0
                if (ClientSourceCfg) {
                    for (let vo of show_source) {
                        let curCfg = ClientSourceCfg[vo[0]]
                        if (curCfg) {
                            let hasOpen = vo[1] == `1` && common_mgr.CheckFuncOpenState(`${curCfg.view}`, true)
                            Str += `<font color=\"${hasOpen ? '#ff9015' : '#4A3A32'}\"><a href='${vo[0]}@${vo[1]}'>${curCfg.name}</a></font>`

                            if (count % 3 == 2) {
                                Str += "<br>"
                            } else {
                                Str += "&nbsp;&nbsp;"
                            }
                            count++
                        }
                    }

                    this.source_txt.width = 300
                    this.source_txt.innerHTML = local_Util.StrToHTML(ShowSource ? Str.replace(/、$/, "") : "");
                    // if (this.source_txt.contextHeight > this.source_label.height) {
                    //     this.sourceGp.height = this.source_txt.contextHeight + 5
                    // } else {
                    //     this.sourceGp.height = this.source_label.height
                    // }
                }

                let [can_compose, cost_num, id, is_recommend, target_type_id] = this.model.ChipCanComposeDot(basic.type_id)
                this.compose_dot.visible = is_recommend

                this.SetLungInfo(target_type_id, cost_num)

                this.composeBtn.visible = this.goods_vo != undefined
                this.okBtn.visible = this.goods_vo == undefined





                //设置总体的高度
                this.SetTipsHeight()
            }
        }


        this.SetTipsHeight = () => {


			//计算高度
			let contents= [this.detail_scroller,this.sourceGp,this.okBtn,this.composeBtn]
			let base_y = contents[0].y
			let record_y = base_y
			let last_height = contents[0].height //上一个组件的高度 记录
			let gap = 15
			for(let i = 1;i<contents.length;i++){
				if(!contents[i].visible)continue
				let new_y = record_y + last_height + gap
				contents[i].y = new_y
				record_y =new_y 
				last_height = contents[i].height
			}

			let img_bg_height = record_y + last_height + 10
			this._img_bg.height = img_bg_height
			this.display_obj.height = img_bg_height
		}

        this.SetLungInfo = (type_id, cost_num) => {

            let basic = goods_model.GetGoodsBasicByTypeId(type_id)
            if (!basic) {
                return
            }
            let tips = `<font color='#0a953e'>${cost_num}个该碎片可合成</font><font color=${local_ColorUtil.GetColorDark(basic.color)}>${basic.goods_name}</font>`
            this.lung_tips.style.fontSize = 20
            this.lung_tips.width = 314
            this.lung_tips.style.leading = 10
            this.lung_tips.innerHTML = local_Util.StrToHTML(tips)
            this.lung_tips.height = this.lung_tips.contextHeight + 15

            //基础属性
            let str = this.model.GetBasePro(type_id, 1)
            let maxLv = this.model.getMaxLv(type_id);
            let max_str = this.model.GetMaxPro(type_id, maxLv)
            this.base_attr.style.fontSize = 20
            this.base_attr.width = this.detail_scroller.width - 15
            this.base_attr.style.leading = 10
            this.base_attr.style.color = "#663915"
            this.base_attr.innerHTML = local_Util.StrToHTML(str)
            this.max_attr_lb.style.fontSize = 20
            this.max_attr_lb.width = 314
            this.max_attr_lb.style.leading = 10
            this.max_attr_lb.innerHTML = local_Util.StrToHTML(max_str)

            this.base_pro_conta.height = this.base_attr.y + this.base_attr.contextHeight - 15

            let skill_str = this.model.GetSkillStr(type_id, 1)
            this.effect_str.style.fontSize = 20
            this.effect_str.width = this.detail_scroller.width - 25
            this.effect_str.style.leading = 10
            this.effect_str.style.color = "#663915"
            this.effect_str.innerHTML = local_Util.StrToHTML(skill_str)

            this.skill_conta.height = this.effect_str.y + this.effect_str.contextHeight



            //刷新detail_scroller的高度
            RefBoxVLayout(this.detail_box, 10, true, true)
            this.detail_box.y = 2
            if (this.detail_box.height >= this.init_scroll_height) {
                this.detail_scroller.height = this.init_scroll_height
            } else {
                this.detail_scroller.height = this.detail_box.height
            }
        }

        this.SourceClickFunc = (e) => {
            let ClientSourceCfg = res_mgr.GetGameConfigFromCache(this, "GoodsSourceConfig", true)
            if (ClientSourceCfg) {
                let argsList = e.split(`@`)
                let CurCfg: any = argsList[1] == `1` && ClientSourceCfg[argsList[0]]
                if (CurCfg) {
                    if (CurCfg.id == 118 && !this.model.StoveOpenState(true))
                        return
                    if (common_mgr.CheckFuncOpenState(CurCfg.view)) {
                        let findView = (obj) => {
                            if (obj && obj.parent) {
                                if (obj.parent instanceof BaseView1 && typeof (obj.parent.Close) == "function") {
                                    obj.parent.Close()
                                    return
                                } else {
                                    findView(obj.parent)
                                }
                            }
                        }
                        findView(this.closeObj)
                        OpenFun.OpenFunHandler(CurCfg.id)
                        this.Close()
                    }
                }
            }
        }
    }


_img_bg:Laya.Image
_img_title_bg:Laya.Image
item_group:Laya.Box
goods_name:Laya.Label
type_text:Laya.HTMLDivElement
quantity_text:Laya.HTMLDivElement
detail_scroller:Laya.Panel
detail_box:Laya.Box
lung_tips:Laya.HTMLDivElement
base_pro_conta:Laya.Box
base_attr:Laya.HTMLDivElement
max_attr_lb:Laya.HTMLDivElement
skill_conta:Laya.Box
line12:Laya.Image
effect_str:Laya.HTMLDivElement
sourceGp:Laya.Box
_line:Laya.Image
source_label:Laya.Label
source_txt:Laya.HTMLDivElement
okBtn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
composeBtn:Laya.Box
_Image111:Laya.Image
compose_dot:Laya.Image
_Label3:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_title_bg,
this.item_group,
this.goods_name,
this.type_text,
this.quantity_text,
this.detail_scroller,
this.detail_box,
this.lung_tips,
this.base_pro_conta,
this.base_attr,
this.max_attr_lb,
this.skill_conta,
this.line12,
this.effect_str,
this.sourceGp,
this._line,
this.source_label,
this.source_txt,
this.okBtn,
this._Image1,
this.labelDisplay,
this.composeBtn,
this._Image111,
this.compose_dot,
this._Label3,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_title_bg",
"item_group",
"goods_name",
"type_text",
"quantity_text",
"detail_scroller",
"detail_box",
"lung_tips",
"base_pro_conta",
"base_attr",
"max_attr_lb",
"skill_conta",
"line12",
"effect_str",
"sourceGp",
"_line",
"source_label",
"source_txt",
"okBtn",
"_Image1",
"labelDisplay",
"composeBtn",
"_Image111",
"compose_dot",
"_Label3",
])
}
}
 window["LungStoneToolTips"]= LungStoneToolTips