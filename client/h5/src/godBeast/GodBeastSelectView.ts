import { BaseView1 } from "../common/BaseView1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { CrossServerViewIndex } from "../commonController/BossController";
import { GodBeastModel } from "../commonModel/GodBeastModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { GodBeastSelectItem } from "./GodBeastSelectItem";

export class GodBeastSelectView extends BaseView1 {

    Local_Open
    InitEvent
    UpdateView
    InitItems
    UpdateItems
    public constructor() {
        super()
        let _model = GodBeastModel.GetInstance(),
            local_Util = Util,
            res_mgr = ResManager.GetInstance(),
            // _ac_item_: eui.ArrayCollection,
            _id_,
            _pos_,
            _item_loop_list,
            _item_loop_mgr:LoopScrowViewMgr

        this.base_file = "godBeast"
        this.layout_file = "GodBeastSelectView"
        this.layer_value = Enum_UILayer.Activity;
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.click_bg_toClose = true

        this.load_callback = function () {
            this.InitItems()
            this.InitEvent()
        }
        this.open_callback = function () {
            this.UpdateView()
        }
        this.preload_server_config = {
            "config_eudemons_equip_pos": false,
            "config_eudemons_equip_attr": false,
        }

        this.Local_Open = (parms) => {
            [_id_, _pos_] = parms
            super.Open()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_get, () => {
                //Message.show("敬请期待")
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss)
                this.Close()
            }, this, true)

            // this.BindEvent( _model, GodBeastEvent.EQUIP_UPDATE, () => {
            //     this.UpdateView()
            // })

            this.BindVar(_model, "_beast_info", () => {
                this.UpdateView()
            })
        }

        this.UpdateView = () => {
            let eudemons_equip_pos_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_pos", false)
            let eudemons_equip_attr = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
            let list = _model.GetGoodsByCond(_id_, _pos_, eudemons_equip_pos_cfg, eudemons_equip_attr)
            this.UpdateItems(list)
            this._group_empty.visible = list.length < 1
            // let pos_data =  _model.GetBeastEquipPosData( _id_,  _pos_, eudemons_equip_pos_cfg)
            // let cond = JSON.parse(pos_data.conditions)
            // let color = cond ? Number(cond[0][1]) : 0
            let cond = _model.GetBeastEquipCond(_id_, _pos_, eudemons_equip_pos_cfg)
            let color_name = ColorUtil.GetColorName(cond.color)
            let pos_name = _model.GetEquipPosName(_pos_)
            let star_star = cond.star > 0 ? `${cond.star}星` : ""
            this._lb_tip.text = `选择${color_name}${star_star}品质及以上${pos_name}穿戴`
        }

        this.InitItems = () => {
            // _ac_item_ = new eui.ArrayCollection()
            // this._group_item.dataProvider = _ac_item_
            // this._group_item.itemRenderer = GodBeastSelectItem
            _item_loop_list = []
            _item_loop_mgr =  new LoopScrowViewMgr(this.layer_value)
            _item_loop_mgr.SetData(this._group_item, GodBeastSelectItem, _item_loop_list, LoopScrCon.Vertical, 1)

        }

        this.UpdateItems = (list) => {
            _item_loop_mgr.replaceAll(list)
        }
    }


    public Open(...parms) {
        this.Local_Open(parms)
    }
    


    _Image1: Laya.Image
    _Image2: Laya.Image
    _btn_close: Laya.Image
    _lb_tip: Laya.Label
    _Group1: Laya.HBox
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Scroller1: Laya.Panel
    _group_item: Laya.List
    _group_empty: Laya.Box
    _Image6: Laya.Image
    _Label1: Laya.Label
    _btn_get: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._btn_close,
            this._lb_tip,
            this._Group1,
            this._Image3,
            this._Image4,
            this._Image5,
            this._Scroller1,
            this._group_item,
            this._group_empty,
            this._Image6,
            this._Label1,
            this._btn_get,
            this._Image11,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_btn_close",
                "_lb_tip",
                "_Group1",
                "_Image3",
                "_Image4",
                "_Image5",
                "_Scroller1",
                "_group_item",
                "_group_empty",
                "_Image6",
                "_Label1",
                "_btn_get",
                "_Image11",
                "labelDisplay",
            ])
    }
}

window["GodBeastSelectView"] = GodBeastSelectView