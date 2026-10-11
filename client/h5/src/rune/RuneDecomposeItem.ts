import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { SetHtmlCenter, Util } from "../util/Util";

export class RuneDecomposeItem extends BaseItemRenderer {

    public WIDTH = 198
	public HEIGT = 274

    private _model: RuneModel;
    public constructor() {
        super()
        this.base_file = "rune"
        this.layout_file = "RuneDecomposeItem"
        this._model = RuneModel.GetInstance()
        this.Load()
    }

        public createChildren(){
            super.createChildren()
            
        }

        public InitEvent(){
            Util.AddClickEvent(this._img_click, () => {
                if(!this.data)return
                if (this.data.is_better) {
                    if (this._model.decompose_not_alert || this.data.is_selected) {
                        this.Select(undefined)
                    } else {
                        let str = `当前选中御魂是同种类最高品质，是否继续进行分解？`
                        Alert.Show(str, Alert_Type.AlertTypeCheckBox, () => {
                            this.Select(undefined)
                        }, undefined, "确定", "取消", undefined, false, (bool: boolean) => {
                            this._model.decompose_not_alert = bool
                        }, "本次登录不再提示")
                    }
                }
                else {
                    this.Select(undefined)
                }
            }, this)
        }

        public DeleteMe(){
            super.DeleteMe()
        }

        public dataChanged(){
            if (!super.dataChanged()) return
            let data = this.data
            this._lb_name.text = `${data.goods_name}`
            let color = (data.subtype == 26 || data.subtype == 27) && data.color == 5? 6: data.color
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/runeCard/" + data.type_id + ".png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_kuang, "resource/game/runeCard/icon_kp_0" + color + ".png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_iconbg, "resource/game/runeCard/icon_kpbg_0" + color + ".png")
            ResManager.GetInstance().SetImageSprite(this, this._img_color, "rune", "color_" + color)
            this._lb_attr0.style.fontSize = 20
            this._lb_attr1.style.fontSize = 20
            this._lb_attr1.style.color = "#663915"
            this._lb_attr0.style.color = "#663915"
            this._lb_attr1.width = 160
		    this._lb_attr0.width = 160
            if (data.subtype == 99) {
                this._lb_attr0.visible = true
                this._lb_attr1.visible = false
                this._lb_attr0.innerHTML = Util.StrToHTML(data.soul_intro)
            }
            else {
                let attr_list = this._model.GetRuneAttr(data.subtype, data.level, data.color)
                for (let i = 0; i < 2; i++) {
                    let attr = attr_list[i]
                    this[`_lb_attr${i}`].visible = !!attr
                    if (attr) {
                        let value = WordManager.ConvertToPercentValue(attr[0], attr[1])
                        let str = Util.HtmlColorTxt(value, "'#d15e00'")
                        let name = WordManager.GetProperties(attr[0])
                        this[`_lb_attr${i}`].innerHTML = Util.StrToHTML(`${name}：${str}`)
                    }
                }
            }
            SetHtmlCenter(this._lb_attr0, {x:12, w:176})
            SetHtmlCenter(this._lb_attr1, {x:12, w:176})


            //因为材料要默认选择，所以发送协议
            // this.Select(data.is_selected, data.subtype == 99)
            this.Select(data.is_selected, false)

            this._lb_lv.text = data.subtype == 99? "": `Lv.${data.level}`
            this._img_lv_bg.visible = data.subtype != 99
            if(data.subtype != 99){
                ResManager.GetInstance().SetImageSprite(this, this._img_lv_bg, "rune", "rune_lv_bg_00" + color)
            }
            let txtColor = color == 6? 7: color
            let color_str = ColorUtil.GetColorDark(txtColor, false)
            this._lb_lv.strokeColor = this._lb_name.strokeColor = color_str;
            if (PlatformManager.IsEyouEnPlatform()) {
                this._lb_name.fontSize = 18
                this._lb_name.fontSize = 18
            }
        }

        public Select(select, is_fire = true){
            let data = this.data
            let bool = select == undefined ? !data.is_selected : select
            if (select == undefined) {
                if (bool) {
                    if (this._model.decSelectNum >= RuneModel.MaxDecNum) {
                        Message.show(`每次最多可分解${RuneModel.MaxDecNum}个御魂`)
                        return
                    } else {
                        this._model.decSelectNum++
                    }
                } else {
                    this._model.decSelectNum--
                }
            }
            data.is_selected = bool
            this._group_select.visible = data.is_selected
            if (is_fire) {
                this._model.Fire(RuneEvent.RUNE_SELECT_DECOMPOSE_ITEM, data)
            }
        }

    public load_callback() {
        this.InitEvent()
    }


    _Image1: Laya.Image
    _img_iconbg: Laya.Image
    _img_icon: Laya.Image
    _img_kuang: Laya.Image
    _lb_name: Laya.Label
    _lb_lv: Laya.Label
    _lb_attr0: Laya.HTMLDivElement
    _lb_attr1: Laya.HTMLDivElement
    _group_select: Laya.Box
    _Image3: Laya.Image
    _Image4: Laya.Image
    _img_click: Laya.Image
    _img_color: Laya.Image
    _img_lv_bg: Laya.Image
    
    public GetComponents() {
        [
            this._Image1,
            this._img_iconbg,
            this._img_icon,
            this._img_kuang,
            this._lb_name,
            this._lb_lv,
            this._lb_attr0,
            this._lb_attr1,
            this._group_select,
            this._Image3,
            this._Image4,
            this._img_click,
            this._img_color,
            this._img_lv_bg
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_img_iconbg",
                "_img_icon",
                "_img_kuang",
                "_lb_name",
                "_lb_lv",
                "_lb_attr0",
                "_lb_attr1",
                "_group_select",
                "_Image3",
                "_Image4",
                "_img_click",
                "_img_color",
                "_img_lv_bg"
            ])
    }
}
 window["RuneDecomposeItem"]= RuneDecomposeItem