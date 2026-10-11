import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { LuaSoundManager } from "../common/SoundManager"
import { DailyModel, ActivityType } from "../commonModel/DailyModel"
import { Kf1vnEvent, Kf1vnModel } from "../commonModel/Kf1vnModel"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { HtmlColorTxt, SetHtmlCenter, Util } from "../util/Util"

export class DailyReservationView extends BaseView1 {

	DesFunc
	InitEvent
	InitView
	_Local_Open

	public constructor() {
		super()

		this.base_file = "daily"
		this.layout_file = "DailyReservationView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		let activeData = null
		let itemList = []
		this.is_center = true
		let model = DailyModel.GetInstance()
		let sign_str = "前往报名"
		let ac_cfg = null
		this.load_callback = () => {

			this._Scroller1.hScrollBar.visible = false
			this.InitEvent()
		}
		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			this.DesFunc()
		}

		this._Local_Open = (parms?) => {
			if (parms && parms[0]) {
				activeData = parms[0]
			}
			super.Open()
		}

		this.InitView = () => {
			if (activeData && this.is_loaded) {
				let listData = model.daily_data[ActivityType.Limit]
				if (listData) {
					listData = listData.ac_list
				}

				if (listData) {
					for (let _tmpi in listData) {
						var vo = listData[_tmpi]
						if (vo.module == activeData.module && vo.module_sub == activeData.module_sub && vo.ac_sub == activeData.ac_sub) {
							ac_cfg = vo.ac_cfg
							break
						}
					}
				}
				if (ac_cfg) {
					let [str_arr, state] = model.GetTimeStr(ac_cfg.time_region)
					this.startLb.style.fontSize = 22
					this.startLb.width = 520
					this.startLb.style.color = "#663915"
					this.startLb.style.align = "center"
					this.startLb.style.valign = "middle"
					this.startLb.innerHTML = `(活动开始时间:${HtmlColorTxt(str_arr[0],Enum_ColorUtil_Dark.GREEN)})`
					SetHtmlCenter(this.startLb, { "x": 0, "w": 587 })
					this.startLb.style.padding = [(this.startLb.height - this.startLb.contextHeight) / 2, 0, 0, 0]
					let rewardList = JSON.parse(ac_cfg.sign_up_reward)
					let i = 0
					do {
						let item = itemList[i]
						if (!item) {
							item = new BaseAwardItem(this.Content)
							item.Load()
							itemList[i] = item
							item.SetScale(0.75)
						}
						item.SetData(rewardList[i][1], rewardList[i][2])
						i = i + 1
					} while ((i < rewardList.length))

					this.nameLb.style.fontSize = 22
					this.nameLb.style.leading = 8
					this.nameLb.width = 530
					this.nameLb.style.color = "#663915"
					this.nameLb.style.align = "center"
					this.nameLb.style.valign = "middle"
					this.nameLb.innerHTML = `${HtmlColorTxt(ac_cfg.ac_name ,Enum_ColorUtil_Dark.GREEN)}活动预约成功!<br/>参与活动可获得额外的报名奖励哦!`
					SetHtmlCenter(this.nameLb, { "x": 29, "w": 530 })
					this.nameLb.style.padding = [(this.nameLb.height - this.nameLb.contextHeight) / 2, 0, 0, 0]
					if (ac_cfg.module == 137) {
						// if (!DiamondFightModel.GetInstance().HasSignUp()) {
						// 	this.labelDisplay.text = "前往报名"
						// 	Util.AddClickEvent(this.enterBtn, () => {
						// 		this.Close()
						// 		OpenFun.OpenFunHandler(64)
						// 	}
						// 		, this, true)
						// }
					} else if (ac_cfg.module == 621) {
						// let kf_1vn_model = Kf1vnModel.GetInstance()
						// let flag = kf_1vn_model.page_info && kf_1vn_model.page_info.is_sign == 1
						// if (!flag) {
						// 	this.labelDisplay.text = sign_str
						// }
						}
					}
				}
			}


		this.InitEvent = () => {
			let closeFunc = () => {
				this.Close()
			}

			Util.AddClickEvent(this.closeBtn, closeFunc, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.enterBtn, ()=>{

				//1vn预约的时候顺手帮报名
				if (ac_cfg && ac_cfg.module == 621) {
					let kf_model = Kf1vnModel.GetInstance()
					if (kf_model.stage_info && kf_model.stage_info.stage == 1) {
						if (!kf_model.page_info || kf_model.page_info.is_sign == 0) {
							kf_model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62102)
						}
					}
				}
				// if(this.labelDisplay.text==sign_str){
				// 	OpenFun.OpenFunHandler(621)
				// }
				this.Close()
			}, this, true)
		}

		this.DesFunc = () => {
			if (itemList) {
				for (let _tmpi in itemList) {
					var vo = itemList[_tmpi]
					vo.DeleteMe()
				}
				itemList = []
			}
			activeData = null
		}
	}

	public Open(...new_args) {

		let param = new_args
		this._Local_Open(param)
	}

	_Image11: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_Image3: Laya.Image
	title_img: Laya.Image
	enterBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	closeBtn: Laya.Image
	nameLb: Laya.HTMLDivElement
	startLb: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Group1,
			this._Image3,
			this.title_img,
			this.enterBtn,
			this._Image1,
			this.labelDisplay,
			this.closeBtn,
			this.nameLb,
			this.startLb,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Group1",
				"_Image3",
				"title_img",
				"enterBtn",
				"_Image1",
				"labelDisplay",
				"closeBtn",
				"nameLb",
				"startLb",
				"_Scroller1",
				"Content",
			])
	}
}
window["DailyReservationView"] = DailyReservationView