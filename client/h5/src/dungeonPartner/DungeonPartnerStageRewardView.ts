import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

export class DungeonPartnerStageRewardView extends BaseView1 {



	need_refresh_data
	model: DungeonPartnerModel
	res_mgr: ResManager
	item_list = []
	data
	public constructor() {
		super()

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerStageRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background2 = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		this.is_center = true

		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_partner_dun_chapter": false
		}

		this.load_callback = () => {
			this._panel_reward.hScrollBarSkin = ""
			this.InitEvent()
			if (this.need_refresh_data) {
				this.UpdateView()
				this.need_refresh_data = null
			}
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public InitEvent() {
		let onClickBtnHandler = (e) => {
			if (e.target == this._img_close) {
				this.Close()
			}
		}
		Util.AddClickEvent(this._img_close, onClickBtnHandler, this, true)
	}

	public Open(data?) {
		this.data = data
		this.UpdateView()
		super.Open()
	}

	//data:  {level, stage_info = [score, status]]
	public UpdateView() {

		if (!this.is_loaded) {
			this.need_refresh_data = true
			return
		}
		let stage_info = this.data.stage_info
		this._lb_tip.visible = 0 == stage_info.status  //未领取
		this._lb_title.text = stage_info.score + "星奖励"
		this._lb_tip.text = `本局总星数达到${stage_info.score}星即可领取`


		let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_partner_dun_chapter", false)
		let stage_reward = ErlangParser.GetInstance().Parse(cfgs[this.data.level].stage_reward)
		let goods_model = GoodsModel.GetInstance()
		let reward_list = []
		for (let _ = 0; _ < stage_reward.length; _++) {
			let v = stage_reward[_]
			if (Number(v[0]) == stage_info.score) {
				reward_list = v[1]
			}
		}
		let item, v
		for (let i = 0; i < reward_list.length; i++) {
			v = reward_list[i]
			item = this.item_list[i]
			if(!item){
				item = new EquipmentItem(this._panel_reward)
				item.Load()
				this.item_list[i] = item
			}
			item.SetItemSize(87, 87)
			item.SetPosition(i * 90, 0)
			let [type_id, lock] = goods_model.GetMappingTypeId(v[0], v[1])
			let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				item.SetData(goods_vo.type_id, v[2], lock)
				item.SetVisible(true)
			}
		}
	}

	public Clear() {
		for (let i = 0; i < this.item_list.length; i++) {
			let v = this.item_list[i]
			v.DeleteMe()
		}
		this.item_list.length = 0
	}


	_img_bg: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_img_close: Laya.Image
	_img_tip: Laya.Image
	_lb_tip: Laya.Label
	_panel_reward: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._lb_title,
			this._img_close,
			this._img_tip,
			this._lb_tip,
			this._panel_reward,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_lb_title",
				"_img_close",
				"_img_tip",
				"_lb_tip",
				"_panel_reward",
			])
	}
}
window["DungeonPartnerStageRewardView"] = DungeonPartnerStageRewardView