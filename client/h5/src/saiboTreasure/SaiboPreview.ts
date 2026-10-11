import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { Util } from "../util/Util"
import { SaiboPreviewRewardItem } from "./SaiboPreviewRewardItem"

export class SaiboPreview extends BaseView1 {
	private loopScrowMgr: LoopScrowViewMgr;
	private _rewards: any[];

	public constructor() {
		super()
		this.base_file = "saiboTreasure";
		this.layout_file = "SaiboPreview";
		this.layer_value = Enum_UILayer.Activity;
		this.destroy_imm = true;
		this.is_center = true;
		this.use_background = true;
		this.click_bg_toClose = true;
		this.use_delete_method = false;

		this.load_callback = () => {
			this.InitEvent();
			this.RenderItemList();
		}

		this.destroy_callback = () => {
			if (this.loopScrowMgr) {
				this.loopScrowMgr.DeleteMe();
				this.loopScrowMgr = null;
			}
		}

	}

	private Local_Open(parms: any) {
		this._rewards = parms[0];
		super.Open();
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, () => {
			this.Close();
		}, this, true);
	}

	private RenderItemList() {
		if (!this.loopScrowMgr) {
			this.loopScrowMgr = new LoopScrowViewMgr();
			this.loopScrowMgr.SetData(this._Scroller1, SaiboPreviewRewardItem, this._rewards, LoopScrCon.Vertical);
		} else {
			this.loopScrowMgr.replaceAll(this._rewards);
		}
	}

	public Open(...new_args) {
		let parms = new_args;
		this.Local_Open(parms);
	}

	public DeleteMe() {
		if (this.loopScrowMgr) {
			this.loopScrowMgr.DeleteMe();
			this.loopScrowMgr = null;
		}
		super.DeleteMe();
	}


	_btn_close: Laya.Image
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._btn_close,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"_btn_close",
				"_Scroller1",
			])
	}
}
window["SaiboPreview"] = SaiboPreview