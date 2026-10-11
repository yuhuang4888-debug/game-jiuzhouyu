import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { longlangModel } from "../commonModel/longlangModel"
import { Message } from "../sysInfo/SysInfoController"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { EquipmentItem } from "../common/EquipmentItem"
import { longlangDecItem } from "./longlangDecItem"

export class longlangDisView extends BaseItem1 {
	Decompose
	GetBagList
	GetDecomposeList
	InitEvent
	LoadSuccess
	LocalDeleteMe
	RefreshItem
	UpdateBag
	UpdateDecomposeReward
	UpdateView

	loop_mgr
	rewardGp
	rewardList

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.layout_file = "longlangDisView"

		let local_longlangModel = longlangModel
		let local_goodsModel = GoodsModel
		let local_goodsModelIns = local_goodsModel.GetInstance()
		// let auto_decompose_state_ = false
		// let array_bag_ = null
		let select_goods_dic_ = null
		let decBag_ = null
		let _time_id_ = null
		let decompose_reward_ = null
		let decompose_reward_cache_ = null
		this.rewardList = []

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, "resource/game/common2/texture/com_line_5.png")
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btn, () => {
				let goods_list = this.GetDecomposeList()
				if (goods_list.length) {
					let have_color_more_than_orange = false
					this.Decompose(goods_list)
				} else {
					Message.show("请先选择需要拆解的物品")
				}
			}
				, this, true)
			this.BindEvent(local_longlangModel.GetInstance(), local_longlangModel.SELECT_DIS_ITEM, (data?) => {
				if (data.is_selected) {
					select_goods_dic_[data.equip_info.goods_id] = data.equip_info
				} else {
					select_goods_dic_[data.equip_info.goods_id] = null
				}
				this.UpdateDecomposeReward()
			}
			)
			this.BindEvent(local_goodsModelIns, local_goodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				if (decompose_reward_cache_ && this.display_obj.visible) {
					decompose_reward_cache_ = null
				}
			}
			)
			this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_LONGLANG_BAG, () => {
				this.UpdateView()
			}
			)
		}

		this.LoadSuccess = () => {
			select_goods_dic_ = []
			this.InitEvent()
			this.UpdateView()
		}

		this.UpdateView = () => {
			select_goods_dic_ = []
			this.UpdateBag()
			this.RefreshItem()
			this.UpdateDecomposeReward()
		}

		this.GetBagList = () => {
			let list = []
			let longlangBag = local_goodsModelIns.longlang_bag_list
			//let equipCfg = this.preload_server_config.config_goods_decompose
			//if (equipCfg ) {
			for (let _tmpi in longlangBag) {
				let equip_info = longlangBag[_tmpi]
				if (equip_info.type == local_longlangModel.GOODS_TYPE) {
					if (equip_info.color >= 6 || equip_info.subtype > 6 && (equip_info.color == 5 || equip_info.color == 4 && equip_info.stage > 3)) {
						table.insert(list, { equip_info: equip_info, is_selected: false, dec_type: 1 })
					}
				}
			}
			//}
			let length = list.length
			let i = length
			do {
				table.insert(list, { equip_info: { type_id: 0 }, is_selected: false })
				i = i + 1
			} while ((i < Math.max(length % 6 + length, 18)))
			return list
		}

		this.UpdateBag = () => {
			let list = this.GetBagList()
			decBag_ = list
		}

		this.RefreshItem = () => {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller1, longlangDecItem, decBag_, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(decBag_)
			}
		}

		this.GetDecomposeList = () => {
			let list = []
			for (let id in select_goods_dic_) {
				let goods_vo = select_goods_dic_[id]
				table.insert(list, { goods_id: goods_vo.goods_id, goods_num: goods_vo.goods_num, color: goods_vo.color })
			}
			return list
		}

		this.UpdateDecomposeReward = () => {
			let reward_value = 0
			let rewardList = []
			for (let key in select_goods_dic_) {
				let info = select_goods_dic_[key]
				if (info) {
					let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, info.type_id, false)
					if (cfg) {
						let reward = JSON.parse(cfg.regular_mat)
						for (let _tmpi in reward) {
							let vo = reward[_tmpi]
							let [type_id, lock] = local_goodsModelIns.GetMappingTypeId(vo[0], vo[1])
							if (!rewardList[type_id]) {
								rewardList[type_id] = 0
							}
							rewardList[type_id] = rewardList[type_id] + vo[2]
						}
					}
				}
			}
			let rewardArray = []
			for (let key in rewardList) {
				let info = local_goodsModelIns.GetGoodsBasicByTypeId(key)
				if (info) {
					table.insert(rewardArray, [key, info.color, rewardList[key]])
				}
			}
			table.sort(rewardArray, (a?, b?) => {
				return b[1] > a[1]
			}
			)
			decompose_reward_ = reward_value
			let i = 0
			for (let _tmpi in rewardArray) {
				let vo = rewardArray[_tmpi]
				let item = this.rewardList[i]
				if (!item) {
					item = new EquipmentItem(this.Content11, null, this.layer_value)
					item.Load()
					item.SetItemSize(90, 90)
					this.rewardList[i] = item
				}
				//item.includeInLayout = true
				item.SetVisible(true)
				item.SetData(vo[0], vo[2])
				let bool = Number(vo[3]) > 1 && true || false
				//item:ChangeCountVisible(bool, vo[2])
				i = i + 1
			}
			this.nLb.visible = i == 0
			this.nImg.visible = i == 0
			if (this.rewardList && this.rewardList.length > i) {
				do {
					let item = this.rewardList[i]
					if (item) {
						item.SetVisible(false)
					}
					i = i + 1
				} while ((i < this.rewardList.length))
			}
			let size = rewardArray.length
			let width = 500
			if (size < 6){
				width = 100 * size - 10
			}
			this._Scroller3.width = width
		}

		this.Decompose = (goods_list?) => {
			if (_time_id_) {
				return
			}
			if (!select_goods_dic_) {
				return
			}
			//let local_laya = Laya
			let list = []
			for (let key in decBag_) {
				let goods_vo = decBag_[key]
				if (select_goods_dic_[goods_vo.equip_info.goods_id]) {
					list[key] = true
				}
			}
			//let now_index = []
			//let len = this.bagGp.numChildren
			//let i = 0
			//do {
			//let item = this.bagGp.getChildAt(i)
			//// [ts2lua]now_index下标访问可能不正确
			//now_index[item.itemIndex] = [x=item.x, y=item.y - this.bagGp.scrollV]
			//i=i+1
			//} while ((i < len))
			//let register_protocals = false
			//for (let index in list) {

			//// [ts2lua]now_index下标访问可能不正确
			//let pos = now_index[index]
			//if (pos ) {
			//let group = eui. new Group()
			//group.x = pos.x + 87 / 2
			//group.y = pos.y + 87 / 2
			//this.efectGp.addChild(group)
			//let call_back = () => {
			//local_laya.Tween.removeTweens(group)
			//this.efectGp.removeChild(group)
			//if (register_protocals ) {
			//register_protocals = true
			//}
			//}

			//this:AddUIEffect("ui_tunshi_glow", group, null, null, false, null, call_back, null, null, true)
			//}
			//}
			_time_id_ = setTimeout(() => {
				_time_id_ = null
				decompose_reward_cache_ = decompose_reward_
				local_goodsModelIns.Fire(local_goodsModel.RESOLVE_GOODS, goods_list)
			}
				, 0.3)
		}

		this.LocalDeleteMe = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			select_goods_dic_ = null
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_Scroller1: Laya.List
	_Scroller3: Laya.Panel
	Content11: Laya.HBox
	_Label1: Laya.Label
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_Image3: Laya.Image
	nImg: Laya.Image
	nLb: Laya.Label
	btn: Laya.Box
	Image: Laya.Image
	Text: Laya.Label
	_img_line: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this._Scroller3,
			this.Content11,
			this._Label1,
			this._img_title,
			this._lb_title,
			this._Image3,
			this.nImg,
			this.nLb,
			this.btn,
			this.Image,
			this.Text,
			this._img_line,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Scroller1",
				"_Scroller3",
				"Content11",
				"_Label1",
				"_img_title",
				"_lb_title",
				"_Image3",
				"nImg",
				"nLb",
				"btn",
				"Image",
				"Text",
				"_img_line",
			])
	}
}
window["longlangDisView"] = longlangDisView