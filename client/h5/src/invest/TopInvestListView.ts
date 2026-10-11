import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Color, Trim, Util } from "../util/Util"

export class TopInvestListView extends BaseItemRenderer {
    _img: Laya.Image
    _Image1: Laya.Image
    _bg: Laya.Image
    _no_btn: Laya.Box
    _Image111: Laya.Image
    labelDisplay: Laya.Label
    _get_btn: Laya.Box
    _Image11: Laya.Image
    labelDisplay1: Laya.Label
    _icon_gp: Laya.Box
    _red_dot: Laya.Image
    _img_get: Laya.Image
    _Group1: Laya.HBox
    _title_lb: Laya.HTMLDivElement
    _Image2: Laya.Image
    _img_desc: Laya.Image
    back_num: Laya.Label
    Emp_no_btn
    _item
    _model
    _needLevel
    can_touch

    public static width = 700
    public static height = 155
    public WIDTH = 690
    public HEIGT = 124
    public constructor(parent) {
        super()

        this._needLevel = 0;
        this.base_file = "invest"
        this.layout_file = "TopInvestListView"
        this._model = KaifuActivityModel.GetInstance()

        this.load_callback = () => {

            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("invest", "uidftz_007"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetIcon("invest", "uidjtz_005"), true)
            this.InitEvent()
        }
        this.Load()
    }

    public InitEvent() {

        Util.AddClickEvent(this._get_btn, () => {
            this._model.Fire(KaifuActivityModelEvent.GET_INVEST, this.data.type, this.data.id)
        }
            , this, true)

        Util.AddClickEvent(this._no_btn, () => {
            if (!this.can_touch)
                Message.show("条件未满足")
            else {
                let [need_lv, vip_lv] = this.NeedVip(this.data.type, this.data.level)
                let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
                if (need_lv && Number(my_vip) < Number(vip_lv)) {
                    Alert.Show(`升至VIP${vip_lv}可购买十倍返利投资。`, Alert_Type.Two, () => {
                        OpenFun.OpenFunHandler(23)
                    }
                        , null, "前往提升", "取消")
                } else
                    this._model.lvClick(this.data.type, this.data.level)
            }
        }
            , this, true)
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let rewordList = this._model.investReword(this.data, this.data.type)
            let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(rewordList[0], rewordList[1])
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (!this._item) {
                this._item = new BaseAwardItem(this._icon_gp)
                this._item.SetUseMask(true)
                this._item.Load()
            }
            this._item.SetItemSize(90, 90)
            this._item.SetData(goods_vo.type_id, rewordList[2])
            let flag = true
            this._needLevel = null
            if (Trim(this.data.condition) != "[]") {
                let conditionList = JSON.parse(this.data.condition)
                let level = Number(conditionList[0][1])
                this._needLevel = level
                let mylevel = RoleManager.GetInstance().GetMainRoleVo().level
                flag = mylevel >= level
            }
            let topData = this._model.getInvestData(this.data.type)
            let get = this._model.investRewardsHasGet(this.data, this.data.type)
            let cur_lv_ = null
            if (topData) {
                cur_lv_ = topData.cur_lv == this.data.level
                this._img_get.visible = get && cur_lv_
                this._get_btn.visible = (flag && cur_lv_ && !get)
                this._no_btn.visible = !this._get_btn.visible && !get
                //this._bg.color = (get && cur_lv_) && Color(0 / 255, 0 / 255, 0 / 255, 0.15) || Color(0 / 255, 0 / 255, 0 / 255, 0)
            }
            if (this._no_btn.visible) {
                let canTouch = (this._needLevel != null && flag) && cur_lv_ || this._needLevel == null && (!topData || topData && topData.cur_lv <= 0)
                //Util.SetImageGray(this._Image111, !canTouch)
                // this._no_btn.mouseEnabled = canTouch
                this.can_touch = canTouch
                // let color = canTouch ? 3 : 0
                // this.labelDisplay.stroke = color
                if (canTouch) {
                    this._Image111.skin = "resource/game/common/texture/com_rect_btn1.png"
                    this.labelDisplay.text = "领取"
                    this.labelDisplay.strokeColor = "#c95b37"
                    let [need_lv, vip_lv] = this.NeedVip(this.data.type, this.data.level)
                    let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
                    if (need_lv && Number(my_vip) < Number(vip_lv)) {
                        this.labelDisplay.text = `V${vip_lv}可买`
                    }
                }
                else {
                    this._Image111.skin = "resource/game/common/texture/com_rect_btn2.png"
                    this.labelDisplay.text = "未满足"
                    this.labelDisplay.strokeColor = "#3e9298"
                }
            }
            this._red_dot.visible = this._get_btn.visible && this.labelDisplay1.text == "领取"
            let lv = (this._needLevel && this._needLevel > 370) && "神创" + (this._needLevel - 370) || this._needLevel
            this._title_lb.style.fontSize = 22
            this._title_lb.style.color = "#5c1401"
            this._title_lb.width = 350
            this._title_lb.innerHTML = Util.StrToHTML((this._needLevel && ("达到<font color='#34a064'>" + lv + "</font>级可领取<font color='#34a064'>" + rewordList[2] + "</font>绑玉") || ("投资立返<font color='#34a064'>" + rewordList[2] + "</font>绑玉")))
            this.back_num.text = rewordList[2]
            this._Group1.refresh()
            this._img_desc.visible = Trim(this.data.icon != "")
            if (this._img_desc.visible) {
                ResManager.GetInstance().SetImageSprite(this, this._img_desc, "invest_asset", Trim(this.data.icon), true)
            }
            //LayoutRebuilder(this._Group1)
        }
    }

    public DeleteMe() {

        if (this._item) {
            this._item.DeleteMe()
        }
        super.DeleteMe()
    }

    private NeedVip(type, level) {
        let obj = this._model.InvestTypeConf(type, level)
        let need_vip = false
        let vip_lv
        let condition = JSON.parse(obj.condition)
        for (let key in condition) {
            let v = condition[key]
            if (v[0] == "vip") {
                need_vip = true
                vip_lv = v[1]
            }
        }
        return [need_vip, vip_lv]
    }

    public GetComponents() {
        [
            this._img,
            this._Image1,
            this._bg,
            this._no_btn,
            this._Image111,
            this.labelDisplay,
            this._get_btn,
            this._Image11,
            this.labelDisplay1,
            this._icon_gp,
            this._red_dot,
            this._img_get,
            this._Group1,
            this._title_lb,
            this._Image2,
            this._img_desc,
            this.back_num
        ]
            = this.GetChildrenByNames([

                "_img",
                "_Image1",
                "_bg",
                "_no_btn",
                "_Image111",
                "labelDisplay",
                "_get_btn",
                "_Image11",
                "labelDisplay1",
                "_icon_gp",
                "_red_dot",
                "_img_get",
                "_Group1",
                "_title_lb",
                "_Image2",
                "_img_desc",
                "back_num"
            ])
    }
}
window["TopInvestListView"] = TopInvestListView