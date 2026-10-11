import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DrawBtnRerderer } from "./DrawBtnRerderer"
import { DrawItem } from "./DrawItem"

export class DrawView extends BaseItem1 {
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_lb_dec0: Laya.HTMLDivElement
	_Image5: Laya.Image
	_gp_item: Laya.List
	Content: Laya.List
	_Image6: Laya.Image
	_lb_dec1: Laya.HTMLDivElement
	_btn_draw: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	icon_loop_mgr: LoopScrowViewMgr
	_gp_model: Laya.Box
	CustomMehod
	Emp_btn_draw
	InitEvent
	InitScroll
	InitView
	LoadSuccess
	LocalDeleteMe
	RefBtn
	RefTurn
	RefTurnItem
	Scr_scr_btn
	_list_btn
	loop_mgr: LoopScrowViewMgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "surpriseGift"
		this.layout_file = "DrawView"
		let local_SurpriseGiftModel = SurpriseGiftModel
		let model: SurpriseGiftModel = local_SurpriseGiftModel.GetInstance()
		let info = null
		let index = null
		let select_index = null
		let item_list = []
		let time_out_list = []
		let is_add_model = false

		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
			this.InitView()
		}

		this.LoadSuccess = () => {
			//this._lb_dec0.lineSpacing = 1
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_dec0.lineSpacing = 0.8
			// }
			let str = "说明：<font color='#44ff51'>4个礼包</font>买齐后，每天可<font color='#44ff51'>免费抽奖一次</font>，每次抽<br>奖奖励不重复，每轮奖励抽完即可开启下一轮"
			this._lb_dec0.style.fontSize = 18
			this._lb_dec0.style.color = "#ffffff"
			this._lb_dec0.style.wordWrap = false
			this._lb_dec0.style.lineHeight = 25
			this._lb_dec0.innerHTML = Util.StrToHTML(str)
			//lua_resM:SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("surpriseGift","uijxlwcj_002"),true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("surpriseGift", "uijxlb_202a"), true)
			//lua_resM:SetOutsideImageSprite(this, this._Image4, GameResPath.GetIcon("surpriseGift","uijxlwcj_001"),true)
			//lua_resM:SetOutsideImageSprite(this, this._Image6, GameResPath.GetIcon("surpriseGift","uijxlwcj_003"),true)
		}
		let ShowDesc1 = () => {
			info = model.GetViewInfo()
			if (!info) {
				return
			}
			let str = null
			if (info.draw_times == 0) {
				str = "“首次抽奖<font color='#00b11d'>90%</font>机会可获得 <font color='#00b11d'>樱纱曼舞</font>”"
			} else {
				str = "<font color='#00b11d'>累充6元</font>及<font color='#00b11d'>活跃度达120</font>即可分别获得1次额外抽奖"
			}
			this._lb_dec1.style.fontSize = 18
			this._lb_dec1.style.color = "#663915"
			this._lb_dec1.style.wordWrap = false
			this._lb_dec1.innerHTML = Util.StrToHTML(str)
			let a = <Laya.HBox>this._lb_dec1.parent
			a.refresh()
		}

		this.InitEvent = () => {

			this.BindEvent(model, local_SurpriseGiftModel.DRAW_SUCCESS, (scmd?) => {
				info = model.GetViewInfo()
				if (!info) {
					return
				}
				ShowDesc1()
				this.RefBtn()
				let index = scmd.gift_id
				let cur_turn = model.getCfgDrawByTurn(scmd.turn_id)
				// [ts2lua]cur_turn下标访问可能不正确
				let cur_draw = cur_turn[scmd.gift_id]
				if (!cur_draw) {
					return
				}
				if (info.turn_id != scmd.turn_id) {
					this.loop_mgr.SetSelectIndex(info.turn_id - 1)
					this.RefTurn()
				} else if (scmd.turn_id == this.Content.selectedIndex) {
					// [ts2lua]item_list下标访问可能不正确
					let item = item_list[index]
					if (item) {
						//item:ExcuteCallback(() => {
						if (cur_draw) {
							item.SetData(cur_draw, true)
						}
						//	}
						//)
					}
				} else if (scmd.turn_id != this.Content.selectedIndex) {
					this.loop_mgr.SetSelectIndex(info.turn_id - 1)
					this.RefTurn()
				}
				let reward = cur_draw.reward_list
				if (reward) {
					if (typeof (reward) == "string") {
						reward = JSON.parse(reward)
					}
					let view = new CongratulationObtainView(reward)
					view.Open()
				}
			}
			)
			Util.AddClickEvent(this._btn_draw, () => {
				if (!info) {
					return
				}
				model.SetGradeRed(index)
				this.RefBtn()
				if (!model.CheckFinshAllDraw(info)) {
					Message.show("奖励已全部获取")
				} else if (info.gift_list.length < 4) {
					Alert.Show("购买4个礼包后即可解锁每日免费抽奖<br>", Alert_Type.One, () => {
						let cfgs = model.getCfgGift()
						let list = info.gift_list
						let gift_id = 0
						if (list.length > 0 && cfgs) {
							for (let i in cfgs) {

								let v = cfgs[i]
								let no_buy = true
								for (let _tmpi in list) {
									var vo = list[_tmpi]
									if (v.gift_id == vo.gift_id) {
										no_buy = false
										break
									}
								}
								if (no_buy) {
									gift_id = v.gift_id
									break
								}
							}
						}
						if (!gift_id) {
							gift_id = 1
						}
						model.Fire(local_SurpriseGiftModel.SELECT_VIEW, gift_id)
					},undefined,"前往购买"
					)
				} else if (info.free_draw_times || info.add_draw_times) {
					model.Fire(local_SurpriseGiftModel.SCMD_REQUEST, 49002)
				} else if (info.add_draw_times == 0) {
					let day_task_list = info.day_task_list
					let task_id = 0
					if (day_task_list && day_task_list.length) {
						for (let i in day_task_list) {

							if (day_task_list[i].task_state == 0) {
								task_id = day_task_list[i].task_id
								break
							}
						}
					}
					if (task_id) {
						let str = null
						let open_id = null
						if (1 == task_id) {
							str = "每日累充6元可获得一次次数"
							open_id = 21
						} else if (2 == task_id) {
							str = "是否前往日常任务,获取次数"
							open_id = 82
						}
						if (str && open_id) {
							Alert.Show("额外次数不足," + str, Alert_Type.One, () => {
								OpenFun.OpenFunHandler(open_id)
							}
							)
						}
					} else {
						Message.show("明天再来")
					}
				}
			}
				, this, true)
			this.BindEvent(model, local_SurpriseGiftModel.UPDATA_VIEW, () => {
				info = model.GetViewInfo()
				if (!info) {
					return
				}
				this.RefBtn()
			}
			)
		}



		this.InitView = () => {
			info = model.GetViewInfo()
			if (!info) {
				return
			}
			ShowDesc1()
			this.RefBtn()

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, DrawBtnRerderer, model.getDrawList(), LoopScrCon.Horizontal, 4, () => {
					this.RefTurn()
				})
			} else {
				this.loop_mgr.replaceAll(model.getDrawList())
			}

			this.RefTurnItem(info.turn_id)
			// [ts2lua]lua中0和空字符串也是true，此处info.turn_id需要确认
			select_index = (info.turn_id && info.turn_id != 0) && info.turn_id - 1 || 0
			this.loop_mgr.SetSelectIndex(select_index)
			this.InitScroll(select_index)
		}

		this.InitScroll = (_select_index?) => {
			//let time_out = () => {
			//let item_num = model.length.getDrawList()
			//let contentWidth = this._scr_btn.viewport.contentWidth
			//let width = this._scr_btn.width
			//let item_width = contentWidth / item_num * _select_index
			//let move_x = null
			//if (item_width > width / 2 && item_width < contentWidth - width / 2 ) {
			//move_x = item_width - width / 2
			//} else if (item_width <= width / 2 ) {
			//move_x = 0
			//} else if (item_width > contentWidth - width / 2 ) {
			//move_x = contentWidth - width
			//}
			//this._scr_btn.viewport.scrollH = move_x
			//}

			//let id = Laya.setTimeout(time_out, this, 50)
			//table.insert(time_out_list, id)
			this.loop_mgr.LastOnChild(_select_index)
		}

		this.RefTurn = () => {
			select_index = this.Content.selectedIndex
			this.RefTurnItem(select_index + 1)
		}

		this.RefTurnItem = (turn_id?) => {
			// [ts2lua]lua中0和空字符串也是true，此处turn_id需要确认
			turn_id = (turn_id && (turn_id) || (1))
			let have_first = false
			if (info && turn_id) {
				let cur_turn = model.getCfgDrawByTurn(turn_id)
				if (!cur_turn || Util.IsTableEmpty(cur_turn)) {
					return
				}
				for (let i in cur_turn) {


					let is_drawed = false
					if (turn_id == info.turn_id) {
						let draw_list = info.draw_list
						if (draw_list && draw_list.length > 0) {
							for (let _tmpi in draw_list) {
								var v = draw_list[_tmpi]
								if (v.draw_id == cur_turn[i].gift_id) {
									is_drawed = true
									if (turn_id == 1 && v.draw_id)
										have_first = true
									break
								}
							}
						}
					} else if (turn_id < info.turn_id) {
						have_first = true
						is_drawed = true
					}
					cur_turn[i].is_draw = is_drawed

				}
				if (cur_turn && Util.TableSize(cur_turn) > 0) {
					let list = []
					for (let i in cur_turn) {
						table.insert(list, cur_turn[i])
					}
					if (!this.icon_loop_mgr) {
						this.icon_loop_mgr = new LoopScrowViewMgr()
						this.icon_loop_mgr.SetData(this._gp_item, DrawItem, list, LoopScrCon.Vertical)
					} else {
						this.icon_loop_mgr.replaceAll(list)
					}
				}
				if (!is_add_model && !have_first){
					CustomActivityModel.GetInstance().ShowViewModel(this, "DrawView", [5, 1002, 1], this._gp_model)
					is_add_model = true
				}
				if (have_first)
					ResManager.GetInstance().ClearRoleMode(this.hashCode)


			}
		}

		this.RefBtn = () => {
			if (!info) {
				return
			}
			let bool = false
			let str = "明天再来"
			if (!model.CheckFinshAllDraw(info)) {
				str = "奖励已抽完"
			} else if (info.gift_list.length < 4) {
				str = "免费抽奖"
			} else if (info.free_draw_times && info.free_draw_times != 0) {
				str = "免费抽奖"
				bool = true
			} else if (info.add_draw_times && info.add_draw_times != 0) {
				str = "额外抽奖"
				bool = true
			} else if (info.add_draw_times == 0) {
				let day_task_list = info.day_task_list
				let finish = true
				if (day_task_list && day_task_list.length) {
					for (let i in day_task_list) {

						if (day_task_list[i].task_state == 0) {
							finish = false
							break
						}
					}
				}
				if (finish) {
					bool = false
				} else {
					str = "额外抽奖"
					bool = false
				}
			}
			this._img_red.visible = bool || model.CheckGradeRed(index)
			//	let label = this._btn_draw.getChildAt(1)
			this.labelDisplay.text = str
		}

		this.CustomMehod = (_index?, args?) => {
			index = _index
		}

		this.LocalDeleteMe = () => {
			//if (time_out_list.length > 0 ) {
			//for (let _tmpi in time_out_list) {
			//var id = time_out_list[_tmpi]
			//Laya:clearTimeout(id)
			//}
			//time_out_list = []
			//}
			ResManager.GetInstance().ClearRoleMode(this.hashCode)

			if (item_list.length > 0) {
				for (let _tmpi in item_list) {
					var item = item_list[_tmpi]
					item.DeleteMe()
				}
				item_list = []
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.icon_loop_mgr) {
				this.icon_loop_mgr.DeleteMe()
				this.icon_loop_mgr = null
			}
			super.DeleteMe()
		}


	}


	public DeleteMe() {

		this.LocalDeleteMe()
	}

	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image4,
			this._lb_dec0,
			this._Image5,
			this._gp_item,
			this.Content,
			this._Image6,
			this._lb_dec1,
			this._btn_draw,
			this._Image1,
			this.labelDisplay,
			this._img_red,
			this._gp_model
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Image3",
				"_Image4",
				"_lb_dec0",
				"_Image5",
				"_gp_item",
				"Content",
				"_Image6",
				"_lb_dec1",
				"_btn_draw",
				"_Image1",
				"labelDisplay",
				"_img_red",
				"_gp_model"
			])
	}
}
window["DrawView"] = DrawView