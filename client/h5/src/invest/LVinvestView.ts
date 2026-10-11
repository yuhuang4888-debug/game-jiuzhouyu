import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { investType, KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { NotEnougnDiamond, Util } from "../util/Util"
import { LVinvestListView } from "./LVinvestListView"
import { LVinvestSelectItem } from "./LVinvestSelectItem"

export class LVinvestView extends BaseItem1 {
    _bg: Laya.Image
    _banner_bg: Laya.Image
    _title_img: Laya.Image
    _item_scroller: Laya.Panel
    Content1: Laya.List
    _gp_btn: Laya.Box
    _Image1: Laya.Image
    _lb_btn: Laya.Label
    _lb_small_btn: Laya.Label
    _Image2: Laya.Image
    _desc_lb: Laya.Label
    _Scroller1: Laya.Panel
    Content: Laya.List
    buy: Laya.Image
    InitEvent
    LoadSuccess
    initItem
    initSelect
    investType
    NeedVip
    item_loop_mgr
    mask
    raycast_gp_btn
    sel_loop_mgr

    public static className = "LVinvestView"
    public constructor(parent?) {
        super(parent)


        this.base_file = "invest"
        this.layout_file = "LVinvestView"
        this.investType = investType.level
        let _model = KaifuActivityModel.GetInstance()
        let level = null
        let local_investType = investType
        let local_KaifuActivityModelEvent = KaifuActivityModelEvent
        this.preload_server_config = {
            "config_investment_item": false
        }
        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()

            // 		if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 			let csf = this._desc_lb.GetComponent("ContentSizeFitter")
            // 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // 			csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // 			SetSizeDelta(this._desc_lb,180,30)
            // 			this._desc_lb.lineSpacing = 0.6
            // 			this._desc_lb.size  = 13
            // 		}
            // 		if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 			this._desc_lb.size  = 14
            // 			this._desc_lb.lineSpacing = 0.6
            // 			let csf = this._desc_lb.GetComponent("ContentSizeFitter")
            // 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // 			SetSizeDeltaX(this._desc_lb,210.7)
            // 			SetAnchoredPosition(this._desc_lb,493, -126.6)
            // 			this._desc_lb.verticalAlign = "middle"
            // this._desc_lb.textAlign = "center"
            // 		}
        }

        this.InitEvent = () => {
            let click = () => {
                let curConf = _model.InvestTypeConf(local_investType.level, level)
                let mainVo = RoleManager.GetInstance().GetMainRoleVo()
                let cost = curConf.price
                let str = null
                let [need_lv, vip_lv] = this.NeedVip(local_investType.level, level)
                let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
                if (need_lv && Number(my_vip) < Number(vip_lv)) {
                    Alert.Show(`升至VIP${vip_lv}可购买十倍返利投资。`, Alert_Type.Two, () => {
                        OpenFun.OpenFunHandler(23)
                    }
                        , null, "前往提升", "取消")
                }
                else {
                    if (mainVo.jin >= cost) {
                        str = "是否花费<font color='#34a064'>" + cost + "勾玉</font>进行投资<br>(投资后总共可获得<font color='#34a064'>" + _model.allPrice(level) + "绑玉</font>)"
                    } else {
                        NotEnougnDiamond()
                        return
                    }
                    let content = Util.StrToHTML(str)
                    Alert.Show(content, Alert_Type.Two, () => {
                        if (mainVo.jin >= cost) {
                            _model.Fire(local_KaifuActivityModelEvent.SEND_INVEST_LEVEL, local_investType.level, level)
                        } else {
                            setTimeout(() => {
                                OpenFun.OpenFunHandler(21)
                            }
                                , 0.3)
                        }
                    }
                        , null, "确定", "取消")
                }

            }

            Util.AddClickEvent(this._gp_btn, click, this, true)
            let update = (type?, level?) => {
                if (type == local_investType.level) {
                    this.initItem(level)
                }
            }

            this.BindEvent(_model, local_KaifuActivityModelEvent.SELECT_LVINVEST_LEVEL, update)
            this.BindEvent(_model, local_KaifuActivityModelEvent.INVEST_DATA_UPDATE, update)
        }

        this.LoadSuccess = () => {
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
            //     this._desc_lb.size = 16
            // }
            ResManager.GetInstance().SetOutsideImageSprite(this, this._banner_bg, GameResPath.GetIcon("invest", "uidjtz_001"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this._title_img, GameResPath.GetIcon("invest", "uidjtz_002"), true)
            //ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("invest", "uidjtz_005"))
            if (!_model.clickInvest[local_investType.level]) {
                _model.clickInvest[local_investType.level] = true
                _model.setLEVELReddot()
            }
            this.initItem()
            this.initSelect()
        }

        this.initSelect = () => {
            let data = _model.menuConfList(local_investType.level)
            if (!this.sel_loop_mgr) {
                this.sel_loop_mgr = new LoopScrowViewMgr()
                this.sel_loop_mgr.SetData(this.Content, LVinvestSelectItem, data, LoopScrCon.Horizontal, 1, () => { }, { not_first_call: true })
            } else {
                this.sel_loop_mgr.replaceAll(data)
            }
            this.sel_loop_mgr.SetSelectIndex(_model.selectIndex(local_investType.level), false)
        }

        this.initItem = (_level?) => {
            level = (_level && (_level) || (_model.getInvestLevelByType(local_investType.level)))
            let data = _model.investRewardsList(level, local_investType.level)
            if (!this.item_loop_mgr) {
                this.item_loop_mgr = new LoopScrowViewMgr()
                this.item_loop_mgr.SetData(this.Content1, LVinvestListView, data, LoopScrCon.Vertical, 1, null, { not_first_call: true })
            } else {
                this.item_loop_mgr.replaceAll(data)
            }

            let confData = _model.InvestTypeConf(local_investType.level)
            let maxConf = confData[confData.length - 1]
            let curData = _model.getInvestData(local_investType.level)
            let config_investment_item = ResManager.GetInstance().GetGameConfigFromCache(this, "config_investment_item", false)
            let fullCondtion = _model.investOpenStatus(local_investType.level, config_investment_item)
            if (curData) {
                let flag = !(curData.cur_lv <= 0) && fullCondtion
                //Util.SetImageGray(this._Image1, flag)
                //this._lb_btn.strokeColor = flag ? "#939393" : "#c6373d"
                this._lb_small_btn.visible = !flag//flag ? "#ffffff" : "#fffd6b"
                // this._lb_small_btn.strokeColor = flag ? "#939393" : "#958c00"
                this.buy.visible = flag
                //this._desc_lb.visible = !flag
                if (!flag) {
                    let size = 28
                    let size2 = 20
                    // if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
                    //     size = 18
                    //     size2 = 14
                    // }
                    this._lb_btn.text = "立即投资"
                    this._lb_small_btn.text = "尽享1000%返利"
                    this._lb_btn.centerY = -10
                    let [need_lv, vip_lv] = this.NeedVip(local_investType.level, level)
                    let my_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
                    if (need_lv && Number(my_vip) < Number(vip_lv)) {
                        this._lb_btn.text = `V${vip_lv}可买`
                    }
                } else {
                    let size = 26
                    let size2 = 22
                    // if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
                    //     size = 18
                    //     size2 = 14
                    // }
                    let str = curData.cur_lv != maxConf.level ? "普通投资" : "超值投资"
                    this._lb_btn.text = str
                    this._lb_btn.centerY = 0
                    //this._lb_small_btn.text = str
                }
                this._gp_btn.mouseEnabled = !flag
            }
            this._desc_lb.text = "投资后无法更换档位"
        }

        this.DeleteMe = () => {
            if (this.sel_loop_mgr) {
                this.sel_loop_mgr.DeleteMe()
                this.sel_loop_mgr = null
            }

            if (this.item_loop_mgr) {
                this.item_loop_mgr.DeleteMe()
                this.item_loop_mgr = null
            }
            super.DeleteMe()
        }

        this.NeedVip = (type, level) => {
            let obj = _model.InvestTypeConf(type, level)
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
    }


    public GetComponents() {
        [
            this._bg,
            this._banner_bg,
            this._title_img,
            this._item_scroller,
            this.Content1,
            this._gp_btn,
            this._Image1,
            this._lb_btn,
            this._lb_small_btn,
            this._Image2,
            this._desc_lb,
            this._Scroller1,
            this.Content,
            this.buy
        ]
            = this.GetChildrenByNames([

                "_bg",
                "_banner_bg",
                "_title_img",
                "_item_scroller",
                "Content1",
                "_gp_btn",
                "_Image1",
                "_lb_btn",
                "_lb_small_btn",
                "_Image2",
                "_desc_lb",
                "_Scroller1",
                "Content",
                "buy"
            ])
    }
}
window["LVinvestView"] = LVinvestView