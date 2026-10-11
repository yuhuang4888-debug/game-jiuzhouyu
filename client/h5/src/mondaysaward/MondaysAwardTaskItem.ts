import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MondaysAwardModel, MondaysAwardEvent } from "../commonModel/MondaysAwardModel"
import { AdModuleId, WelfareModel } from "../commonModel/WelfareModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class MondaysAwardTaskItem extends BaseItemRenderer {
	Emp_btn
	Emp_btn_get
	_bg
	_btn
	_btn_get
	_btn_get_label
	_btn_label
	_gp_reward
	_img_get
	_lb_desc
	_lb_num
	_red_dot
	_model
	local_MondaysAwardEvent
	item
	state_
	public WIDTH = 315
	public HEIGT = 100

	public constructor(parent) {
		super()


		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardTaskItem"

		this._model = MondaysAwardModel.GetInstance()
		this.local_MondaysAwardEvent = MondaysAwardEvent
		this.item = null
		this.state_ = 0 //0 未完成 1已完成未领取 2 已领取
		this.Load()
	}

	public LoadSuccess() {
		Util.AddClickEvent(this._btn, () => {
			if(this.data.id == (1000 + AdModuleId.MondayReward)){
				let ad_cfg = WelfareModel.GetInstance().GetAdCfg(AdModuleId.MondayReward)
				if(ad_cfg){
					// WelfareModel.GetInstance().PlayAdAlert(ad_cfg, "观看完影片可领取一张周一抽奖券！")
					WelfareModel.GetInstance().PlayAd(ad_cfg)
				}
			}
			else{
				OpenFun.OpenFunHandler(this.data.jump_id)
			}
		}, this, true)

		Util.AddClickEvent(this._btn_get, () => {
			this._model.Fire(this.local_MondaysAwardEvent.REQUEST_PROTO, 17906, "h", this.data.id)
		}, this, true)

		this.BindEvent(this._model, this.local_MondaysAwardEvent.GET_TASK_RETUEN, () => {
			this.updateBtn()
		}
		)
		ResManager.GetInstance().SetImageSpriteTrans(this, this._bg, GameResPath.GetIcon("mondaysaward", "uizydj_004"))
	}

	public Local_DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.is_loaded) {
				this._lb_desc.text = this.data.desc
				let reward = JSON.parse(this.data.reward)
				if (reward && reward[0]) {
					if (!this.item) {
						this.item = new BaseAwardItem(this._gp_reward)
						this.item.Load()
						this.item.SetScale(0.3)
					}
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
					this.item.SetData(type_id)
					this._lb_num.text = "X" + reward[0][2]
				}
				this.updateBtn()
			}
		}
	}

	public updateBtn() {
		if (this.data != null) {
			if(this.data.id == (1000 + AdModuleId.MondayReward)){
				this._btn_get.visible = false
				this._red_dot.visible = false
				//观看广告
				let look_state = WelfareModel.GetInstance().GetAdLookStateByMoudleId(AdModuleId.MondayReward)
				if(look_state){
					this._img_get.visible = true
					this._btn.visible = false
				}else{
					this._img_get.visible = false
					this._btn.visible = true
				}

			}else{	
				let state_data = this._model.getTaskDataById(this.data.id)
				if (state_data) {
					this.state_ = state_data.state
				} else {
					this.state_ = 0
				}
				this._btn.visible = this.state_ == 0
				this._btn_get.visible = this.state_ == 1
				this._red_dot.visible = this.state_ == 1
				this._img_get.visible = this.state_ == 2
			}

			
		}
	}

	public load_callback() {
		this.LoadSuccess()
	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_Image11: Laya.Image

	public GetComponents() {
		[
			this._bg,
			this._gp_reward,
			this._lb_desc,
			this._lb_num,
			this._btn,
			this._Image1,
			this._btn_label,
			this._btn_get,
			this._Image11,
			this._btn_get_label,
			this._img_get,
			this._red_dot,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_gp_reward",
				"_lb_desc",
				"_lb_num",
				"_btn",
				"_Image1",
				"_btn_label",
				"_btn_get",
				"_Image11",
				"_btn_get_label",
				"_img_get",
				"_red_dot",
			])
	}
}
window["MondaysAwardTaskItem"] = MondaysAwardTaskItem