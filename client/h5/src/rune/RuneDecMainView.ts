import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { LuaSoundManager } from "../common/SoundManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { Util } from "../util/Util";
import { RuneDecomposeTab } from "./RuneDecomposeTab";
import { RuneDecomposeView } from "./RuneDecomposeView";
import { RuneResolutionView } from "./RuneResolutionView";

export class RuneDecMainView extends BaseView1 {

	_model
	_tabarr_
	bag_loop_mgr
	decompose_view_
	resolution_view_
	tabList_

	InitEvent
	LoadSuccess
	initTab
	tabTouchHandler
	SwtichView

	loop_mgr: LoopScrowViewMgr
	public constructor() {
		super()
		this.base_file = "rune"
		this.layout_file = "RuneDecMainView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.is_center = true
		this._model = RuneModel.GetInstance()
		this._tabarr_ = null
		this.tabList_ = ["分解", "拆解"]
		this.decompose_view_ = null
		this.resolution_view_ = null
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.close_callback = () => {
			if (this.decompose_view_) {
				this.decompose_view_.DeleteMe()
				this.decompose_view_ = null
			}
			if (this.resolution_view_) {
				this.resolution_view_.DeleteMe()
				this.resolution_view_ = null
			}
			this._model.RuneDecSelectTab = this._model.DECOMPOSE
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			this._tabarr_ = null
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_RUNE_BAG_LIST, () => {
				this._model.Fire(RuneEvent.DEC_MAIN_VIEW_RED, 0, this._model._resolve_red)
			});
			this.BindEvent(this._model, RuneEvent.CHANGE_RUNE_TAB, (index: number) => {
				this._model.RuneDecSelectTab = index;
				this.SwtichView(this._model.RuneDecSelectTab);
				this.loop_mgr.SetSelectIndex(index);
			});
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("common", "uisy_023"))
			// this._bg.scale9Grid = new Laya.Rectangle(200, 200, 20, 20)
			this.Content.hScrollBarSkin = ""
			this.initTab()
			this._model.Fire(RuneEvent.DEC_MAIN_VIEW_RED, 0, this._model._resolve_red)
		}

		this.initTab = () => {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.loop_mgr.SetData(this.Content, RuneDecomposeTab, this.tabList_, LoopScrCon.Horizontal, 1, (index?) => {
					this.tabTouchHandler(index);
				})
			} else {
				this.loop_mgr.replaceAll(this.tabList_)
			}

			this.Content.selectedIndex = this._model.RuneDecSelectTab;
			this.SwtichView(this._model.RuneDecSelectTab);
		}

		this.tabTouchHandler = (index?) => {
			if (this._model.RuneDecSelectTab == this.Content.selectedIndex) return;
			this._model.RuneDecSelectTab = this.Content.selectedIndex;
			this.SwtichView(this._model.RuneDecSelectTab);
		}

		this.SwtichView = (index?) => {
			// let source = (index == this._model.DECOMPOSE && ("uilwmb_015_02") || ("uilwmb_015_01"))
			// ResManager.GetInstance().SetImageSprite(this, this._img_title, "rune_asset", source, true)

			let txt = (index == this._model.DECOMPOSE && ("御魂分解") || ("御魂拆解"))
			this._img_title.text = txt
			if (index == this._model.DECOMPOSE) {
				if (!this.decompose_view_) {
					this.decompose_view_ = new RuneDecomposeView(this.sub_group)
					this.decompose_view_.Load()
				}
				this.PopUpChild(this.decompose_view_)
			} else if (index == this._model.RESOLUTION) {
				if (!this.resolution_view_) {
					this.resolution_view_ = new RuneResolutionView(this.sub_group)
					this.resolution_view_.Load()
				}
				this.PopUpChild(this.resolution_view_)
			}
		}
	}


	_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_img_title: Laya.Label
	_scroller: Laya.Panel
	Content: Laya.List
	sub_group: Laya.Box
	_btn_close: Laya.Image
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._bg,
			this._Group1,
			this._Image1,
			this._img_title,
			this._scroller,
			this.Content,
			this.sub_group,
			this._btn_close,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_Group1",
				"_Image1",
				"_img_title",
				"_scroller",
				"Content",
				"sub_group",
				"_btn_close",
				"_gp_effect",
			])
	}
}
window["RuneDecMainView"] = RuneDecMainView