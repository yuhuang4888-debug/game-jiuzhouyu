import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { AdventureModel } from "../commonModel/AdventureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetLocalScale } from "../util/Util"

export class AdventureItem extends BaseItem1 {
	cfg
	item
	model
	re_box_pro_list



	public constructor(parent?) {
		super(parent)
		this.model = AdventureModel.GetInstance();
		this.re_box_pro_list = [];
		this.base_file = "adventure"
		this.layout_file = "AdventureItem"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {
			this.InitEvent()
		}
		this.preload_server_config = {
			"config_adventure_reward": false,
			"config_adventure_kv": false
		}
	}

	public InitEvent() {
		this.BindEvent(AdventureModel.GetInstance(), AdventureModel.OPEN_BOX, (location?, goods?, crit?) => {
			if (!this.cfg) {
				return
			}
			if (this.cfg.location == location) {
				this.RefStatus(true)
				let goods_model = GoodsModel.GetInstance()
				for (let i in goods) {
					let v1 = goods[i]
					let [type, lock] = goods_model.GetMappingTypeId(v1[0], v1[1])
					let basic = goods_model.GetGoodsBasicByTypeId(type)
					if (basic) {
						let goods_list = [v1]
						let localPos = this._item.localToGlobal(new Laya.Point(0, 0)) //UILocalToCanvasPoint(this._item, co.TableXY(0, 1), co.TableXY(0, 1))
						GlobalEventSystem.Fire(EventName.REWARD_FLY, goods_list, { x: localPos.x, y: localPos.y }, null, Enum_UILayer.Activity, -50, 300, 900)
						let color = ColorUtil.GetColorLight(basic.color)
						Message.show("获得<font color=" + color + ">" + basic.goods_name + "x" + v1[2] + "</font>")
					}
				}
				if (crit == 2) {
					this.AddUIEffect("UI_yjtb_01", this._gp_crit, undefined, 10, false,1,undefined,undefined,undefined,undefined,undefined,undefined,false)
				}
			}
		}
		)
	}

	public InitView() {
		if (!this.cfg) {
			return
		}
		let index = this.cfg.location
		let info = this.model.GetViewInfo()
		if (!info) {
			return
		}
		let is_get = (index <= info.location && (true) || (false))
		this._box.visible = true
		this.RefStatus(is_get)
	}

	public RefStatus(is_get?) {
		if (this.re_box_pro_list.length > 0) {
			for (let _tmpi in this.re_box_pro_list) {
				var item = this.re_box_pro_list[_tmpi]
				item.visible = true
			}
		}
		if (!this.cfg && !this.is_loaded) {
			return
		}
		let type = this.cfg.type
		let config_adventure_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_kv", false)
		let box_type = this.model.GetBoxType(type, config_adventure_kv)
		let bg_url = "uittmx_002a"
		let box_url = "box_1"
		let box_bool = true
		let box_scale = 1
		if (box_type) {
			if ("com" == box_type) {
				box_url = (is_get && ("box_1_1") || ("box_1"))
				box_scale = box_scale * 0.6
				this._box.x = 35
			} else if ("high" == box_type) {
				box_scale = box_scale * 0.7
				bg_url = "uittmx_002b"
				box_url = (is_get && ("box_2_1") || ("box_2"))
				this._box.y = -30
			} else if ("ultimate" == box_type) {
				box_url = "box_3"
				this._box.height = 97
				this._box.width = 124
				this._box.x = 0
				this.InitReward(this.cfg.stage, type)
			} else if ("special" == box_type) {
				let config_adventure_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_reward", false)
				let reward = this.model.GetBoxCfg(this.cfg.stage, this.cfg.type, config_adventure_reward)
				this._item.visible = (is_get && (false || (true)))
				if (!is_get) {
					if (!this.item) {
						this.item = new EquipmentItem(this._item)
						this.item.Load()
						this.item.SetItemSize(67, 67)
					}
					this.item.ExcuteCallback(() => {
						if (!reward) {
							return
						}
						reward = reward[0]
						let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
						this.item.SetData(type_id, reward[2], lock)
					}
					)
				}
			}
		}
		this._box.visible = box_bool
		ResManager.GetInstance().SetImageSprite(this, this._box, "adventure_asset", box_url)
		this._box.scaleX = box_scale
		this._box.scaleY = box_scale
	}

	public InitReward(stage?, box_type?) {
		let config_adventure_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_reward", false)
		let reward = this.model.GetBoxCfg(this.cfg.stage, this.cfg.type, config_adventure_reward)
		for (let i in reward) {
			let item = this.re_box_pro_list[i]
			if (!item) {
				item = new EquipmentItem(this._reward_proview)
				item.Load()
				item.SetItemSize(80, 80)
				table.insert(this.re_box_pro_list, item)
			}
			item.ExcuteCallback(() => {
				item.visible = true
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[i][0], reward[i][1])
				item.SetData(type_id, reward[i][2], lock)
			}
			)
		}
	}



	public SetDate(...new_args) {
		let args = new_args
		if (args) {
			this.cfg = args[0]
		}
		this.InitView()
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.re_box_pro_list.length > 0) {
			for (let _tmpi in this.re_box_pro_list) {
				var item = this.re_box_pro_list[_tmpi]
				item.DeleteMe()
			}
			this.re_box_pro_list = []
		}
		super.DeleteMe()
	}
	_bg: Laya.Image
	_box: Laya.Image
	_item: Laya.Box
	_reward_proview: Laya.HBox
	_gp_crit: Laya.Box
	public GetComponents() {
		[
			this._bg,
			this._box,
			this._item,
			this._reward_proview,
			this._gp_crit
		]
			= this.GetChildrenByNames([

				"_bg",
				"_box",
				"_item",
				"_reward_proview",
				"_gp_crit"
			])
	}
}
window["AdventureItem"] = AdventureItem