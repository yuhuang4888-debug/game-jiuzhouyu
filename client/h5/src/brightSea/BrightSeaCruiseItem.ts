import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { GlobalTimerQuest, PlayBigEffect } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class BrightSeaCruiseItem extends BaseItemRenderer {
	Dispose
	LoadSuccess
	goods_model
	has_set_cover
	model
	model_res
	play_timer_id
	reward_item_list
	reward_item_list_
	role_mgr
	select_timer_id

	public WIDTH = 420
	public HEIGT = 135

	public constructor(parent) {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaCruiseItem"
		this.model = BrightSeaModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.reward_item_list_ = null
		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {

		}

		this.Dispose = () => {
			if (this.reward_item_list_) {
				for (let _ in this.reward_item_list_) {
					var item = this.reward_item_list_[_]
					item.DeleteMe()
					item=null
				}
				this.reward_item_list = null
			}
			if (this.play_timer_id) {
				GlobalTimerQuest.CancelQuest(this.play_timer_id)
				this.play_timer_id = null
			}

			if (this.select_timer_id) {
				GlobalTimerQuest.CancelQuest(this.select_timer_id)
				this.select_timer_id = null
			}


			this.base_item.ClearUIEffect(this._con_levelup_eff)
			this.base_item.ClearUIEffect(this._con_levelup_eff2)
			this.base_item.ClearUIEffect(this._con_select_eff)
			ResManager.GetInstance().ClearRoleMode(this.base_item.hashCode)

		}


		this.Load()
	}

	public DeleteMe() {

		this.Dispose()

		super.DeleteMe()
	}

	public InitEvent() {

		this.BindEvent(this.model, BrightSeaEvent.LEVELUP_SHIP, (cur_anim_ship_id?, new_ship_id?) => {
			if (this.data) {
				if (this.data.id == cur_anim_ship_id) {
					this.PlayLevelupAnimation()
				}
				this.UpdateSelected(this.data.id == cur_anim_ship_id)

				if (this.select_timer_id) {
					GlobalTimerQuest.CancelQuest(this.select_timer_id)
					this.select_timer_id = null
				}

				this.select_timer_id = GlobalTimerQuest.AddDelayQuest(() => {
					this.UpdateSelected(this.data.id == new_ship_id)
				}, 1)

			}
		})
	}

	public LoadModel(model_res?) {

		if (!this.model_res && this.model_res == model_res) {
			return
		}
		let data = {
			type: UI_MODEL_TYPE.MONSTER,
			clothe_res_id: model_res,
			layer_value: null,
			scale: 1,
			texture_id:this.model.GetModelShipTextureId(model_res),
			fashion_model_id: model_res,
			rotate: 125,
			//mask_id: 1,
			skin_renderQueue: 2000,
			can_rotate: false,
		}
		ResManager.GetInstance().SetRoleModel(this.base_item, this._con_model, data)

		if (!this.has_set_cover) {
			//this:CoverMode(this._con_chip, this.layer_value, this.curr_sorting_order)
			//this:CoverMode(this._con_eff2, this.layer_value, curr_sorting_order)
			//this:CoverMode(this._con_eff3, this.layer_value, curr_sorting_order)
			this.has_set_cover = true
		}

		this.model_res = model_res
	}

	public PlayLevelupAnimation() {

		if (this.play_timer_id) {
			GlobalTimerQuest.CancelQuest(this.play_timer_id)
			this.play_timer_id = null
		}
		// this.base_item.AddUIEffect("ui_boat_upgrade02", this._con_levelup_eff, null, 1, false)
		// this.base_item.AddUIEffect("ui_boat_upgrade03", this._con_levelup_eff2, null, 1, false)

		PlayBigEffect("ui_shengjitexiao")
	}

	public dataChanged() {

		if (!super.dataChanged()) return
		// 1为蓝色
		let color = ColorUtil.GetColorLight(this.data.id + 1)
		this._lb_name.color = ColorUtil.GetReplaceChar(color)
		this._lb_name.text = this.data.name
		//lua_resM:SetImageSprite(this, this._img_ship, "brightSea_asset", "ship_" + this.data.id)

		let res_name = this.model.GetModelResByShipId(this.data.id)
		this.LoadModel(res_name)

		let reward_tb
		if (this.data.is_ser_data) {
			reward_tb = GoodsModel.RewardKeyToNumber(this.data.reward)
		} else {
			reward_tb = ErlangParser.GetInstance().parse(this.data.reward)
		}
		let exp_cnt = Mathf.Pow(1.5, ((this.role_mgr.GetMainRoleLevel() - 60) / 120)) * 174679200 * this.data.exp_ratio
		exp_cnt = Mathf.Round(exp_cnt)
		table.insert(reward_tb,
			{
				"0": 0,
				"1": 32,
				"2": exp_cnt
			}
		)


		if (!this.reward_item_list_) {
			this.reward_item_list_ = []
		}

		// let index = 0
		// for (let key in reward_tb) {

		// 	let vo = reward_tb[key]
		// 	let ret = this.model.LoadAndRefreshAwardItem(vo, this._Content, this.reward_item_list_, index)
		// 	if (ret ) {
		// 		index = index + 1
		// 	}
		// }

		for (let index in reward_tb) {
			var vo = reward_tb[index]
			let item = this.reward_item_list_[index]
			if (!item) {
				item = new BaseAwardItem(this._Content, null, "Activity")
				item.Load()
				item.SetVisible(true)
				table.insert(this.reward_item_list_, item)
				item.ExcuteCallback(() => {
					item.SetItemSize(87, 87)
				})
			}
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				item.SetData(goods_vo.type_id, vo[2], lock)
			}
		}


		this.UpdateSelected(this.selected)
	}

	public UpdateSelected(select_status?) {

		this._con_selected.visible = select_status == true
		this._selected_bg2.visible = select_status == true
		this._con_select_eff.visible = select_status == true

		if (select_status) {
			//this.base_item.AddUIEffect("ui_boat_upgrade01", this._con_select_eff, null, null, true)
		} else {
			this.base_item.ClearUIEffect(this._con_select_eff)
		}
	}




	_bg: Laya.Image
	_con_select_eff: Laya.Box
	_con_levelup_eff: Laya.Box
	_con_levelup_eff2: Laya.Box
	_con_root: Laya.Box
	_con_selected: Laya.Box
	_selected_frame: Laya.Image
	_selected_bg2: Laya.Image
	_Content: Laya.HBox
	_con_model: Laya.Box
	_con_chip: Laya.Box
	_name_bg: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._bg,
			this._con_select_eff,
			this._con_levelup_eff,
			this._con_levelup_eff2,
			this._con_root,
			this._con_selected,
			this._selected_frame,
			this._selected_bg2,
			this._Content,
			this._con_model,
			this._con_chip,
			this._name_bg,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_con_select_eff",
				"_con_levelup_eff",
				"_con_levelup_eff2",
				"_con_root",
				"_con_selected",
				"_selected_frame",
				"_selected_bg2",
				"_Content",
				"_con_model",
				"_con_chip",
				"_name_bg",
				"_lb_name",
			])
	}
}
window["BrightSeaCruiseItem"] = BrightSeaCruiseItem