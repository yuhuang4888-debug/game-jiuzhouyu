import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { investType, KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Color, Trim, Util } from "../util/Util"

export class LVinvestListView extends BaseItemRenderer {
    _img: Laya.Image
    _Image1: Laya.Image
    _bg: Laya.Image
    _no_btn: Laya.Box
    _Image111: Laya.Image
    labelDisplay1: Laya.Label
    _get_btn: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
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
    data
    can_touch

    public static width = 700
    public static height = 155
    public WIDTH = 690
    public HEIGT = 124
    public constructor(parent) {
        super()

        this._needLevel = 0;
        this.base_file = "invest"
        this.layout_file = "LVinvestListView"
        this._model = KaifuActivityModel.GetInstance()

        this.load_callback = () => {

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._title_lb.size  = 20
            // }
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetIcon("invest", "uidjtz_005a"), true)
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("invest", "uidjtz_006"), true)
            this.InitEvent()
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 	this._title_lb.size  = 16
            // 	LayoutRebuilder(this._Group1)
            // }
        }
        this.Load()
    }

    public InitEvent() {

        Util.AddClickEvent(this._get_btn, () => {
            this._model.Fire(KaifuActivityModelEvent.GET_INVEST, investType.level, this.data.id)
        }
            , this, true)
        Util.AddClickEvent(this._no_btn, () => {
            if (!this.can_touch)
                Message.show("条件未满足")
            else {
                let [need_lv, vip_lv] = this.NeedVip(investType.level, this.data.level)
                let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
                if (need_lv && Number(my_vip) < Number(vip_lv)) {
                    Alert.Show(`升至VIP${vip_lv}可购买十倍返利投资。`, Alert_Type.Two, () => {
                        OpenFun.OpenFunHandler(23)
                    }
                        , null, "前往提升", "取消")
                } else
                    this._model.lvClick(investType.level, this.data.level)
            }
        }
            , this, true)

    }

    public dataChanged() {
        if (super.dataChanged()) {
            let rewordList = this._model.investReword(this.data, investType.level)
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
            let levelData = this._model.getInvestData(investType.level)
            let get = this._model.investRewardsHasGet(this.data, investType.level)
            let cur_lv_ = null
            if (levelData) {
                cur_lv_ = levelData.cur_lv == this.data.level
                this._img_get.visible = get && cur_lv_
                this._get_btn.visible = (flag && cur_lv_ && !get)
                this._no_btn.visible = !this._get_btn.visible && !get
                //this._bg.color = (get && cur_lv_) && Color(0 / 255, 0 / 255, 0 / 255, 0.15) || Color(0 / 255, 0 / 255, 0 / 255, 0)
            }
            if (this._no_btn.visible) {
                let canTouch = (this._needLevel != null && flag) && cur_lv_ || this._needLevel == null && (!levelData || levelData && levelData.cur_lv <= 0)
                this.can_touch = canTouch
                // Util.SetImageGray(this._Image111, !canTouch)
                // let color = canTouch ? 3 : 0
                // this.labelDisplay1.stroke = color
                //this._no_btn.mouseEnabled = canTouch
                if (canTouch) {
                    this._Image111.skin = "resource/game/common/texture/com_rect_btn1.png"
                    this.labelDisplay1.text = "领取"
                    this.labelDisplay1.strokeColor = "#c95b37"
                    let [need_lv, vip_lv] = this.NeedVip(investType.level, this.data.level)
                    let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
                    if (need_lv && Number(my_vip) < Number(vip_lv)) {
                        this.labelDisplay1.text = `V${vip_lv}可买`
                    }
                }
                else {
                    this._Image111.skin = "resource/game/common/texture/com_rect_btn2.png"
                    this.labelDisplay1.text = "未满足"
                    this.labelDisplay1.strokeColor = "#3e9298"
                }
            }
            this._red_dot.visible = this._get_btn.visible && this.labelDisplay.text == "领取"
            let lv = (this._needLevel && this._needLevel > 370) && "神创" + (this._needLevel - 370) || this._needLevel
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 	this._title_lb.textFlow = Util.StrToHTML((this._needLevel && ( "Capai <font color='" + ColorUtil.GetColorLight(ColorType.GREEN) + "'>" + lv + "</font>utk ambil<font color='" + ColorUtil.GetColorLight(ColorType.GREEN) + "'>" + rewordList[2] + "</font> berlian terikat" ) || ( "Invest utk langsung cashback <font color='" + ColorUtil.GetColorLight(ColorType.GREEN) + "'>" + rewordList[2] + "</font> berlian terikat" ) ))
            // }else{
            this._title_lb.style.fontSize = 22
            this._title_lb.style.color = "#5c1401"
            this._title_lb.width = 350
            this._title_lb.innerHTML = Util.StrToHTML((this._needLevel && ("达到<font color='#34a064'>" + lv + "</font>级可领取<font color='#34a064'>" + rewordList[2] + "</font>绑玉") || ("投资立返<font color='#34a064'>" + rewordList[2] + "</font>绑玉")))
            this.back_num.text = rewordList[2]
            this._Group1.refresh()
            //}

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
            this._item = null
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
            this.labelDisplay1,
            this._get_btn,
            this._Image11,
            this.labelDisplay,
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
                "labelDisplay1",
                "_get_btn",
                "_Image11",
                "labelDisplay",
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
window["LVinvestListView"] = LVinvestListView