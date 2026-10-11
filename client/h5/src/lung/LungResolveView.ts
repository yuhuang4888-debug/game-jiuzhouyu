import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungEvent, LungModel } from "../commonModel/LungModel";
import { Message } from "../sysInfo/SysInfoController";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";
import { LungResolveItem } from "./LungResolveItem";

export class LungResolveView extends BaseView1 {
	LoadSuccess
	InitEvent
	CheckFun
	OpenCallback
	SetData
	GetBagVoList
	FirstInit
	RefreshSelectView
	CalculateCanGetExpNum
	PreviewDecomposeRewards
	SetItemRender
	ShowCanResolveDot
	loop_mgr:LoopScrowViewMgr
	public constructor() {
		super();
		this.base_file = "lung";
		this.layout_file = "LungResolveView";
		this.layer_value = Enum_UILayer.Activity;
		this.destroy_imm = true;
		this.use_background = true;
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true;
		this.is_delay_callback = false
		let model = LungModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_Util = Util,
			local_LungEvent = LungEvent,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			item_list_: Array<LungResolveItem>,
			select_bool_arr_: Array<boolean>,
			color_arr_: Array<number>,
			check_btn_img_arr_: Array<Laya.Image>,
			check_label_arr_: Array<Laya.Label>,
			resolve_list_: Array<any>,
			// array_collection_: eui.ArrayCollection,
			reward_item_list_
		this.load_callback = function () {
			this.LoadSuccess();
			this.InitEvent();
		}
		this.open_callback = function () {
			this.OpenCallback();
		}
		this.destroy_callback = function () {
			if (item_list_) {
				for (let obj of item_list_) {
					obj.DeleteMe()
				}
				item_list_ = null
			}
			if (reward_item_list_) {
				for (let obj of reward_item_list_) {
					obj.DeleteMe()
				}
				reward_item_list_ = null
			}
			if (this.loop_mgr){
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			// array_collection_ = null
		}

		this.LoadSuccess = () => {
			this.scroll_group.scrollBar.visible = false
			this._Scroller2.hScrollBar.visible = false
			item_list_ = []
			// res_mgr.SetTexture(this, this.line, "resource/game/lung/texture/uilwmb_030.png")
			// res_mgr.SetTexture(this, this.line2, "resource/game/lung/texture/uilwmb_030.png")
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("lung", "uisy_023"))
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			local_Util.AddClickEvent(this.closeBtn, close_fun, this, true)

			local_Util.AddClickEvent(this.resolveBtn, () => {
				let goods_list = []
				let vo: any
				if (resolve_list_) {
					for (let obj of resolve_list_) {
						if (obj.is_selected) {
							vo = {}
							vo.goods_id = obj.goods_id
							vo.goods_num = 1
							goods_list.push(vo)
						}
					}
				}
				if (goods_list.length) {
					model.Fire(local_LungEvent.LUNG_REQUEST_OTHER_PROTO, 18104, goods_list)
				} else {
					Message.show("请先选择需要分解的物品")
				}

			}, this, true)

			local_Util.AddClickEvent(this.checkBtn1, () => {
				this.CheckFun(0)
				this.RefreshSelectView()
			}, this)

			local_Util.AddClickEvent(this.checkBtn2, () => {
				this.CheckFun(1)
				this.RefreshSelectView()
			}, this)

			local_Util.AddClickEvent(this.checkBtn3, () => {
				this.CheckFun(2)
				this.RefreshSelectView()
			}, this)

			local_Util.AddClickEvent(this.checkBtn4, () => {
				this.CheckFun(3)
				this.RefreshSelectView()
			}, this)

			this.BindEvent(model, local_LungEvent.CLICK_LUNG_RESOLVE_ITEM, (goods_id, select) => {
				this.CalculateCanGetExpNum()
			})
			this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {

			})

			let update_fun = () => {
				let delete_list = {}
				if (resolve_list_) {
					for (let i in resolve_list_) {
						let v = resolve_list_[i]
						delete_list[v.goods_id] = i
					}
				}

				let now_bag = this.GetBagVoList()
				for (let key in now_bag) {
					let vo = now_bag[key]
					if (delete_list[vo.goods_id]) {
						delete delete_list[vo.goods_id]
					}
				}

				let now_index = {}
				let len = this.scroll_group.numChildren
				for (let i = 0; i < len; i++) {
					let item = <LungResolveItem>this.scroll_group.getChildAt(i)
					now_index[item["index"]] = { x: item.x, y: item.y - this.scroll_group.scrollBar.value }
				}
				for (let a in delete_list) {
					let b = delete_list[a]
					let pos = now_index[b]
					if (pos) {
						let group = new Laya.Box()
						group.x = pos.x + 20 + 175 / 2
						group.y = pos.y + 75 + 17 + 119 / 2
						// let call_back = () => {
						// 	this.AddUIEffect("ui_achievementglow2", group, null, null, true, null, null, null, null, true)
						// 	egret.Tween.get(group).to({ x: 180, y: 809 }, 800, egret.Ease.circOut).call(() => {
						// 		this.ClearUIEffect(group)
						// 		let end_call = () => {
						// 			egret.Tween.removeTweens(group)
						// 			this.ClearUIEffect(group)
						// 			this.removeChild(group)
						// 		}
						// 		this.AddUIEffect("ui_achievementglow3", group, null, null, false, null, null, null, null, true)
						// 	})
						// }
						// this.AddUIEffect("ui_achievementglow1", group, null, null, false, null, call_back, null, null, true)
						this.AddUIEffect("ui_resolve_glowbloom", group, null, null, false, null, null, null, null, true)
					}
				}
				this.SetData()
			}
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_LUNG_BAG_LIST, update_fun)

			// let rune_fun = () => {
			// 	this.CalculateCanGetExpNum(true)
			// }
			// this.BindEvent(model, RuneEvent.UPDATE_RUNE_DATA, update_fun)

			// this.BindEvent(model, RuneEvent.RESOLVE_PREVIEW, (scmd) => {
			// 	this.PreviewDecomposeRewards(scmd)
			// })
		}

		this.CheckFun = (index: number) => {
			if (check_btn_img_arr_[index]) {
				let is_select = !select_bool_arr_[index]
				select_bool_arr_[index] = is_select
				if (is_select) {
					check_btn_img_arr_[index].skin = AtlasUrl("common", "com_ui_gx1")
				} else {
					check_btn_img_arr_[index].skin = AtlasUrl("common", "com_ui_gx")
				}
			}
		}

		this.OpenCallback = () => {
			select_bool_arr_ = [true, false, false, false]//蓝色以下，紫色，橙色，红色
			color_arr_ = [2, 3, 4, 5]
			check_btn_img_arr_ = [this.check_img1, this.check_img2, this.check_img3, this.check_img4]
			check_label_arr_ = [this.check_label1, this.check_label2, this.check_label3, this.check_label4]
			this.SetData()
		}

		this.SetData = () => {
			resolve_list_ = this.GetBagVoList()
			this.SetItemRender()
			this.FirstInit()
			this.ShowCanResolveDot()
		}

		//获取符合分解的列表
		this.GetBagVoList = () => {
			let list = []
			let goods = []
			if (goods_model.lungbag_goods_list) {
				for (let vo of goods_model.lungbag_goods_list) {
					vo.is_selected = false
					if (vo.type == LungModel.LungMaterialGoodsType) {
						list.push(vo)
					} else {
						goods.push(vo)
					}
				}
			}
			let sort_fun = (a, b) => {
				if (a.color == b.color) {
					if (a.subtype == b.subtype) {
						return a.level - b.level
					} else {
						return a.subtype - b.subtype
					}
				} else {
					return a.color - b.color
				}
			}
			goods.sort(sort_fun)
			list.sort(sort_fun)
			list = list.concat(goods)
			return list
		}

		//初始化
		this.FirstInit = () => {
			//先取反
			for (let i = 0; i < select_bool_arr_.length; i++) {
				select_bool_arr_[i] = !select_bool_arr_[i]
			}
			for (let i = 0; i < select_bool_arr_.length; i++) {
				this.CheckFun(i)
			}
			this.RefreshSelectView()
		}

		//刷新选中状态
		this.RefreshSelectView = () => {
			for (let i = 0; i < select_bool_arr_.length; i++) {
				for (let obj of resolve_list_) {
					if (i == 0) {
						if (obj && obj.color <= color_arr_[i]) { //蓝色以下
							obj.is_selected = select_bool_arr_[i]
						}
					} else {
						if (obj && obj.color == color_arr_[i]) {
							obj.is_selected = select_bool_arr_[i]
						}
					}
				}
			}
			this.CalculateCanGetExpNum()
			// array_collection_.refresh()
			this.loop_mgr.parent.refresh()
		}

		//计算可获得的碎片数量
		this.CalculateCanGetExpNum = () => {
			let goods_list = []
			for (let obj of resolve_list_) {
				if (obj.is_selected) {
					goods_list.push(obj)
				}
			}
			if (goods_list.length > 0) {
				let reward = model.GetResolveReward(goods_list)
				this.PreviewDecomposeRewards(reward)
			} else {
				this.PreviewDecomposeRewards([])
			}
		}

		this.PreviewDecomposeRewards = (reward) => {
			if (reward_item_list_){
				let item2:BaseAwardItem
				for (let i = 0; i < reward_item_list_.length; i++) {
					item2 = reward_item_list_[i];
					item2.DeleteMe()
					item2 = null
				}
			}
			reward_item_list_ = []
			
			
			if (reward != undefined) {
				let item: BaseAwardItem
				for (let i = 0, length = reward.length; i < length; i++) {
					item = reward_item_list_[i]
					if (!item) {
						item = new BaseAwardItem(this.reward_group)
						item.Load()
						item.SetItemSize(60, 60)
						reward_item_list_[i] = item
					}
					let [type_id, lock] = goods_model.GetMappingTypeId(reward[i][0], reward[i][1])
					item.SetVisible(true)
					item.SetData(type_id, reward[i][2])
				}
				if (reward_item_list_.length > reward.length) {
					for (let i = reward.length, length = reward_item_list_.length; i < length; i++) {
						reward_item_list_[i].SetVisible(false)
					}
				}
			}
		}

		this.SetItemRender = () => {
			this.none_conta.visible = resolve_list_.length > 0 ? false : true
			if (! this.loop_mgr ) {
				this.loop_mgr =  new LoopScrowViewMgr(this.layer_value)
				this.loop_mgr.SetData(this.scroll_group, LungResolveItem,resolve_list_,LoopScrCon.Vertical,1)
			}else{
				this.loop_mgr.replaceAll(resolve_list_)
			}

			// if (!array_collection_) {
			// 	array_collection_ = new eui.ArrayCollection()
			// 	array_collection_.source = resolve_list_
			// 	this.scroll_group.dataProvider = array_collection_
			// 	this.scroll_group.itemRenderer = LungResolveItem
			// } else {
			// 	array_collection_.replaceAll(resolve_list_)
			// }
		}

		this.ShowCanResolveDot = () => {
			// this.oneKeyDot.visible = model.CanResolve()
		}
	}
	

	_Image1: Laya.Image
	_Image2: Laya.Image
	closeBtn: Laya.Image
	_Image3: Laya.Image
	title: Laya.Image
	_Scroller1: Laya.Panel
	scroll_group: Laya.List
	line: Laya.Image
	checkBtn1: Laya.Box
	check_img1: Laya.Image
	check_label1: Laya.Label
	checkBtn2: Laya.Box
	check_img2: Laya.Image
	check_label2: Laya.Label
	checkBtn3: Laya.Box
	check_img3: Laya.Image
	check_label3: Laya.Label
	checkBtn4: Laya.Box
	check_img4: Laya.Image
	check_label4: Laya.Label
	line2: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Scroller2: Laya.Panel
	reward_group: Laya.HBox
	resolveBtn: Laya.Box
	_Image6: Laya.Image
	_Label1: Laya.Label
	resolve_dot: Laya.Image
	none_conta: Laya.Box
	_Label2: Laya.Label
	_Image7: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.closeBtn,
			this._Image3,
			this.title,
			this._Scroller1,
			this.scroll_group,
			this.line,
			this.checkBtn1,
			this.check_img1,
			this.check_label1,
			this.checkBtn2,
			this.check_img2,
			this.check_label2,
			this.checkBtn3,
			this.check_img3,
			this.check_label3,
			this.checkBtn4,
			this.check_img4,
			this.check_label4,
			this.line2,
			this._Image4,
			this._Image5,
			this._Scroller2,
			this.reward_group,
			this.resolveBtn,
			this._Image6,
			this._Label1,
			this.resolve_dot,
			this.none_conta,
			this._Label2,
			this._Image7,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"closeBtn",
				"_Image3",
				"title",
				"_Scroller1",
				"scroll_group",
				"line",
				"checkBtn1",
				"check_img1",
				"check_label1",
				"checkBtn2",
				"check_img2",
				"check_label2",
				"checkBtn3",
				"check_img3",
				"check_label3",
				"checkBtn4",
				"check_img4",
				"check_label4",
				"line2",
				"_Image4",
				"_Image5",
				"_Scroller2",
				"reward_group",
				"resolveBtn",
				"_Image6",
				"_Label1",
				"resolve_dot",
				"none_conta",
				"_Label2",
				"_Image7",
			])
	}
}

window["LungResolveView"] = LungResolveView