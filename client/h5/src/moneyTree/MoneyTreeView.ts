import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine, Enum_Btn_Type } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneConvertItem } from "../rune/RuneConvertItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, Util, SetAnchoredPositionX, SetSizeDeltaX, GlobalTimerQuest } from "../util/Util"
import { MoneyProview } from "./MoneyProview"
import { MoneyTreeItem } from "./MoneyTreeItem"
import { MoneyTreeRewardView } from "./MoneyTreeRewardView"

export class MoneyTreeView extends BaseItem1 {
	_img_tree: Laya.Image
	_img_3: Laya.Image
	_gp_boom_effect: Laya.Box
	_gp_tree_effect: Laya.Box
	_Image1: Laya.Image
	_gp_time: Laya.Box
	_img_reward_bg: Laya.Image
	_Scroller1: Laya.Panel
	_Group1: Laya.Box
	__cul_bg: Laya.Box
	_gp_cul_reward: Laya.VBox
	_gp_reward: Laya.Box
	_Group2: Laya.Box
	_lb_allcount: Laya.HTMLDivElement
	_gp_all_btn: Laya.Box
	_gp_one_btn: Laya.Box
	_gp_ten_btn: Laya.Box
	_gp_fifty_btn: Laya.Box
	_gp_anime: Laya.Box
	_img_anime: Laya.Image
	_Label1: Laya.Label
	_img_1: Laya.Image
	_Label2: Laya.Label
	_gp_record: Laya.Box
	_img_2: Laya.Image
	_img_0: Laya.Image
	_Group5: Laya.HBox
	_Group3: Laya.Box
	_shop: Laya.Image
	_shop_red: Laya.Image
	_Group4: Laya.Box
	_img_proview: Laya.Image
	_Group6: Laya.Box
	_Image2: Laya.Image
	_score: Laya.HTMLDivElement
	InitBtn
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	RefScore
	RefShop
	RefShopRed
	RefreshShowItem
	_info
	cache_sort_order
	mask
	mask_corners
	show_two

	public constructor(parent?) {
		super(parent)

		this.show_two = false;
		this.base_file = "moneyTree"
		this.layout_file = "MoneyTreeView"
		let model = CustomActivityModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let info = null
		let data = null
		let item_pos = null
		let is_anime = true
		let is_requesting = false
		let shop_data = null
		let btns = []
		let show_item_list = []
		let timeout_id_list = []
		let cul_rewardItem_list = []
		let timer = null
		let moneyProview = null
		let record_item = null
		let _cost = null
		this.preload_client_config = {
			"ConfigMoneyTreePos": false,
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {

			this._Label2.leading = 1
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label2.lineSpacing = 0.8
			// 	this._Label2.size  = 14
			// 	SetAnchoredPosition(this._Label2,11,-815)
			// }
			// this.mask = this.GetChild("_Scroller1/_Group1").GetComponent("Image")
			// this.mask_id =this:RegisterMask(this.mask)
			// this.cache_sort_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.mask_corners = GetWorldCorners(this._Group1)
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, GameResPath.GetIcon("moneyTree", "uiyqs_003"))
			ResManager.GetInstance().SetTexture(this,this._img_1,GameResPath.GetIcon("moneyTree","uixys_001"))
			info = this._info
			if (!info) {
				return
			}
			let view_name = this.show_two && "MoneyTreeViewTwo" || "MoneyTreeView"
			item_pos = this.preload_client_config["ConfigMoneyTreePos"]
			if (!item_pos) {
				return
			}
			item_pos = item_pos[view_name]
			let cfg = this.preload_client_config["ConfigCustomActivityView"]
			if (cfg && info) {
				model.LoadCompontRes(this, cfg, view_name, info.show_id)
			}
			this.InitEvent()
			this.InitView()
		}

		this.InitView = () => {
			if (!info) {
				return
			}
			data = model.GetActData(info.base_type, info.sub_type)
			if (!data) {
				return
			}
			timer = model.LoadActTimer(this._gp_time, info.etime,18,"#2cff40")
			if (!this.show_two) {
				if (data.cumulate_reward.length != 0) {
					this._lb_allcount.innerHTML = Util.StrToHTML("累计次数:<font color='#b3ff48'>" + data.all_times + "次</font>")
					SetAnchoredPositionX(this._gp_reward, this._gp_reward.x + 30)
				} else {
					this._lb_allcount.visible = false
					this._img_reward_bg.visible = false
					this.__cul_bg.visible = false

					SetAnchoredPositionX(this._img_tree, this._img_tree.x)
					SetAnchoredPositionX(this._gp_reward, this._gp_reward.x + 56)
					SetAnchoredPositionX(this._gp_anime, 527)
				}
			}
			this.RefShop()
			this.InitBtn()
			this.RefreshShowItem("show_item")
			this.RefreshShowItem("cul_reward_item")
			record_item = model.LoadActRecord(this._gp_record, info.base_type, info.sub_type, 2, true)
			record_item.ExcuteCallback(()=>{
				// ResManager.GetInstance().SetImageSprite(this,record_item.img_bg,"moneyTree","uixys_002")
				record_item._lb_desc.color="#c04040"
			})
		}

		this.InitEvent = () => {
			if (!info) {
				return
			}
			let select_anime_click = () => {
				is_anime = !is_anime
				let gx = this.show_two && "uixyqqq_021" || "com_ui_gx"
				let gx1 = this.show_two && "uixyqqq_020" || "com_ui_gx1"
				let ab = this.show_two && "moneyTree_asset" || "common_asset"
				let source = is_anime && gx || gx1
				ResManager.GetInstance().SetImageSprite(this, this._img_anime, ab, source)
			}
			Util.AddClickEvent(this._img_anime, select_anime_click, this, true)

			let updata_view = (...new_args) => {
				let args = new_args
				if (args[0] == info.base_type && args[1] == info.sub_type) {
					if (!data) {
						this.InitView()
						return
					}
					data = model.GetActData(info.base_type, info.sub_type)
					if (!data) {
						return
					}
					if (this._lb_allcount) {
						this._lb_allcount.innerHTML =  Util.StrToHTML("累计次数:<font color='#b3ff48'>" + data.all_times + "次</font>")
						this.RefreshShowItem("cul_reward_item")
					}
					this.RefreshShowItem("show_item")
				} else if (((shop_data && args[0] == shop_data.base_type) && args[1] == shop_data.sub_type) && args[2] == 33231) {
					shop_data = model.GetActData(args[0], args[1])
					if (shop_data) {
						this.RefScore()
					}
				}
			}

			this.BindEvent(CustomActivityModel.GetInstance(), local_CustomActivityDefine.EVENT.UPDATE_VIEW, updata_view)

			let anime = (is_play?, info_list?, reward_list?) => {
				let open_view = () => {
					is_requesting = false
					let view = new MoneyTreeRewardView(info_list, 10, null, null, null, null, null, null, null, null, data.base_type, data.sub_type, _cost)
					view.Open()
				}

				if (!is_play || !is_anime) {
					open_view()
					return
				}
				if (reward_list.length >= 1) {
					for (let _tmpi in show_item_list) {
						var item = show_item_list[_tmpi]
						item.visible = false
					}
					if (this.show_two) {
						// this.AddUIEffect("UI_2034_2", this._gp_boom_effect, null, null, false, { last_time: 0.5 })
						let id = setTimeout(() => {
							open_view()
							this.ClearUIEffect(this._gp_boom_effect)
							for (let _tmpi in show_item_list) {
								var item = show_item_list[_tmpi]
								item.visible = true
							}
						}
							, 0.7)
						table.insert(timeout_id_list, id)
					} else {
						// this.AddUIEffect("UI_2034_2", this._gp_tree_effect, null, null, false, { last_time: 0.5 })

						let id = setTimeout(() => {
							open_view()
							this.ClearUIEffect(this._gp_tree_effect)
							for (let _tmpi in show_item_list) {
								var item = show_item_list[_tmpi]
								item.visible = true
							}
						}
							, 0.7)
						table.insert(timeout_id_list, id)
					}
					return
				}
			}

			let get_reward = (...new_args) => {
				let args = new_args
				if (args[0] == info.base_type && args[1] == info.sub_type) {
					if (!data) {
						return
					}
					if (this._lb_allcount) {
						this._lb_allcount.innerHTML = Util.StrToHTML("累计次数:<font color='#b3ff48'>" + data.all_times + "次</font>")
						this.RefreshShowItem("cul_reward_item")
					}
					let info_list = []
					let reward_list = null
					let is_play = true
					if (args[2].reward_list) {
						reward_list = args[2].reward_list
					} else {
						reward_list = args[2].cumulate_reward
						is_play = false
					}
					for (let _tmpi in reward_list) {
						var reward = reward_list[_tmpi]
						let info = []
						info[0]=reward.reward[0].style// table.insert(info, reward.reward[0].style)
						info[1]=reward.reward[0].typeId//table.insert(info, reward.reward[0].typeId)
						info[2]=reward.reward[0].count//table.insert(info, reward.reward[0].count)
						table.insert(info_list, info)
					}
					anime(is_play, info_list, reward_list)
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, get_reward)
			let RefreshCostGoodsNum = (list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in list) {
					var v = list[_tmpi]
					if (typeof (info.condition) == "string") {
						info.condition = ErlangParser.GetInstance().Parse(info.condition)
					}
					for (let _tmpi in info.condition) {
						var vo = info.condition[_tmpi]
						if (vo[0] == "one_cost" && vo[1][0][1] == v.type_id) {
							this.InitBtn()
							return
						}
					}
				}
			}

			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, RefreshCostGoodsNum)
			let reward_proview = () => {
				if (!data) {
					return
				}
				if (!moneyProview) {
					moneyProview = new MoneyProview()
				}
				moneyProview.SetData(data.show_list)
				moneyProview.Open()
			}

			Util.AddClickEvent(this._img_proview, reward_proview, this, true)
			Util.AddClickEvent(this._shop, () => {
				if (shop_data) {
					model.CloseACTRed(shop_data.base_type, shop_data.sub_type)
					model.Fire(local_CustomActivityDefine.EVENT.UPDATE_RED_DOT, shop_data.base_type, shop_data.sub_type)
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MoneyTreeShopView", shop_data)
				}
			}
				, this, true)
			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_RED_DOT, (...new_args) => {
				let args = new_args
				if ((shop_data && shop_data.base_type == args[0]) && shop_data.sub_type == args[1]) {
					this.RefShopRed()
				}
			}
			)
		}

		this.RefShopRed = () => {
			if (shop_data) {
				let value = model.CheckFirstRed(shop_data.base_type, shop_data.sub_type)
				this._shop_red.visible = value > 0
			}
		}

		this.RefShop = () => {
			if (data) {
				let cond = model.GetActCondition(data.base_type, data.sub_type, "info")
				if (cond && cond["act"]) {
					let type = cond["act"]
					shop_data = model.GetActData(Number(type[1]), Number(type[2]))
				}
				let bool = shop_data != null
				let parent = this._shop.parent
				this._Group3.visible=bool
				let parent_1 = this._score.parent
				this._Group6.visible=bool
				model.CloseACTRed(data.base_type, data.sub_type)
				if (bool) {
					this.RefScore()
					this.RefShopRed()
				}
			}
		}

		this.RefScore = () => {
			if (shop_data && (shop_data.currency!=undefined)) {
				let color = this.show_two && "'#ffeba4'" || "'#ffeba4'"
				this._score.innerHTML = Util.StrToHTML("个人积分:<font color=" + color + ">" + shop_data.currency + "</font>")
				this._score.x=this._Image2.width/2-this._score.contextWidth/2
			}
		}

		this.RefreshShowItem = (item_type?) => {
			if (!info || !data) {
				return
			}
			let sort_func = (a?, b?) => {
				return a.grade_id < b.grade_id
			}

			if (item_type == "cul_reward_item") {
				table.sort(data.cumulate_reward, sort_func)
				let list = []
				for (let _tmpi in data.cumulate_reward) {
					var v = data.cumulate_reward[_tmpi]
					if (v.status != 2) {
						table.insert(list, v)
					}
				}
				for (let _tmpi in data.cumulate_reward) {
					var v = data.cumulate_reward[_tmpi]
					if (v.status == 2) {
						table.insert(list, v)
					}
				}
				data.cumulate_reward = list
			} else {
				table.sort(data.show_list, sort_func)
			}
			let item_list = item_type == "show_item" && show_item_list || cul_rewardItem_list
			let info_list = item_type == "show_item" && data.show_list || data.cumulate_reward
			let parent = item_type == "show_item" && this._gp_reward || this._gp_cul_reward
			if (item_list.length > 0) {
				for (let _tmpi in item_list) {
					var item = item_list[_tmpi]
					item.visible = false
				}
			}
			let index = 0
			for (let i in info_list) {

				if (item_type == "show_item" && Number(index) >= Util.TableSize(item_pos)) {
					index = index + 1
					break
				}
				let item = item_list[index]
				if (!item) {
					item = new MoneyTreeItem(parent)
					item.Load()
					if ((item_type == "show_item" && item_pos) && item_pos[Number(index+1)]) {
						let pos = { x: item_pos[Number(index+1)].x, y: item_pos[Number(index+1)].y }
						item.SetPos(pos)
					}
					table.insert(item_list, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(info_list[i], item_type, info, this.show_two, null, this.cache_sort_order, this.mask_corners)
					item.visible = true
				}
				)
				index = index + 1
			}
			if (!this.show_two) {
				SetSizeDeltaX(this.__cul_bg, this._gp_cul_reward.y - 100)
			}
		}

		this.InitBtn = () => {
			if (!info || !data) {
				return
			}
			let cond = model.GetActCondition(info.base_type, info.sub_type, "info")
			if (cond) {
				let i = 0
				do {
					let key = null
					let parent = null
					let bg_source = null
					let num = null
					let btn_dic = []
					let show_two = this.show_two
					// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
					// 	btn_dic["t_size"] = show_two && 20 || 20
					// }else{
					btn_dic["t_size"] = show_two && 20 || 26
					// }
					if (0 == i) {
						key = "one_cost"
						parent = this._gp_one_btn
						btn_dic["text"] = show_two && "打一次" || "摇1次"
						btn_dic["strokeColor"] = show_two && "#5da01c" || "#639C12"
						bg_source = show_two && GameResPath.GetIcon("moneyTree","uixyqqq_022") || GameResPath.GetIcon("common","com_rect_btn1") //"moneyTree_asset.uixyqqq_022" || "common_asset.com_rect_btn13"
						num = 1
					} else if (1 == i) {
						key = "ten_cost"
						parent = this._gp_ten_btn
						btn_dic["text"] = show_two && "打十次" || "摇10次"
						btn_dic["strokeColor"] = show_two && "#c65c00" || "#E1743A"
						bg_source = show_two && GameResPath.GetIcon("moneyTree","uixyqqq_023") || GameResPath.GetIcon("common","com_rect_btn1")  //"moneyTree_asset.uixyqqq_023" || "common_asset.com_rect_btn12"
						num = 10
					} else if (3 == i) {
						key = "fifty_cost"
						parent = this._gp_fifty_btn
						btn_dic["text"] = "摇50次"
						btn_dic["strokeColor"] = "#E1743A"
						bg_source = GameResPath.GetIcon("common","com_rect_btn1")// "common_asset.com_rect_btn12"
						num = 50

						SetAnchoredPositionX(this._gp_one_btn, 37)
						SetAnchoredPositionX(this._gp_ten_btn, 273)
						SetAnchoredPositionX(this._gp_fifty_btn, 507)
						this._gp_fifty_btn.visible = true
					}
					let cost = cond[key]
					if (cost) {
						_cost = cost[0]
						let _btn = model.LoadActBtn(parent, btns[i], data, cost[0], btn_dic, num, bg_source, null, true, true, null, Enum_Btn_Type.TWO)
						if (_btn) {
							_btn.ExcuteCallback(()=>{
								_btn._red_1.x=120
								_btn._name_1.fontSize=22
								_btn._name_1.stroke=2
								_btn._name_1.strokeColor="#c95b37"
								// _btn._name_1.x=40
								_btn._name_1.y=14
								_btn._lb_have_1.stroke=0
								_btn._lb_cost_1.stroke=0
								_btn._gp_cost_1.centerX=11
								_btn._gp_cost_1.centerY=_btn._bg_1.heigh+5
							})

							table.insert(btns, _btn)
						}
					}
					i = i + 1
				} while ((i < 3))
			}
		}
		this.LocalDeleteMe = () => {
			if (timer) {
				timer.DeleteMe()

			}
			timer = null
			if (moneyProview) {
				moneyProview.Close()
			}
			if (timeout_id_list.length > 0) {
				for (let _tmpi in timeout_id_list) {
					var id = timeout_id_list[_tmpi]
					clearTimeout(id)
				}
				timeout_id_list = []
			}
			if (show_item_list.length > 0) {
				for (let _tmpi in show_item_list) {
					var item = show_item_list[_tmpi]
					item.DeleteMe()
				}
				show_item_list = []
			}
			if (cul_rewardItem_list.length > 0) {
				for (let _tmpi in cul_rewardItem_list) {
					var item = cul_rewardItem_list[_tmpi]
					item.DeleteMe()
				}
				cul_rewardItem_list = []
			}
			if (record_item) {
				record_item.DeleteMe()
				record_item = null
			}
			if (btns.length > 0) {
				for (let _tmpi in btns) {
					var item = btns[_tmpi]
					item.DeleteMe()
				}
				btns = []
			}
		}

	}

	public CustomMehod(index?, info?) {

		this._info = info
	}
	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_tree,
			this._img_3,
			this._gp_boom_effect,
			this._gp_tree_effect,
			this._Image1,
			this._gp_time,
			this._img_reward_bg,
			this._Scroller1,
			this._Group1,
			this.__cul_bg,
			this._gp_cul_reward,
			this._gp_reward,
			this._Group2,
			this._lb_allcount,
			this._gp_all_btn,
			this._gp_one_btn,
			this._gp_ten_btn,
			this._gp_fifty_btn,
			this._gp_anime,
			this._img_anime,
			this._Label1,
			this._img_1,
			this._Label2,
			this._gp_record,
			this._img_2,
			this._img_0,
			this._Group5,
			this._Group3,
			this._shop,
			this._shop_red,
			this._Group4,
			this._img_proview,
			this._Group6,
			this._Image2,
			this._score,
		]
			= this.GetChildrenByNames([

				"_img_tree",
				"_img_3",
				"_gp_boom_effect",
				"_gp_tree_effect",
				"_Image1",
				"_gp_time",
				"_img_reward_bg",
				"_Scroller1",
				"_Group1",
				"__cul_bg",
				"_gp_cul_reward",
				"_gp_reward",
				"_Group2",
				"_lb_allcount",
				"_gp_all_btn",
				"_gp_one_btn",
				"_gp_ten_btn",
				"_gp_fifty_btn",
				"_gp_anime",
				"_img_anime",
				"_Label1",
				"_img_1",
				"_Label2",
				"_gp_record",
				"_img_2",
				"_img_0",
				"_Group5",
				"_Group3",
				"_shop",
				"_shop_red",
				"_Group4",
				"_img_proview",
				"_Group6",
				"_Image2",
				"_score",
			])
		this._lb_allcount.style.fontSize=22
		this._lb_allcount.style.color="#ffffff"
		this._lb_allcount.style.wordWrap=false
		this._score.style.fontSize=18
		this._score.style.color="#ffffff"
		this._score.style.wordWrap=false
		this._Scroller1.vScrollBar.visible=false
	}
}
window["MoneyTreeView"]=MoneyTreeView