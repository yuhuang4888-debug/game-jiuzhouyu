import { ArrowComponent } from "../common/ArrowComponent"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { StoryModel } from "../commonModel/StoryModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { TreasureBagItemRender } from "./TreasureBagItemRender"

export class EquipTreasureBagView extends BaseView1 {
    public close_btn
    public bag_scroller
    public bag_group
    public get_btn
    public tip_text
    bg: Laya.Image
    item_bg: Laya.Image
    Content
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _Image11: Laya.Image
    _Image2: Laya.Image

    FirstTreasure
    InitView
    LoadSuccess
    InitEvent
    public constructor() {
        super()
        this.base_file = "runeTreasure"
        this.layout_file = "EquipTreasureBagView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.destroy_imm = true
        let local_global = GlobalEventSystem
        let local_event = RuneTreasureEvent
        let local_eventname = EventName
        let local_util = Util
        let model:RuneTreasureModel = RuneTreasureModel.GetInstance()
        let local_gmodel = GoodsModel.GetInstance(),
            arr_collection_: LoopScrowViewMgr,
            full_list_ = [],
            pos_
        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvent()
        }
        this.open_callback = function () {
            // this.InitView()
        }
        this.close_callback = function () {
            if (arr_collection_) {
                arr_collection_.DeleteMe()
                arr_collection_ = null
            }
            this.ClearFuncFirst()
        }

        this.LoadSuccess = () => {
            if (PlatformManager.IsEyouEnPlatform()) {
                this.tip_text.size = 22;
            }
            this.InitView()
        }

        this.InitEvent = () => {
            let OnCloseBtnClick = () => {
                this.Close()
            }
            local_util.AddClickEvent(this.close_btn, OnCloseBtnClick, this, true)

            local_util.AddClickEvent(this.get_btn, () => {
                this.FuncFirstOpenClick()
                model.Fire(local_event.RUNE_TREASURE_REQUEST_PROTO, 41606)
                this.Close()
            }, this, true)

            this.BindEvent(local_gmodel, GoodsModel.UPDATE_GOODS_NUM, () => {
                if (this.use_delete_method) return
                this.InitView()
            })

            this.BindEvent(model, local_event.GET_ONE_REWARD, (scmd) => {
                if (scmd) {
                    let goodsids = []
                    if (scmd.gtyp_id == 32010095) {
                        goodsids.push([3, 0, 200])
                    } else {
                        goodsids.push([0, scmd.gtyp_id, 1]);
                    }
                    local_global.Fire(local_eventname.REWARD_FLY, goodsids, RuneTreasureModel.show_bag_pos)
                }
            })
        }

        this.InitView = () => {
            // full_list_ = local_gmodel.treasure_goods_list
            full_list_ = []
            for (let key in local_gmodel.treasure_goods_list) {
                full_list_.push(local_gmodel.treasure_goods_list[key])
            }
            let rem = local_gmodel.treasure_goods_list.length % 4
            for (let i = 0; i < (20 - rem); i++) {
                full_list_.push({})
            }
            if (!arr_collection_) {
                arr_collection_ = new LoopScrowViewMgr()
                arr_collection_.SetData(this.Content, TreasureBagItemRender, full_list_, LoopScrCon.Vertical, 1)
            } else {
                arr_collection_.replaceAll(full_list_)
            }
            this.UpdateFuncFirstState()
        }
    }


    public FuncFirstOpenClick() {
        if (this.has_set_func_first_state) {
            let func_first_mgr = FuncFirstOpenManager.GetInstance()
            func_first_mgr.AddStep(FuncFirstOpenKey.EquipTreasure)
            this.ClearFuncFirst()
        }
    }


    has_set_func_first_state
    public UpdateFuncFirstState() {
        let func_first_mgr = FuncFirstOpenManager.GetInstance()
        if (this.CheckFuncFirstValue() && !func_first_mgr.CheckFuncFirstOpenState(FuncFirstOpenKey.EquipTreasure)) {
            func_first_mgr.AddStepSprite(FuncFirstOpenKey.EquipTreasure, 3, this.get_btn)
            func_first_mgr.UpdateStepState(FuncFirstOpenKey.EquipTreasure)
            this.has_set_func_first_state = true
        }
        else {
            this.ClearFuncFirst()
        }
    }

    //当前数据源是否是需要引导的那条数据
    public CheckFuncFirstValue() {
        return true //this.type == `a`
    }

    public ClearFuncFirst() {
        if (this.has_set_func_first_state) {
            this.has_set_func_first_state = false
            let func_first_mgr = FuncFirstOpenManager.GetInstance()
            func_first_mgr.ClearStepSprite(FuncFirstOpenKey.EquipTreasure, 1)
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.get_btn)
        }
    }

    public GetComponents() {
        [
            this.bg,
            this.item_bg,
            this.bag_scroller,
            this.Content,
            this.close_btn,
            this.tip_text,
            this.get_btn,
            this._Image1,
            this.labelDisplay,
            this._Image11,
            this._Image2,
        ]
            = this.GetChildrenByNames([

                "bg",
                "item_bg",
                "bag_scroller",
                "Content",
                "close_btn",
                "tip_text",
                "get_btn",
                "_Image1",
                "labelDisplay",
                "_Image11",
                "_Image2",
            ])
    }
}

window["EquipTreasureBagView"] = EquipTreasureBagView