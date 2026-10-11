import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class UnrealDismantleView extends BaseView1 {


	color_list

	InitEvent
	LoadSuccess
	SetData
	Remove
	UpdateView
	public constructor() {
		super()
		this.base_file = "unreal"
		this.layout_file = "UnrealDismantleView"
		this.layer_value = Enum_UILayer.Activity
		let model = UnrealModel.GetInstance(),
			local_Util = Util,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			res_mgr = ResManager.GetInstance(),
			ui_tool_tip_mgr = UIToolTipMgr.GetInstance(),
			PRELOAD_SERVER_CONFIG_ = {
				config_decoration_kv: null,
				config_goods_decompose: null
			},
			item_list_,
			data_,
			cache_reward_
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.load_callback = function () {
			this.LoadSuccess()
		}

		this.close_callback = function () {
			this.Remove()
		}

		this.InitEvent = () => {

			local_Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._gp_com, () => {
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._gp_dismantle, () => {
				if (data_) {
					goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, [{ goods_id: data_.goods_id, goods_num: 1 }])
				}
			}, this, true)

			this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				if (cache_reward_) {
				// 	for (let obj of cache_reward_) {
				// 		let goods_vo = goods_model.GetGoodsBasicByTypeId(obj[1])
				// 		if (goods_vo) {
				// 			let color = ColorUtil.GetColorLight(goods_vo.color)
				// 			Message.show(`获得<font color=${color}>${goods_vo.goods_name} x${obj[2]}</font>`)
				// 		}
				// 	}
					cache_reward_ = undefined
				this.Close()
				}
			})
		}

		this.LoadSuccess = async () => {
			this._Scroller1.hScrollBar.visible = false
			for (let config_name in PRELOAD_SERVER_CONFIG_) {
				PRELOAD_SERVER_CONFIG_[config_name] = await res_mgr.LoadGameConfig(res_mgr, config_name, false, LOAD_QUEUE.HIGHT)
			}

			this.InitEvent()
			this.UpdateView()
		}

		this.SetData = (data) => {
			data_ = data
		}

		this.Remove = () => {
			if (item_list_) {
				for (let obj of item_list_) {
					obj.DeleteMe()
				}
				item_list_ = undefined
			}
		}

		this.UpdateView = () => {
			if (data_) {
				let cfg = PRELOAD_SERVER_CONFIG_.config_goods_decompose[data_.type_id]
				let reward = JSON.parse(cfg[5])
				// let reward = JSON.parse(cfg.regular_mat)

				cache_reward_ = reward
				if (!item_list_)
					item_list_ = []
				let item
				for (let key in reward) {
					let vo = reward[key]
					item = item_list_[key]
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (!item) {
						item = new EquipmentItem(this._gp_product)
						item.Load()
						item.SetClickCallBack(() => {
							if (goods_vo && goods_vo.type == UnrealModel.goods_type)
								ui_tool_tip_mgr.AppendUnrealTips(goods_vo.type_id, goods_vo, undefined, [0], data_.goods_id)
							else {
								ui_tool_tip_mgr.AppendGoodsTips(goods_vo.type_id, undefined, vo[2])
							}
						})
						item_list_[key] = item
					}
					item.SetData(goods_vo.type_id, vo[2])
				}
			}
		}
	}

	public Open(...parms) {
		this.SetData(parms[0])
		super.Open()
	}



	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Group1: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_Image5: Laya.Image
	_img_close: Laya.Image
	_Image6: Laya.Image
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Group2: Laya.Box
	_gp_com: Laya.Box
	_Image7: Laya.Image
	_Label5: Laya.Label
	_gp_dismantle: Laya.Box
	_Image8: Laya.Image
	_Label6: Laya.Label
	_red: Laya.Image
	_Scroller1: Laya.Panel
	_gp_product: Laya.HBox
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._Group1,
			this._Image4,
			this._Label1,
			this._Image5,
			this._img_close,
			this._Image6,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Group2,
			this._gp_com,
			this._Image7,
			this._Label5,
			this._gp_dismantle,
			this._Image8,
			this._Label6,
			this._red,
			this._Scroller1,
			this._gp_product,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_Group1",
				"_Image4",
				"_Label1",
				"_Image5",
				"_img_close",
				"_Image6",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Group2",
				"_gp_com",
				"_Image7",
				"_Label5",
				"_gp_dismantle",
				"_Image8",
				"_Label6",
				"_red",
				"_Scroller1",
				"_gp_product",
			])
	}
}

window["UnrealDismantleView"] = UnrealDismantleView