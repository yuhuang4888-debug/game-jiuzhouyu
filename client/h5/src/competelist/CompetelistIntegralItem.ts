
import { ResManager } from '../common/ResManager';
import { CompeteListEvent, CompeteListModel } from '../commonModel/CompeteListModel';
import { StageShowView } from '../customActivity/StageShowView';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
export class CompetelistIntegralItem extends BaseItem1 {
	_data
	_index
	_model
	_stage_show
	_sub_type
	_type
	canGet

	public static width = 93;

	public static height = 93;

	public constructor(parent?) {
		super(parent);

		this._data = null;

		this._type = null;

		this._sub_type = null;

		this._index = null;

		this._stage_show = null;

		this.canGet = false;

		this.base_file = "competelist";

		this.layout_file = "CompetelistIntegralItem";

		this._model = CompeteListModel.GetInstance();

		this.load_callback = () => {
			this.InitEvent();
			this.LoadSuccess();
		}
	}



	public InitEvent() {
		this.BindEvent(this._model, CompeteListEvent.UPDATE_VIEW_DATA, (scmd?) => {
			if (scmd.type == this._type && scmd.subtype == this._sub_type) {
				this.checkGet();
			}
		});
		Util.AddClickEvent(this._img, () => {
			if (this.canGet) {
				this._model.Fire(CompeteListEvent.REQUEST_PROTO, 33804, "hhh", this._type, this._sub_type, this._data.reward_id)
			} else {
				let list = JSON.parse(this._data.reward);
				let viewdata = this._model.CompeteViewData[this._type + "@" + this._sub_type];
				let world_lv = 0;
				if (viewdata) {
					world_lv = viewdata.world_lv;
				}
				if (this._data.format == 1) {
					let cfg_list = JSON.parse(this._data.reward);
					for (let key in cfg_list) {
						let reward_cfg = cfg_list[key]
						if (world_lv < reward_cfg[0]) {
							break;
						}
						list = reward_cfg[1];
					}
				}

				if (!this._stage_show) {
					this._stage_show = new StageShowView();
				}
				this._stage_show.Open(list, this._img, StageShowView.ShowArrow.CENTERED);
			}
		}, this, true);

	}



	public DeleteMe() {
		this._data = null
		if (this._stage_show) {
			this._stage_show.Close();
			this._stage_show = null;
		}
		super.DeleteMe();
	}



	public LoadSuccess() {
		this.initView();
		this.initImg();
	}

	public setData(data?, type?, sub_type?) {
		this._data = data;
		this._type = type;
		this._sub_type = sub_type;
		if (this.is_loaded) {
			this.initView();
		}

	}



	public setIndex(index?) {
		this._index = index
		if (this.is_loaded) {
			this.initImg();
		}

	}



	public initView() {
		if (!this._data) {
			return;
		}
		this.checkGet();
		this._lb_integral.text = this._data.need_val + '积分'
	}



	public initImg() {
		if (!this.is_loaded || this._index == null) {
			return;
		}
		let imgStr = 'ui_sm_024-2';

		if (this._index >= 2 && this._index < 6) {

			imgStr = 'ui_sm_023';

		} else if (this._index >= 6) {

			imgStr = 'ui_sm_022';

		}

		ResManager.GetInstance().SetImageSpriteTrans(this, this._img, GameResPath.GetIcon("competelist", imgStr), true);

	}



	public checkGet() {
		let flag = false;
		let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type];
		if (viewData) {
			let hasGet = false;
			for (let _tmpi in viewData.stage_list) {
				var info = viewData.stage_list[_tmpi];
				if (info.id == this._data.reward_id) {
					hasGet = info.got_type == 2;
					break;
				}
			}
			this.canGet = !hasGet && viewData.today_score >= this._data.need_val;
			this._red_dot.visible = this.canGet;
			this._img_get.visible = hasGet;
			this._lb_integral.color = this.canGet || hasGet ? '#B03030' : '#611E65';
			ResManager.GetInstance().SetImageSpriteTrans(this, this.bgImg, GameResPath.GetIcon("competelist", (this.canGet || hasGet ? 'ui_sm_024' : 'ui_sm_025')));
		}
	}


	bgImg: Laya.Image
	_img: Laya.Image
	_lb_integral: Laya.Label
	_red_dot: Laya.Image
	_img_get: Laya.Image
	public GetComponents() {
		[
			this.bgImg,
			this._img,
			this._lb_integral,
			this._red_dot,
			this._img_get,
		]
			= this.GetChildrenByNames([

				"bgImg",
				"_img",
				"_lb_integral",
				"_red_dot",
				"_img_get",
			])
	}
}
window["CompetelistIntegralItem"] = CompetelistIntegralItem