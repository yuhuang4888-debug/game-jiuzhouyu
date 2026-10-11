import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { LungModel } from "../commonModel/LungModel";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";
import { LungBagSubView } from "./LungBagSubView";
import { LungShopView } from "./LungShopView";
import { LungTab } from "./LungTab";

export const LungBagViewTab = [
    { "index": 0, "name": "背包" },
    { "index": 1, "name": "兑换" },
]
window["LungBagViewTab"] = LungBagViewTab
export class LungBagView extends BaseView1 {


    LoadSuccess
    InitEvent
    Local_Open
    OpenCallback
    InitTab
    tabTouchHandler
    SwtichView
    tab_loop_mgr:LoopScrowViewMgr
    public constructor() {
        super();
        this.base_file = "lung";
        this.layout_file = "LungBagView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.is_center = true
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        let model = LungModel.GetInstance(),
            item_list_,
            // _tab_arraycollection_: eui.ArrayCollection,
            _select_tab_ = -1,
            bag_sub_view_: LungBagSubView,
            shop_view_: LungShopView
        this.load_callback = function () {
            this.LoadSuccess();
            this.InitEvent();
        }
        this.open_callback = function () {
			LungModel.lung_msg_hide = true
            this.OpenCallback();
        }
        this.destroy_callback = function () {
			LungModel.lung_msg_hide = false
            for (let item of item_list_) {
                item.DeleteMe()
            }
            item_list_ = null
            this.array_collection = null
            // this._tab_list.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.tabTouchHandler, this);
            if (bag_sub_view_) {
                bag_sub_view_.DeleteMe()
                bag_sub_view_ = null
            }
            if (shop_view_) {
                shop_view_.DeleteMe()
                shop_view_ = null
            }
            _select_tab_ = 0
            if (this.tab_loop_mgr){
                this.tab_loop_mgr.DeleteMe()
                this.tab_loop_mgr = null
            }
            // _tab_arraycollection_ = null
        }

        this.LoadSuccess = () => {
            item_list_ = []
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("lung", "uisy_023"))
        }

        this.InitEvent = () => {
            // this._tab_list.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.tabTouchHandler, this);
            let close_fun = () => {
                this.Close()
            }
            Util.AddClickEvent(this.closeBtn, close_fun, this, true)

        }

        this.Local_Open = (parms) => {
            if (parms[0]) {
                _select_tab_ = parms[0]
            }

            super.Open()
        }

        this.OpenCallback = () => {
            if (!_select_tab_ || _select_tab_ < 0) {
                _select_tab_ = -1
            }
            this.InitTab()
            this.SwtichView(_select_tab_)
        }

        this.InitTab = () => {
            if (! this.tab_loop_mgr ) {
                this.tab_loop_mgr =  new LoopScrowViewMgr()
                this.tab_loop_mgr.SetData(this._tab_list, LungTab,LungBagViewTab,LoopScrCon.Horizontal,1,() => {
                        let index = this._tab_list.selectedIndex
                        if (_select_tab_ == index ) {
                            return
                        }
                        _select_tab_ = index
                        if (_select_tab_ == 1 ) {
                            model.HideShopTabDot()
                        }
                        this.SwtichView(_select_tab_)
                    })
            }else{
                this.tab_loop_mgr.replaceAll(LungBagViewTab)
            }
            if (_select_tab_ != -1){
                this.tab_loop_mgr.SetSelectIndex(_select_tab_)
            }

            // if (!_tab_arraycollection_) {
            //     _tab_arraycollection_ = new eui.ArrayCollection(LungBagViewTab);
            //     this._tab_list.dataProvider = _tab_arraycollection_;
            //     this._tab_list.itemRenderer = LungTab;
            //     this._tab_list.selectedIndex = _select_tab_;
            // }
        }

        // this.tabTouchHandler = (e: eui.ItemTapEvent) => {
        //     if (_select_tab_ == this._tab_list.selectedIndex) return
        //     _select_tab_ = this._tab_list.selectedIndex
        //     if (_select_tab_ == 1) {
        //         model.HideShopTabDot()
        //     }
        //     this.SwtichView(_select_tab_)
        // }

        this.SwtichView = (index) => {
            this.title.skin = index == 0 ? AtlasUrl("lung", "uilwmb_023") : AtlasUrl("lung", "uilwmb_014c")
            if (index == 0) {
                if (!bag_sub_view_) {
                    bag_sub_view_ = new LungBagSubView(this.sub_group)
                    bag_sub_view_.Load()
                }
                this.PopUpChild(bag_sub_view_)
            } else if (index == 1) {
                if (!shop_view_) {
                    shop_view_ = new LungShopView(this.sub_group)
                    shop_view_.Load()
                }
                this.PopUpChild(shop_view_)
            }
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }
    

    scroll: Laya.Panel
    _tab_list: Laya.List
    _Image1: Laya.Image
    closeBtn: Laya.Image
    _Image2: Laya.Image
    title: Laya.Image
    sub_group: Laya.Box
    public GetComponents() {
        [
            this.scroll,
            this._tab_list,
            this._Image1,
            this.closeBtn,
            this._Image2,
            this.title,
            this.sub_group,
        ]
            = this.GetChildrenByNames([

                "scroll",
                "_tab_list",
                "_Image1",
                "closeBtn",
                "_Image2",
                "title",
                "sub_group",
            ])
    }
}

window["LungBagView"] = LungBagView

