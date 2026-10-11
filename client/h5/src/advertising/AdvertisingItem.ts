import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { WelfareModel } from "../commonModel/WelfareModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class AdvertisingItem extends BaseItemRenderer {


	WIDTH = 692
	HEIGT = 144

	model: CustomActivityModel
	data
	item_list = []
	cd_time
	count_time_id

	public constructor() {
		super()
		this.base_file = "advertising"
		this.layout_file = "AdvertisingItem"
		this.model = CustomActivityModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		//resource/game/advertising/other/ui_fllb_05.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("advertising", "ui_fllb_05"))

		this._panel_item.hScrollBarSkin = ""
		let txt1 = "点击观看"
		let txt2 = "领取"
		let txt3 = "冷却中"

		this._lb_look.text = txt1
		this._img_get.text = txt2
		this._lb_cool.text = txt3
		this.InitEvent()
	}

	public DeleteMe() {

		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
			}
		}
		this.item_list.length = 0
		this.CancelTimer()
		this.cd_time = null
	}

	public InitEvent() {

		let update_fun = () => {
			if (this.use_delete_method) { return }
			this.dataChanged()
		}
		this.BindEvent(this.model, CustomActivityDefine.EVENT.UPDATE_ADVERTISING_CD, update_fun)
		this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, update_fun)

		Util.AddClickEvent(this._box_look, () => {
			if (this.data) {
				WelfareModel.GetInstance().PlayActivityAd(this.data.grade)
			}
		}, this, true)

		Util.AddClickEvent(this._box_get, () => {
			if (this.data) {
				if (this.data.status == 1) {
					this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.data.base_type, this.data.sub_type, this.data.grade)
				}
			}
		}, this, true)

		Util.AddClickEvent(this._box_cool, () => {
			Message.show("广告正在冷却中")
		}, this, true)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				let txt = "完整观看广告可领取奖励"

				this._lb_desc.text = txt
				let rewards = this.model.GetActReward(this.data.base_type, this.data.sub_type, this.data.form_type, this.data.reward)
				this.UpdateItems(rewards)
				this.SetBtnState()
			}
		}
	}

	public SetBtnState() {
		if (this.data) {
			this.CancelTimer()
			this._box_look.visible = this.data.status != 1
			this._box_get.visible = this.data.status == 1
			if (this.data.status == 1) { 	//可领取
				this._box_look.visible = false
				this._box_get.visible = true
				this._box_cool.visible = false
				this._img_has_get.visible = false
			} else {
				if (this.data.status == 2) { 	//已领取
					this._box_look.visible = false
					this._box_get.visible = false
					this._box_cool.visible = false
					this._img_has_get.visible = true
				} else {
					let is_in_cd = this.model.AdvertisingIsInCd(this.data.grade)
					if (is_in_cd) { //cd中
						this._box_look.visible = false
						this._box_get.visible = false
						this._box_cool.visible = true
						this._img_has_get.visible = false
						this.StartTimer()
					} else {
						this._box_look.visible = true
						this._box_get.visible = false
						this._box_cool.visible = false
						this._img_has_get.visible = false
					}
				}
			}
		}
	}

	public StartTimer() {

		this.CancelTimer()
		if (this.data) {
			this.cd_time = this.model.GetAdvertisingCdById(this.data.grade)
			if (this.cd_time) {
				let time_fun = () => {
					this.OnTime()
				}
				this.count_time_id = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
				this.OnTime()
			}
		}
	}

	public OnTime() {
		if (this.cd_time) {
			let left_time = this.cd_time - TimeUtil.getServerTime()
			if (left_time <= 0) {
				let txt = "冷却中"
				this._lb_cool.text = txt
				this.dataChanged()
			} else {
				let txt = `冷却(${left_time}s)`
				this._lb_cool.text = txt
			}
		} else {
			this.CancelTimer()
		}
	}

	public CancelTimer() {
		if (this.count_time_id) {
			GlobalTimerQuest.CancelQuest(this.count_time_id)
			this.count_time_id = null
		}
	}

	public UpdateItems(list?) {

		for (let i = 0; i < list.length; i++) {
			let info = list[i]
			let item = this.item_list[i]
			if (!item) {
				item = new EquipmentItem(this._panel_item)
				item.SetItemSize(75, 75)
				item.Load()
				this.item_list[i] = item
			}
			let [type_id, is_lock] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			item.SetData(type_id, info[2])
			item.SetVisible(true)
		}

		for (let i = list.length; i < this.item_list.length; i++) {
			this.item_list[i].SetVisible(false)
		}

	}


	_img_bg: Laya.Image
	_lb_desc: Laya.Label
	_panel_item: Laya.Panel
	_img_has_get: Laya.Image
	_box_look: Laya.Box
	_lb_look: Laya.Label
	_box_get: Laya.Box
	_img_get: Laya.Label
	_img_get_red: Laya.Image
	_box_cool: Laya.Box
	_lb_cool: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._panel_item,
			this._img_has_get,
			this._box_look,
			this._lb_look,
			this._box_get,
			this._img_get,
			this._img_get_red,
			this._box_cool,
			this._lb_cool,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_panel_item",
				"_img_has_get",
				"_box_look",
				"_lb_look",
				"_box_get",
				"_img_get",
				"_img_get_red",
				"_box_cool",
				"_lb_cool",
			])
	}
}
window["AdvertisingItem"] = AdvertisingItem