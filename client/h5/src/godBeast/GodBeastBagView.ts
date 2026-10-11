import { BaseView1 } from "../common/BaseView1";
import { DownDropBtn } from "../common/DownDropBtn";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { CrossServerViewIndex } from "../commonController/BossController";
import { CompositeModel } from "../commonModel/CompositeModel";
import { GodBeastModel } from "../commonModel/GodBeastModel";
import { Kf1vnEvent, Kf1vnModel } from "../commonModel/Kf1vnModel";
import { MainFunc } from "../commonModel/MainUIModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { GodBeastBagItem } from "./GodBeastBagItem";

export class GodBeastBagView extends BaseView1 {

    public _dd_color: DownDropBtn
    public _dd_star: DownDropBtn

    InitEvent
    InitView
    ClickColor
    ClickStar
    UpdateBagItems
    item_loop_list
    item_loop_mgr:LoopScrowViewMgr
    public constructor() {
        super()
        let _model = GodBeastModel.GetInstance(),
            local_Util = Util,
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            res_mgr = ResManager.GetInstance(),
            // _ac_item_: eui.ArrayCollection,
            _color_ = 99,
            _star_ = 99

        this.base_file = "godBeast"
        this.layout_file = "GodBeastBagView"
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.show_open_movie = true
        this.click_bg_toClose = true

        this.preload_client_config = {
            "ConfigGodBeast": false
        }
        this.preload_server_config = {
            "config_eudemons_equip_attr": false
        }

        this.load_callback = function () {
            this.InitEvent()
            this.InitView()
        }
        this.destroy_callback = function () {
            if (this._dd_color) {
                this._dd_color.DeleteMe()
                this._dd_color = null
            }
            if (this._dd_star) {
                this._dd_star.DeleteMe()
                this._dd_star = null
            }
            if(this.item_loop_mgr){
                this.item_loop_mgr.DeleteMe()
                this.item_loop_mgr = null
            }
        }


        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_compose, () => {
                local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Composite, CompositeModel.Index.GodBeast)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_get, () => {
                //Message.show("敬请期待")
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss)
                this.Close()
            }, this, true)
        }

        this.InitView = () => {
            let config = res_mgr.GetGameConfigFromCache(this, "ConfigGodBeast", true)
            let color_cfg = _model.GetDonwDropData("bag_color_cfg", config)
            let star_cfg = _model.GetDonwDropData("bag_star_cfg", config)
            this._dd_color = new DownDropBtn(this.color_con)
            this._dd_star = new DownDropBtn(this.star_con)
            this._dd_color.Init(color_cfg, this.ClickColor, "全部品质", "content", undefined, 3, false, false)
            this._dd_color.Load()
            this._dd_star.Init(star_cfg, this.ClickStar, "全部", "content", undefined, undefined, false, false)
            this._dd_star.Load()
            this.UpdateBagItems()
        }

        this.ClickColor = (index, data) => {
            _color_ = data.cond
            this.UpdateBagItems()
        }

        this.ClickStar = (index, data) => {
            _star_ = data.cond
            this.UpdateBagItems()
        }

        this.UpdateBagItems = () => {
            let eudemons_equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
            let list = _model.GetGoodsByBagCond(_color_, _star_, eudemons_equip_attr_cfg)
            // list.sort((a, b) => { return b.rating < a.rating })
            if (!this.item_loop_mgr){
                this.item_loop_mgr = new LoopScrowViewMgr()
                this.item_loop_mgr.SetData(this._group_item, GodBeastBagItem, list, LoopScrCon.Vertical)
            }else{
                this.item_loop_mgr.replaceAll(list)
            }
            this._group_empty.visible = list.length < 1
        }
    }
    

    _Image111: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _btn_close: Laya.Image
    _Image4: Laya.Image
    _Scroller1: Laya.Panel
    _group_item: Laya.List
    color_con: Laya.Box
    star_con: Laya.Box
    _btn_compose: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _btn_get: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    _group_empty: Laya.Box
    _Image5: Laya.Image
    _Label1: Laya.Label
    public GetComponents() {
        [
            this._Image111,
            this._Image2,
            this._Image3,
            this._btn_close,
            this._Image4,
            this._Scroller1,
            this._group_item,
            this.color_con,
            this.star_con,
            this._btn_compose,
            this._Image11,
            this.labelDisplay,
            this._btn_get,
            this._Image1,
            this.labelDisplay1,
            this._group_empty,
            this._Image5,
            this._Label1,
        ]
            = this.GetChildrenByNames([

                "_Image111",
                "_Image2",
                "_Image3",
                "_btn_close",
                "_Image4",
                "_Scroller1",
                "_group_item",
                "color_con",
                "star_con",
                "_btn_compose",
                "_Image11",
                "labelDisplay",
                "_btn_get",
                "_Image1",
                "labelDisplay1",
                "_group_empty",
                "_Image5",
                "_Label1",
            ])
    }
}

window["GodBeastBagView"] = GodBeastBagView