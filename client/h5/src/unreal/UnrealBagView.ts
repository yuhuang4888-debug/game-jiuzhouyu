import { BaseItem1 } from "../common/BaseItem1"
import { DownDropBtn } from "../common/DownDropBtn"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { UnrealBagItem } from "./UnrealBagItem"
import { UnrealEquipItem } from "./UnrealEquipItem"
import { CompositeModel } from "../commonModel/CompositeModel"


import "../unreal/UnrealEnterView"
import "../unreal/UnrealDismantleView"
import "../unreal/UnrealDecomposeView"
import { MainFunc } from "../commonModel/MainUIModel"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { CrossServerViewIndex } from "../commonController/BossController"
import { GameResPath } from "../util/GameResPath"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"

export class UnrealBagView extends BaseItem1 {

	private _drop_color: DownDropBtn
	private _drop_pos: DownDropBtn

	LoadSuccess
	InitEvent
	InitView
	ClickColor
	ClickPos
	UpdateBag
	UpdateEquip
	UpdateTotalSorce
	ShowDecomposeRed
	ShowStrenRed
	bag_loop_mgr: LoopScrowViewMgr
	CheckUnrealRedDot
	private giftItem: GiftPushIcon;
	public constructor(parent) {
		super(parent)
		this.base_file = "unreal"
		this.layout_file = "UnrealBagView"
		let model = UnrealModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_Util = Util,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			local_UnrealModel = UnrealModel,
			drop_pos_,
			drop_color_,
			// attr_bag_: eui.ArrayCollection,
			equip_list_,
			offset_ = 6,
			// equip_pos_ = [
			// 	{ x: 8 - offset_, y: 60 - offset_ },
			// 	{ x: 217 - offset_, y: 8 - offset_ },
			// 	{ x: 425 - offset_, y: 60 - offset_ },
			// 	{ x: 8 - offset_, y: 291 - offset_ },
			// 	{ x: 217 - offset_, y: 340 - offset_ },
			// 	{ x: 425 - offset_, y: 291 - offset_ },
			// ]
			equip_pos_ = [
				{ x: 3, y: 64 },
				{ x: 175, y: 0 },
				{ x: 346, y: 65 },
				{ x: 346, y: 258 },
				{ x: 173, y: 351 },
				{ x: 2, y: 257 },
			]

		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.DeleteMe = () => {
			if (equip_list_) {
				for (let item of equip_list_) {
					item.DeleteMe()
					item = null
				}
				equip_list_ = []
			}
			if (this._drop_color) {
				this._drop_color.DeleteMe()
				this._drop_color = null
			}
			if (this._drop_pos) {
				this._drop_pos.DeleteMe()
				this._drop_pos = null
			}
			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.DeleteMe()
				this.bag_loop_mgr = null
			}
			if (this.giftItem) {
				this.giftItem.DeleteMe();
				this.giftItem = null;
			}
			super.DeleteMe()
		}

		this.LoadSuccess = async () => {
			this._dgp_bag_con.scrollBar.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_equip_bg, GameResPath.GetIcon("unreal", "uihs_003"))
			// res_mgr.SetTexture(this, this._img_big_bg, "resource/game/unreal/texture//uihs_004.png")
			// res_mgr.SetTexture(this, this._img_title_bg, "resource/game/unreal/texture/uihs_005.png")

			// attr_bag_ = new eui.ArrayCollection()
			// this._dgp_bag_con.dataProvider = attr_bag_
			// this._dgp_bag_con.itemRenderer = UnrealBagItem

			this.InitView()
			this.ShowGiftIcon();
			this.CheckUnrealRedDot()
		}

		this.InitEvent = () => {

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			local_Util.AddClickEvent(this._gp_stren, () => {
				let wear_list = goods_model.wear_unreal_list
				let count = 0
				if (wear_list) {
					for (let i in wear_list) {
						let vo = wear_list[i]
						if (vo && vo != null) {
							count += 1
						}
					}
				}
				let open = wear_list && count > 0
				if (open) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "UnrealEnterView")
				} else {
					Message.show("没有穿戴灵饰，无法强化。")
				}

			}, this, true)

			local_Util.AddClickEvent(this._gp_get, () => {
				//Message.show("敬请期待")
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss)
				// Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss);
			}, this, true)

			local_Util.AddClickEvent(this._gp_composite, () => {
				CompositeModel.GetInstance().Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.Unreal, 113)
			}, this, true)

			local_Util.AddClickEvent(this._gp_decompose, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "UnrealDecomposeView")
			}, this, true)

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_UNREAL_BAG_LIST, () => {
				this.UpdateBag()
			})

			this.BindEvent(model, local_UnrealModel.REFRESH_RED_ICON, () => {
				// this.ShowDecomposeRed()
			})

			this.BindEvent(local_GlobalEventSystem, local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, (_type) => {
				if (_type && _type == MainFunc.Treasure) {
					this.ShowDecomposeRed()
					this.ShowStrenRed()
				}
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_UNREAL_LIST, () => {
				this.UpdateEquip()
				this.UpdateBag()
			})

			this.BindVar(
				CompositeModel.GetInstance(),
				"unreal_red_dot", (event_name?, now_value?) => {
					this.CheckUnrealRedDot()
				}
			)
		}
		this.CheckUnrealRedDot = () => {
			let unreal_red = CompositeModel.GetInstance().GetUnrealRedDot()
			this._img_unreal_red.visible= unreal_red
		}

		this.InitView = () => {
			let pos_drop_list = model.GetPosDropData()

			this._drop_pos = new DownDropBtn(this.pos_con)
			this._drop_pos.Init(pos_drop_list, this.ClickPos, "部位选择", "content", undefined, undefined, false, false)
			this._drop_pos.Load()

			let color_drop_list = model.GetColorDropData()
			this._drop_color = new DownDropBtn(this.color_con)
			this._drop_color.Init(color_drop_list, this.ClickColor, "颜色选择", "content", undefined, undefined, false, false)
			this._drop_color.Load()

			this.UpdateBag()

			if (!equip_list_)
				equip_list_ = []
			let item: UnrealEquipItem
			for (let i = 0; i < local_UnrealModel.equip_count; i++) {
				item = new UnrealEquipItem(this._gp_equips)
				equip_list_[i] = item
				let pos = equip_pos_[i]
				item.SetPosition(pos.x, pos.y)
				item.SetEquipType(i + 1)
				item.Load()
			}
			this.UpdateEquip()
			this.ShowDecomposeRed()
			this.ShowStrenRed()
		}

		this.ClickColor = (index, data) => {
			drop_color_ = data.cond
			this.UpdateBag()
		}

		this.ClickPos = (index, data) => {
			drop_pos_ = data.cond
			this.UpdateBag()
		}

		this.UpdateBag = () => {
			let list = model.GetBagsByPosAndColor(drop_pos_, drop_color_)

			this._gp_empty.visible = list.length == 0
			this._scroll_bag_con.visible = list.length != 0

			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.replaceAll(list)
			} else {
				this.bag_loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.bag_loop_mgr.SetData(this._dgp_bag_con, UnrealBagItem, list, this._scroll_bag_con, 5)
			}

			let decoration_kv_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_kv", false)
			let max_len = model.GetKeyValue(1, decoration_kv_cfg)
			let len = goods_model.unrealbag_goods_list ? goods_model.unrealbag_goods_list.length : 0
			this._lb_big_capacity.text = `${len}/${max_len}`
		}

		this.UpdateEquip = () => {
			let list = goods_model.wear_unreal_list
			for (let i = 0; i < local_UnrealModel.equip_count; i++) {
				let equip = list[i]
				equip_list_[i].SetData(equip)
			}
			this.UpdateTotalSorce()
		}

		this.UpdateTotalSorce = () => {
			let sorce = 0
			let list = goods_model.wear_unreal_dic
			for (let key in list) {
				let vo = list[key]
				if (vo) {
					sorce += vo.overall_rating
				}
			}
			this._lb_sorce.text = String(sorce)
		}

		this.ShowDecomposeRed = () => {
			let red = model.GetDecomposeRedDot()
			this._img_decompose_red.visible = red
		}

		this.ShowStrenRed = () => {
			let red = model.GetStrenRedDot()
			this._img_stren_red.visible = red
		}
	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eLingShi));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eLingShi);
			});

		}
		this.giftIcon.visible = bool;
	}

	_img_equip_bg: Laya.Image
	_img_big_bg2: Laya.Image
	_img_big_bg: Laya.Image
	_gp_equips: Laya.Box
	_scroll_bag_con: Laya.Panel
	_dgp_bag_con: Laya.List
	group1: Laya.HBox
	label1: Laya.Label
	_lb_big_capacity: Laya.Label
	_gp_stren: Laya.Box
	_Image2: Laya.Image
	_Label31: Laya.Label
	_img_stren_red: Laya.Image
	_gp_decompose: Laya.Box
	_Image3: Laya.Image
	_Label4: Laya.Label
	_img_decompose_red: Laya.Image
	_gp_composite: Laya.Box
	_Image21: Laya.Image
	_Label3: Laya.Label
_img_unreal_red:Laya.Image
	_gp_get: Laya.Box
	_Image11: Laya.Image
	_Label2: Laya.Label
	_gp_title: Laya.Box
	_img_title_bg: Laya.Image
	group2: Laya.HBox
	img: Laya.Image
	_lb_sorce: Laya.Label
	_gp_empty: Laya.HBox
	_Image5: Laya.Image
	_Label5: Laya.Label
	color_con: Laya.Box
	pos_con: Laya.Box
	giftIcon: Laya.Box
	public GetComponents() {
		[
			this._img_equip_bg,
			this._img_big_bg2,
			this._img_big_bg,
			this._gp_equips,
			this._scroll_bag_con,
			this._dgp_bag_con,
			this.group1,
			this.label1,
			this._lb_big_capacity,
			this._gp_stren,
			this._Image2,
			this._Label31,
			this._img_stren_red,
			this._gp_decompose,
			this._Image3,
			this._Label4,
			this._img_decompose_red,
			this._gp_composite,
			this._Image21,
			this._Label3,
this._img_unreal_red,
			this._gp_get,
			this._Image11,
			this._Label2,
			this._gp_title,
			this._img_title_bg,
			this.group2,
			this.img,
			this._lb_sorce,
			this._gp_empty,
			this._Image5,
			this._Label5,
			this.color_con,
			this.pos_con,
			this.giftIcon,
		]
			= this.GetChildrenByNames([

				"_img_equip_bg",
				"_img_big_bg2",
				"_img_big_bg",
				"_gp_equips",
				"_scroll_bag_con",
				"_dgp_bag_con",
				"group1",
				"label1",
				"_lb_big_capacity",
				"_gp_stren",
				"_Image2",
				"_Label31",
				"_img_stren_red",
				"_gp_decompose",
				"_Image3",
				"_Label4",
				"_img_decompose_red",
				"_gp_composite",
				"_Image21",
				"_Label3",
"_img_unreal_red",
				"_gp_get",
				"_Image11",
				"_Label2",
				"_gp_title",
				"_img_title_bg",
				"group2",
				"img",
				"_lb_sorce",
				"_gp_empty",
				"_Image5",
				"_Label5",
				"color_con",
				"pos_con",
				"giftIcon",
			])
	}

}
window["UnrealBagView"] = UnrealBagView