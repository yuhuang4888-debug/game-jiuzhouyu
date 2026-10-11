import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SnatchTreasureIntegralItem } from "./SnatchTreasureIntegralItem"

export class SnatchTreasureView extends BaseItem1 {

	InitEvent
	LoadSuccess
	LocalDeleteMe
	_Scroller1
	initView
	item_list
	loop_mgr

	public constructor(parent?) {
		super(parent)

		this.base_file = "snatchTreasure"
		this.layout_file = "SnatchTreasureView"
		let _model = SnatchTreasureModel.GetInstance()
		let local_SnatchTreasureModel = SnatchTreasureModel
		let local_ResManager = ResManager.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
			// 	SetAnchoredPositionX(this._Label2,130)
			// 	SetAnchoredPositionX(this._Label4,130)
			// 	this._Label4.lineSpacing = 1
			// }
			this.InitEvent()
			this.LoadSuccess()
		}
		this.preload_server_config = {
			"config_territory_kv": false
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn, () => {
				_model.Fire(local_SnatchTreasureModel.SCMD_REQUEST, 65202)
			}
				, this, true)
			this.BindEvent(_model, local_SnatchTreasureModel.DUN_DATA_RETURN, () => {
				this.initView()
			}
			)
			_model.Fire(local_SnatchTreasureModel.SCMD_REQUEST, 65201)
		}

		this.LocalDeleteMe = () => {
			if (this.item_list) {
				for (let _ in this.item_list) {
					var v = this.item_list[_]
					v.DeleteMe()
				}
				this.item_list = null
			}
		}

		this.LoadSuccess = () => {
			//local_ResManager.SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("snatchTreasure", "uisydb_007"),true)
			local_ResManager.SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("snatchTreasure", "ui_holyland_26a"))
		}

		this.initView = () => {
			let territory_kv_cfg = local_ResManager.GetGameConfigFromCache(this, "config_territory_kv", false)
			// let cfg = _model.getKvConfig(1, territory_kv_cfg)
			// // [ts2lua]lua中0和空字符串也是true，此处cfg需要确认
			// let list = (cfg && (JSON.parse(cfg.value)) || ({}))
			// table.insert(list, [null])
			// list = table.reverse(list)


			//this._integral_list.dataProvider = eui. new ArrayCollection(list)
			//this._integral_list.itemRenderer = SnatchTreasureIntegralItem
			let list
			let dungeon_data = _model._dunData
			if (dungeon_data) {
				list = dungeon_data.belong_list
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, SnatchTreasureIntegralItem, list, LoopScrCon.Vertical)
			}



			//this._lb_integral.text = "(异域积分:" + _model._dunData.territory_score + ")"
			let reward_list = _model.getRewardList(territory_kv_cfg)
			if (!this.item_list) {
				this.item_list = []
			}
			for (let key in reward_list) {

				// [ts2lua]reward_list下标访问可能不正确
				let type_id = reward_list[key]

				let item = this.item_list[key]
				if (!item) {
					item = new EquipmentItem(this._gp_reward)
					item.SetScale(0.7)
					item.Load()
					this.item_list[key] = item
				}
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id)
					item.SetStrengthen(goods_vo.stren)
				}
			}
		}

	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}



	_Image1: Laya.Image
	_img_title: Laya.Image
	_btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Group1: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Group2: Laya.Box
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Group3: Laya.Box
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	_gp_reward: Laya.HBox
	_Label6: Laya.Label
	_lb_integral: Laya.Label
	Content: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._img_title,
			this._btn,
			this._Image11,
			this.labelDisplay,
			this._Group1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Group2,
			this._Label1,
			this._Label2,
			this._Group3,
			this._Label3,
			this._Label4,
			this._Label5,
			this._gp_reward,
			this._Label6,
			this._lb_integral,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_title",
				"_btn",
				"_Image11",
				"labelDisplay",
				"_Group1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Group2",
				"_Label1",
				"_Label2",
				"_Group3",
				"_Label3",
				"_Label4",
				"_Label5",
				"_gp_reward",
				"_Label6",
				"_lb_integral",
				"Content",
			])
	}
}
window["SnatchTreasureView"] = SnatchTreasureView