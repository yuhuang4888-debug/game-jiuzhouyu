import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { ShopModel } from "../commonModel/ShopModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDelta, Util, GlobalTimerQuest, SetSizeDeltaY, SetHtmlStyle, SetHtmlCenter, HtmlColorTxt } from "../util/Util"
import { Kf1vnQuizRadioItem } from "./Kf1vnQuizRadioItem"
import { Kf1vnQuizSelectItem } from "./Kf1vnQuizSelectItem"

export class Kf1vnQuizSelectView extends BaseView1 {
	CancelTimer
	ClearItemList
	InitEvent
	LoadSuccess
	Local_Open
	OnTime
	OpenCallback
	Scr_Scroller1
	SetQuizAmount
	SetSelectList
	SetWinAndLoseCanGet
	StartTimer
	back_login_close
	background_alpha
	change_scene_close
	destroy_callback
	open_callback
	use_background
	GetQuizCostList
	GetQuizListByTurn
	GetDefendNumByTurn
	item_select_mgr
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnQuizSelectView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center = true
		this.background_alpha = 0
		let model = Kf1vnModel.GetInstance()
		let shop_model = ShopModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let data_ = null
		let left_time_id_ = null
		let item_list_ = []
		let now_select_id_ = null
		let money_item_list_ = []
		let now_radio_vo_ = null
		let item1_: BaseAwardItem = null
		let item2_: BaseAwardItem = null
		this.preload_server_config = {
			"config_kf_1vn_bet": false,
			"config_kf_1vn_bet_opt": false,
			"config_kf_1vn_match": false
		}
		this.is_center = true

		this.load_callback = () => {
			SetHtmlStyle(this.stage_label, { c: "#663915", f: 22, ww: false, w: 300 })
			SetHtmlStyle(this.leader, { c: "#663915", f: 22, ww: false, w: 300 })
			SetHtmlStyle(this.left_time, { c: "#0a953e", f: 22, ww: false, w: 720 })
			SetHtmlStyle(this.right_get, { c: "#d15e00", f: 20, ww: false, w: 300 })
			SetHtmlStyle(this.error_get, { c: "#d15e00", f: 20, ww: false, w: 300 })
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1111, GameResPath.GetIcon("kf1vn", "ui_notice_03"))
			this.LoadSuccess()
			this.InitEvent()
		}

		this.GetDefendNumByTurn = (turn?) => {
			let num = 0
			let config_kf_1vn_match = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_match", false)
			if (config_kf_1vn_match) {
				num = (config_kf_1vn_match[turn] && (config_kf_1vn_match[turn].c_num) || (0))
			}
			return num
		}


		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			this.CancelTimer()
			this.ClearItemList()
			for (let _tmpi in money_item_list_) {
				var item = money_item_list_[_tmpi]
				item.DeleteMe()
				item = null
			}
			money_item_list_ = []
			if (item1_) {
				item1_.DeleteMe()
				item1_ = null
			}
			if (item2_) {
				item2_.DeleteMe()
				item2_ = null
			}
			now_radio_vo_=null
		}

		this.LoadSuccess = () => {
			let size = 30
			item_list_ = []
			money_item_list_ = []
			now_select_id_ = null
			now_radio_vo_ = null
			item1_ = new BaseAwardItem(this.get_icon)
			item1_.Load()
			item1_.SetItemSize(size, size)
			item1_.SetItembgVisible(false)
			item1_.SetData(Kf1vnModel.ZhanHunTypeId)

			item2_ = new BaseAwardItem(this.get_icon2)
			item2_.Load()
			item2_.SetItemSize(size, size)
			item2_.SetItembgVisible(false)
			item2_.SetData(Kf1vnModel.ZhanHunTypeId)

			//LayoutRebuilder(this._Group1)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true)

			Util.AddClickEvent(this.quizBtn, () => {
				if(!now_radio_vo_){
					Message.show("请选择竞猜金额~")
					return
				}
				if (((now_select_id_ && now_radio_vo_) && model.stage_info) && data_) {
					let ok_func = () => {
						//console.log("11111111111111111//-:", model.stage_info.turn, data_.battle_id, now_select_id_, now_radio_vo_[0])
						if (model.stage_info && data_ && now_select_id_ && now_radio_vo_ && now_radio_vo_[0]) {
							//console.log("22222222222222222222")
							model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62118, "hhcc", model.stage_info.turn, data_.battle_id, now_select_id_, now_radio_vo_[0])
						}
						this.Close()
					}

					let check_func = (bool?) => {
						model.not_show_diamond_cost_alert = bool
					}

					let done_fun = () => {
						if(!now_radio_vo_ || !now_radio_vo_[1]) return
						let cost_cfg = now_radio_vo_[1][0]
						if (cost_cfg && cost_cfg[0] == 2) {
							let enough, gap = shop_model.MoneyIsEnough(2, cost_cfg[2])
							if (!enough) {
								let diamond_enough, gap2 = shop_model.MoneyIsEnough(1, gap)
								if (diamond_enough) {
									if (model.not_show_diamond_cost_alert == false) {
										let str = "当前绑玉数量不足，是否消耗<font color='#639c12'>" + gap + "勾玉</font>代替？"
										let content = Util.StrToHTML(str)
										Alert.Show(content, Alert_Type.Two, ok_func, null, "确定", "取消")
										Alert.SetIsCharge(true)
									} else {
										ok_func()
									}
								} else {
									ok_func()
								}
							} else {
								ok_func()
							}
						} else {
							ok_func()
						}
					}

					if (model.show_quiz_alert) {
						let str = Util.StrToHTML("竞猜后只获得战印值，所消耗的勾玉/绑玉<font color='#ff4f50'>均不返还</font>(战印值可用于兑换珍贵道具)")
						Alert.Show(str, Alert_Type.AlertTypeCheckBox, () => {
							done_fun()
						}
							, null, "确定", "取消", null, false, (bool?) => {
								model.show_quiz_alert = !bool
							}
							, "本次登录不再提示")
					} else {
						done_fun()
					}
				} else if (!now_select_id_) {
					Message.show("请选择支持的一方")
				}
			}
				, this, true)

			this.BindEvent(model, Kf1vnEvent.KF1VN_SELECT_RADIO_ITEM, (id?, vo?) => {
				now_radio_vo_ = vo
				this.SetWinAndLoseCanGet(id, vo)
			}
			)
		}

		this.Local_Open = (parms?) => {
			data_ = parms && parms[0] || null
			super.Open()
		}

		this.OpenCallback = () => {
			if (!data_) {
				return
			}
			this.leader.innerHTML = Util.StrToHTML("擂主：<font color='#d15e00'>" + data_.name + "</font>")
			if (model.stage_info && model.stage_info.stage == 5) {
				let num = this.GetDefendNumByTurn(model.stage_info.turn)
				this.stage_label.innerHTML = Util.StrToHTML("阶段：<font color='#d15e00'>1v" + num + "</font>")
				this.StartTimer()
			}
			this.SetSelectList()
			this.SetQuizAmount()
		}

		this.StartTimer = () => {
			this.CancelTimer()
			let time_fun = () => {
				this.OnTime()
			}
			left_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}

		this.OnTime = () => {
			if (model.stage_info && model.stage_info.stage == 5) {
				let left_time = model.stage_info.sub_edtime - TimeUtil.getServerTime()
				let str = model.GetQuizTitleByTurn(model.stage_info.turn)
				if (left_time <= 0) {
					this.CancelTimer()
					this.left_time.innerHTML = ""
					this.Close()
				} else {
					this.left_time.innerHTML = Util.StrToHTML(`${str}${HtmlColorTxt(`（剩余${left_time}秒）`, "'#b76f00'")}`)
					SetHtmlCenter(this.left_time, { x: 0, w: 720 })
				}
			} else {
				this.CancelTimer()
			}
		}

		this.CancelTimer = () => {
			if (left_time_id_) {
				GlobalTimerQuest.CancelQuest(left_time_id_)
				left_time_id_ = null
			}
		}

		this.ClearItemList = () => {
			if (this.item_select_mgr) {
				this.item_select_mgr.DeleteMe()
				this.item_select_mgr = null
			}
		}

		this.SetSelectList = () => {
			if (model.stage_info) {
				let quiz_list = this.GetQuizListByTurn(model.stage_info.turn)
				if (!quiz_list || quiz_list.length <= 0) return
				if (!this.item_select_mgr) {
					this.item_select_mgr = new LoopScrowViewMgr()
					this.item_select_mgr.SetData(this.Content, Kf1vnQuizSelectItem, quiz_list, LoopScrCon.Vertical, 1, (index?) => {
						if (quiz_list && index < quiz_list.length) {
							now_select_id_ = quiz_list[index].opt
						}

					})
				} else {
					this.item_select_mgr.replaceAll(quiz_list)
				}

			}
		}

		this.SetQuizAmount = () => {
			let turn =(model.stage_info && (model.stage_info.turn) || (1))
			let list = this.GetQuizCostList(turn)
			if (list) {
				let vo = null
				let item: Kf1vnQuizRadioItem = null
				let count = 0
				let i = 0
				do {
					vo = list[i]
					item = money_item_list_[i]
					if (!item) {
						item = new Kf1vnQuizRadioItem(this.radio_conta)

						item.ExcuteCallback(() => {
							count++
							if (count >= list.length) {
								if (!now_radio_vo_ && list[0]) {
									model.Fire(Kf1vnEvent.KF1VN_SELECT_RADIO_ITEM, list[0][0], list[0])
								}
							}
						}
						)
						item.Load()
						money_item_list_[i] = item
					}
					item.SetData(vo)
					i = i + 1
				} while ((i < list.length))

			}
		}

		this.SetWinAndLoseCanGet = (id?, vo?) => {
			let num = "无"
			let num2 = "无"
			if (vo) {
				if (vo[2] && vo[2][0]) {
					let basic = goods_model.GetGoodsBasicByTypeId(vo[2][0][1])
					if (basic) {
						num = vo[2][0][2] + basic.goods_name
					}
				}
				if (vo[3] && vo[3][0]) {
					let basic = goods_model.GetGoodsBasicByTypeId(vo[3][0][1])
					if (basic) {
						num2 = vo[3][0][2] + basic.goods_name
					}
				}
			}
			this.right_get.innerHTML = num + ""
			this.error_get.innerHTML = num2 + ""
		}

		this.GetQuizCostList = (turn?) => {
			let cost_list = null
			let config_kf_1vn_bet = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_bet", false)
			if (config_kf_1vn_bet) {
				let cfg = config_kf_1vn_bet[turn]
				if (cfg) {
					cost_list = JSON.parse(cfg.cost_list)
				}
			}
			return cost_list
		}

		this.GetQuizListByTurn = (turn?) => {
			let quiz_list = []
			let config_kf_1vn_bet = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_bet", false)
			let config_kf_1vn_bet_opt = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_bet_opt", false)
			if (config_kf_1vn_bet && config_kf_1vn_bet_opt) {
				let cfg = config_kf_1vn_bet[turn]
				if (cfg) {
					let opt_list = JSON.parse(cfg.opt_list)
					if (opt_list) {
						for (let _tmpi in opt_list) {
							var vo = opt_list[_tmpi]
							let obj = config_kf_1vn_bet_opt[turn + "@" + vo[0]]//@@@
							if (obj) {
								table.insert(quiz_list, obj)
							}
						}
					}
				}
			}
			return quiz_list
		}

	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_Image1: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	_Image1111: Laya.Image
	closeBtn: Laya.Image
	_Image3: Laya.Image
	Content: Laya.List
	stage_label: Laya.HTMLDivElement
	leader: Laya.HTMLDivElement
	_Label1: Laya.Label
	get_icon: Laya.Box
	right_get: Laya.HTMLDivElement
	_Label2: Laya.Label
	get_icon2: Laya.Box
	error_get: Laya.HTMLDivElement
	_Label3: Laya.Label
	left_time: Laya.HTMLDivElement
	radio_conta: Laya.HBox
	quizBtn: Laya.Box
	_Image1_btn: Laya.Image
	btn_text: Laya.Label
	tips: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this.img_title,
			this.lb_title,
			this._Image1111,
			this.closeBtn,
			this._Image3,
			this.Content,
			this.stage_label,
			this.leader,
			this._Label1,
			this.get_icon,
			this.right_get,
			this._Label2,
			this.get_icon2,
			this.error_get,
			this._Label3,
			this.left_time,
			this.radio_conta,
			this.quizBtn,
			this._Image1_btn,
			this.btn_text,
			this.tips,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"img_title",
				"lb_title",
				"_Image1111",
				"closeBtn",
				"_Image3",
				"Content",
				"stage_label",
				"leader",
				"_Label1",
				"get_icon",
				"right_get",
				"_Label2",
				"get_icon2",
				"error_get",
				"_Label3",
				"left_time",
				"radio_conta",
				"quizBtn",
				"_Image1_btn",
				"btn_text",
				"tips",
			])
	}
}
window["Kf1vnQuizSelectView"] = Kf1vnQuizSelectView