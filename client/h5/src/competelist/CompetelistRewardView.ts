import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { CompeteListModel } from "../commonModel/CompeteListModel"
import { Util } from "../util/Util"
import { CompetelistRewaedItem } from "./CompetelistRewaedItem"

export class CompetelistRewardView extends BaseView1 {
	private loopScrowMgr: LoopScrowViewMgr;
	_model
	_sub_type
	_type

	public constructor() {
		super()

		this._type = null
		this._sub_type = null

		this._model = CompeteListModel.GetInstance();

		this.base_file = "competelist";
		this.layout_file = "CompetelistRewardView";
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
		this._type = parms[0];
		this._sub_type = parms[1];
		super.Open();
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, () => {
			this.Close();
		}, this, true);
	}

	private RenderItemList() {
		let dataList = this._model.getRewardList(this._type, this._sub_type);
		if (!dataList) { return }
		table.sort(dataList, (a?, b?) => {
			return a.reward_id < b.reward_id;
		});

		if (!this.loopScrowMgr) {
			this.loopScrowMgr = new LoopScrowViewMgr();
			this.loopScrowMgr.SetData(this._Scroller1, CompetelistRewaedItem, dataList, LoopScrCon.Vertical);
		} else {
			this.loopScrowMgr.replaceAll(dataList);
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
window["CompetelistRewardView"] = CompetelistRewardView;