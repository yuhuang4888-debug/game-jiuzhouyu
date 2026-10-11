import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { HolySealToolTips } from "../common/HolySealToolTips"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class HolySealDismantleView extends BaseView1 {

	InitEvent
	LoadSuccess
	Local_Open
	Remove
	UpdateView
	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealDismantleView"
		this.layer_value = Enum_UILayer.Activity


		let model = HolySealModel.GetInstance(),
			local_Util = Util,
			goods_model = GoodsModel.GetInstance(),
			UI_tool_tip_mgr = UIToolTipMgr.GetInstance(),
			color_list_,
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
					goods_model.Fire(GoodsModel.RESOLVE_GOODS, [{ goods_id: data_.goods_id, goods_num: 1 }])
				}
			}, this, true)

			this.BindEvent(goods_model, GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				if (cache_reward_) {
					// for (let obj of cache_reward_) {
					// 	let goods_vo = goods_model.GetGoodsBasicByTypeId(obj[1])
					// 	if (goods_vo) {
					// 		let color = ColorUtil.GetColorLight(goods_vo.color)
					// 		Message.show(`<font color='#ffffff'>获得</font> <font color=${color}>${goods_vo.goods_name} x${obj[2]}</font>`)
					// 	}
					// }
					cache_reward_ = undefined
				}
				this.Close()
			})
		}

		this.LoadSuccess = async () => {
			for (let config_name in PRELOAD_SERVER_CONFIG_) {
				PRELOAD_SERVER_CONFIG_[config_name] = await ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), config_name, false, LOAD_QUEUE.HIGHT)
			}

			ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetIcon("common", "uisy_023"))

			this.InitEvent()
			this.UpdateView()
		}


		this.Local_Open = (parm) => {
			data_ = parm[0]
			super.Open()
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
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, data_.type_id, false, PRELOAD_SERVER_CONFIG_.config_goods_decompose)
				// let cfg = PRELOAD_SERVER_CONFIG_.config_goods_decompose[data_.type_id]
				let reward = JSON.parse(cfg.regular_mat)
				cache_reward_ = reward
				let goods_list = []
				for (let i in reward) {
					let vo = reward[i]
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo.type == 60) {
						for (let j = 0; j < vo[2]; j++) {
							goods_list.push([vo[0], vo[1], 1])
						}
					} else {
						goods_list.push(vo)
					}
				}
				if (!item_list_)
					item_list_ = []
				let item
				for (let key in goods_list) {
					let vo = goods_list[key]
					item = item_list_[key]
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (!item) {
						item = new EquipmentItem(this._gp_product)
						item.SetItemSize(87, 87)
						item.Load()
						item.SetClickCallBack(() => {
							if (goods_vo && goods_vo.type == HolySealModel.GOODS_TYPE)
								UI_tool_tip_mgr.AppendHolySealTips(goods_vo.type_id, goods_vo, undefined, [HolySealToolTips.Btn.close])
							else {
								UI_tool_tip_mgr.AppendGoodsTips(goods_vo.type_id, undefined, undefined, undefined, vo[2])
							}
						})
						item_list_[key] = item
					}
					item.SetData(goods_vo.type_id, vo[2])
				}
			}
		}
	}


	public Open(...parm) {
		this.Local_Open(parm)
	}
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_Label1: Laya.Label
	_img_close: Laya.Image
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Group1: Laya.Box
	_gp_com: Laya.Box
	_Image2: Laya.Image
	_Label4: Laya.Label
	_gp_dismantle: Laya.Box
	_Image3: Laya.Image
	_Label5: Laya.Label
	_Scroller1: Laya.Panel
	_gp_product: Laya.HBox
	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._Label1,
			this._img_close,
			this._Label2,
			this._Label3,
			this._Group1,
			this._gp_com,
			this._Image2,
			this._Label4,
			this._gp_dismantle,
			this._Image3,
			this._Label5,
			this._Scroller1,
			this._gp_product,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_Label1",
				"_img_close",
				"_Label2",
				"_Label3",
				"_Group1",
				"_gp_com",
				"_Image2",
				"_Label4",
				"_gp_dismantle",
				"_Image3",
				"_Label5",
				"_Scroller1",
				"_gp_product",
			])
	}
}
window["HolySealDismantleView"] = HolySealDismantleView