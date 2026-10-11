import { GoodsModel } from "../commonModel/GoodsModel";
import { LungModel } from "../commonModel/LungModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";
import { BaseView1 } from "./BaseView1";
import { EquipmentItem } from "./EquipmentItem";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";

export class LungToolTips extends BaseView1 {

    LoadSuccess
    InitEvent
    SetData
    InitView
    RefreshBtnState
    RefreshSize
    public constructor() {
        super()
        let model = LungModel.GetInstance(),
            local_Util = Util,
            goods_model = GoodsModel.GetInstance(),
            _type_id: number = 0,
            _level: number = 0,
            _goods_vo: any = null,
            _goods_icon: EquipmentItem,
            // _btn_list: Array<eui.Button>,
            _show_btn_list: Array<number>

        this.base_file = "common"
        this.layout_file = "LungToolTips"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true

        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.open_callback = function () {
            this.InitView()
        }
        this.close_callback = function () {

        }
        this.destroy_callback = function () {
            if (_goods_icon) {
                _goods_icon.DeleteMe()
                _goods_icon = null
            }
            GlobalEventSystem.Fire(EventName.CLOSE_TIPS_VIEW)
        }

        this.LoadSuccess = () => {
            this._Scroller1.vScrollBar.visible = false
            this.InitEvent()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)
        }

        /**
         * @param  {number} type_id 物品类型
         * @param  {number} level?	等级
         * @param  {Array<number>} show_btn_list?	显示部分按钮(传按钮所在深度)
         */
        this.SetData = (type_id: number, level?: number, show_btn_list?: Array<number>) => {
            _type_id = type_id
            _level = level || 1
            _show_btn_list = show_btn_list ? show_btn_list : [0]
            let main_role_id = RoleManager.GetInstance().GetMainRoleId()
            _goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
        }

        this.InitView = () => {
            if (!_goods_vo) { return }
            let basic = goods_model.GetGoodsBasicByTypeId(_type_id)
            if (basic == null) { return }
            this.img1.skin = AtlasUrl("common4", "ui_tips_pz_" + basic.color)
            if (!_goods_icon) {
                _goods_icon = new EquipmentItem(this._gp_icon)
                _goods_icon.Load()
                _goods_icon.SetItemSize(92, 92)
                _goods_icon.ChangeCountVisible(false)
            }
            _goods_icon.SetData(_goods_vo.type_id, null, null, null, null, null, null, null, null, _level);
            _goods_icon.SetShowTips(false)

            this._lb_series.style.fontSize = 22
            this._lb_series.width = 200
            this._lb_series.style.color = "#ffffff"
            this._lb_series.innerHTML = local_Util.StrToHTML(`系别:&nbsp;<font color='#ffe222'>${model.GetSeriesDesc(basic.subtype)}</font>`);
            let [level, star] = model.GetLungRealLvAndStar(_level)
            this._lb_num.style.fontSize = 22
            this._lb_num.width = 200
            this._lb_num.style.color = "#ffffff"
            this._lb_num.innerHTML = local_Util.StrToHTML(`等级:&nbsp;<font color='#ffe222'>${level}</font>`)
            let color_str = ColorUtil.GetColorDark(_goods_vo.color, false)
            // this._lb_name.color = color_str
            this._lb_name.text = local_Util.StrToHTML(`${(basic.goods_name).trim()}`)

            //基础属性
            let str = model.GetBasePro(_goods_vo.type_id, _level);
            let maxLv =  model.getMaxLv(_goods_vo.type_id);
            let max_str = model.GetMaxPro(_goods_vo.type_id, maxLv)
            this.base_attr.style.fontSize = 20
            this.base_attr.width = 314
            this.base_attr.style.leading = 10
            this.base_attr.style.color = "#663915"
            this.base_attr.innerHTML = local_Util.StrToHTML(str)
            this.max_attr_lb.style.fontSize = 20
            this.max_attr_lb.width = 314
            this.max_attr_lb.style.leading = 10
            this.max_attr_lb.innerHTML = local_Util.StrToHTML(max_str)

            let skill_str = model.GetSkillStr(_goods_vo.type_id, _level)
            this.effect_str.style.fontSize = 20
            this.effect_str.width = 314
            this.effect_str.style.leading = 10
            this.effect_str.style.color = "#663915"
            this.effect_str.innerHTML = local_Util.StrToHTML(skill_str)

            this.RefreshBtnState()
            this.RefreshSize()
        }

        //按钮
        this.RefreshBtnState = () => {
            // let btn
            // for (let i = 0; i < this._gp_btns.numChildren; i++) {
            //     let show = _show_btn_list.indexOf(i) != -1

            //     btn = this._gp_btns.getChildAt(i)
            //     if (btn) {
            //         btn.visible = show
            //         btn.includeInLayout = show
            //     }
            // }
        }

        this.RefreshSize = () => {
            this.base_pro_conta.height = this.base_attr.y + this.base_attr.contextHeight + 10
            this.line.y = this.base_attr.y + this.base_attr.contextHeight

            this.skill_conta.height = this.effect_str.y + this.effect_str.contextHeight + 10 + 10
            this.line1.y = this.effect_str.y + this.effect_str.contextHeight + 10

        }
    }


    _img_bg: Laya.Image
    _gp_icon: Laya.Box
    img1: Laya.Image
    img2: Laya.Image
    _lb_name: Laya.Label
    _lb_series: Laya.HTMLDivElement
    _lb_num: Laya.HTMLDivElement
    _Scroller1: Laya.Panel
    _Group1: Laya.VBox
    base_pro_conta: Laya.Box
    line111: Laya.Image
    _Label1: Laya.Label
    base_attr: Laya.HTMLDivElement
    max_attr_lb: Laya.HTMLDivElement
    line: Laya.Image
    skill_conta: Laya.Box
    line11: Laya.Image
    _Label2: Laya.Label
    effect_str: Laya.HTMLDivElement
    line1: Laya.Image
    _btn_close: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._gp_icon,
            this.img1,
            this.img2,
            this._lb_name,
            this._lb_series,
            this._lb_num,
            this._Scroller1,
            this._Group1,
            this.base_pro_conta,
            this.line111,
            this._Label1,
            this.base_attr,
            this.max_attr_lb,
            this.line,
            this.skill_conta,
            this.line11,
            this._Label2,
            this.effect_str,
            this.line1,
            this._btn_close,
            this._Image1,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_gp_icon",
                "img1",
                "img2",
                "_lb_name",
                "_lb_series",
                "_lb_num",
                "_Scroller1",
                "_Group1",
                "base_pro_conta",
                "line111",
                "_Label1",
                "base_attr",
                "max_attr_lb",
                "line",
                "skill_conta",
                "line11",
                "_Label2",
                "effect_str",
                "line1",
                "_btn_close",
                "_Image1",
                "labelDisplay",
            ])
    }
}
window["LungToolTips"] = LungToolTips