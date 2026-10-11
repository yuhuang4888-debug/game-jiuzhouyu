import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { FtvExchangeGoodItem } from "./FtvExchangeGoodItem"

export class FtvExchangeItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_img_top: Laya.Image
	_lb_name: Laya.Label
	_gp_reward: Laya.Box
	_gp_goods: Laya.HBox
	_gp_btn: Laya.Box
	_Image1: Laya.Image
	_lb_exc_num: Laya.Label
	_img_drawed: Laya.Image
	_img_rare: Laya.Image
	goods: Laya.Box
	Emp_gp_btn
	base_type
	cost
	data
	goods_item
	needRefresh
	reward_item
	show_id
	sub_type

	public static width = 201 + 30
	public static height = 303 + 10
	WIDTH = 230
	HEIGT = 315

	public constructor(parent?) {
		super()

		this.data = null
		this.reward_item = null
		this.cost = null
		this.needRefresh = true
		this.base_type = null
		this.sub_type = null
		this.show_id = null
		this.goods_item = []
		this.base_file = "ftvExchange"
		this.layout_file = "FtvExchangeItem"

		this.load_callback = () => {

			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {


		let btn_callback = () => {
			let lv = RoleManager.GetInstance().GetMainRoleLevel()
			for ( let key in this.data.condition){
				if(this.data.condition[key][0] =="role_lv"  ){
					if(this.data.condition[key][1] > lv){
						Message.show("等级不够")
						return
					}
				}
				if(this.data.condition[key][0] == "batchget"){
					if(this.data.condition[key][1] == 1 ){
						this.data["base_type"] = this.base_type
						this.data["sub_type"] = this.sub_type
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "FtvExchangeTips", this.data)
						return
					}
				}
			}
			
			if (this.data.status == 2) {
				Message.show("兑换次数已用完")
				return
			}
			for (let i in this.cost) {

				let num = GoodsModel.GetInstance().GetTypeGoodsNum(this.cost[i][1])
				if (num < Number(this.cost[i][2])) {
					Message.show("物品不足，无法兑换")
					return
				}
			}
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.base_type, this.sub_type, this.data.grade)
		}
		Util.AddClickEvent(this._gp_btn, btn_callback, this, true)

		let updata_goods = (list?) => {
			if (this.use_delete_method) {
				return
			}
			this.UpdataGoodItem(this.data)
			this.UpdataBtnLabel()
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, updata_goods)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			this.base_type = this.data.base_type
			this.sub_type = this.data.sub_type
			this.show_id = this.data.show_id
			if (this.needRefresh) {
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
				if (cfg) {
					this.needRefresh = false
					CustomActivityModel.GetInstance().LoadCompontRes(this, cfg, "FtvExchangeItem", this.show_id)
				}
			}
			let reward = CustomActivityModel.GetInstance().GetActReward(this.base_type, this.sub_type, data.form_type, data.reward)
			if (typeof (data.condition) == "string") {
				data.condition = ErlangParser.GetInstance().Parse(data.condition)
			}

			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this._lb_name.text = (basic && (basic.goods_name) || (""))
			if (!this.reward_item) {
				this.reward_item = new EquipmentItem(this._gp_reward)
				this.reward_item.Load()
				this.reward_item.SetItemSize(85, 85)
			}
			this.reward_item.ExcuteCallback(() => {
				this.reward_item.SetData(type_id, reward[0][2])
			}
			)
			this.UpdataGoodItem(data)
			this.UpdataBtnLabel(data.receive_times)
		}

	}

	public UpdataGoodItem(data?) {


		for (let i in data.condition) {

			if (data.condition[i][0] == "cost") {
				if (this.goods_item.length > 0) {
					for (let k in this.goods_item) {
						var vo = this.goods_item[Number(k)]
						vo.SetVisible(false)
					}
				}

				this.cost = data.condition[i][1]
				for (let j in data.condition[i][1]) {

					let item = this.goods_item[Number(j)]
					if (!item) {
						item = new FtvExchangeGoodItem(this._gp_goods)
						item.Load()
						table.insert(this.goods_item, item)
					}
					item.ExcuteCallback(() => {
						item.SetData(data.condition[i][1][j], true)
						item.SetVisible(true)
					}
					)
				}
			}
			if (data.condition[i][0] == "rare") {
				let rare_asset = "common_asset"
				let rare_url = "com_empty"
				if (data.condition[i][1] != "0") {
					rare_asset = "ftvExchange_asset"
					rare_url = (data.condition[i][1] == "1") && "uihd_czhl_005" || "uihd_czhl_004"
				}
				ResManager.GetInstance().SetImageSprite(this, this._img_rare, rare_asset, rare_url, true)
			}
		}
	}

	public UpdataBtnLabel(count?) {

		if (!count && count != 0) {
			count = -1
		}
		count = Number(count)

		let times = null
		this._img_drawed.visible = false
		this._gp_btn.visible = true
		if (count >= 0) {
			for (let i in this.data.condition) {

				if (this.data.condition[i][0] == "exchang_times") {
					times = this.data.condition[i][1]
					break
				}
			}
			this._lb_exc_num.text = "兑换" + ((Number(times) - count)) + "/" + times
			if ((Number(times) - count) == 0) {
				this._gp_btn.visible = false
				this._img_drawed.visible = true
				return
			}
		}
		if (this.data.status == 2) {
			this._gp_btn.visible = false
			this._img_drawed.visible = true
			return
		}
		for (let i in this.cost) {

			let num = GoodsModel.GetInstance().GetTypeGoodsNum(this.cost[i][1])
			if (num < Number(this.cost[i][2])) {
				return
			}
		}
	}

	public DeleteMe() {


		if (this.reward_item) {
			this.reward_item.DeleteMe()
			this.reward_item = null
		}

		if (this.goods_item.length > 0) {
			for (let _tmpi in this.goods_item) {
				var item = this.goods_item[_tmpi]
				item.DeleteMe()
			}
			this.goods_item = []
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_top,
			this._lb_name,
			this._gp_reward,
			this._gp_goods,
			this._gp_btn,
			this._Image1,
			this._lb_exc_num,
			this._img_drawed,
			this._img_rare,
			this.goods
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_top",
				"_lb_name",
				"_gp_reward",
				"_gp_goods",
				"_gp_btn",
				"_Image1",
				"_lb_exc_num",
				"_img_drawed",
				"_img_rare",
				"goods"
			])
	}
}
window["FtvExchangeItem"] = FtvExchangeItem