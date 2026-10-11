import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Color, Util } from "../util/Util"
import { SelectItem } from "./SelectItem"

export class SelectView extends BaseView1 {
	_Group1: Laya.HBox
	_btn_radio2: Laya.Box
	_img_radio2: Laya.Image
	_check_radio2: Laya.Image
	_lb_radio2: Laya.Label
	_btn_radio1: Laya.Box
	_img_radio1: Laya.Image
	_check_radio1: Laya.Image
	_lb_radio1: Laya.Label
	_btn_radio0: Laya.Box
	_img_radio0: Laya.Image
	_check_radio0: Laya.Image
	_lb_radio0: Laya.Label
	_img_bg0: Laya.Image
	_img_bg1: Laya.Image
	_Image1: Laya.Image
	_btn_cancel: Laya.Box
	_img_cancel: Laya.Image
	_lb_cancel: Laya.Label
	_btn_enter: Laya.Box
	_img_enter: Laya.Image
	_lb_enter: Laya.Label
	_list_reward: Laya.List
	Emp_btn_cancel
	Emp_btn_enter
	InitEvent
	InitGradeDic
	InitView
	LoadSuccess
	Open
	Out_lb_cancel
	Out_lb_enter
	Out_lb_radio0
	Out_lb_radio1
	Out_lb_radio2
	RefRadioBtn
	RefSelectReward
	Remove
	Scr_scr_reward
	Select_Callback
	_vp_reward
	getSource
	tog_btn_radio0
	tog_btn_radio1
	tog_btn_radio2
	SetTabState

	public constructor() {
		super()


		this.base_file = "optionalLotto"
		this.layout_file = "SelectView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.show_open_movie = true
		this.click_bg_toClose = true

		let model = CustomActivityModel.GetInstance()
		let _soureArr = null
		let pool_dic = []
		let select_rare = 2
		let rare_select_num = []
		let rare_need_num = []
		let select_grade = {}
		let base_type = null
		let sub_type = null
		let info = null
		let data = null
		let select_list = { "0": false, "1": false, "2": false }
		this.load_callback = () => {

			//this.RegisterMask(this._vp_reward)

			this.SetTabState()

			this.LoadSuccess()
			this.InitView()
			this.InitEvent()
		}

		//this.open_callback = () => {
		//}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Open = (...new_args) => {
			let args = new_args
			base_type = args[0]
			sub_type = args[1]
			select_rare = args[2]
			select_list[select_rare] = !select_list[select_rare]
			super.Open()
		}

		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("optionalLotto", "uisy_023"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("optionalLotto", "uisy_023"), true)
		}
		this.SetTabState = () => {
			for (let index in select_list) {
				this[`_lb_radio${index}`].color = select_list[index] ? "#ffffff" : "#4f538f"
				this[`_lb_radio${index}`].strokeColor = select_list[index] ? "#ad455c" : "#c6c3f4"
				this[`_check_radio${index}`].visible = select_list[index]
			}

		}

		this.InitEvent = () => {
			let RadioBtnCallBack = (sender?) => {
				select_rare = sender
				this.InitGradeDic()
				this.RefSelectReward()
				for (let index in select_list) {
					select_list[index] = false
				}
			}
			// this.tog_btn_radio0.onValueChanged.AddListener((value?) => {
			// 	if (value) {
			// 		RadioBtnCallBack(0)
			// 		this.Out_lb_radio0.effectColor = Color(210 / 255, 107 / 255, 64 / 255, 1)
			// 	} else {
			// 		this.Out_lb_radio0.effectColor = Color(136 / 255, 95 / 255, 76 / 255, 1)
			// 	}
			// })
			// this.tog_btn_radio1.onValueChanged.AddListener((value?) => {
			// 	if (value) {
			// 		RadioBtnCallBack(1)
			// 		this.Out_lb_radio1.effectColor = Color(210 / 255, 107 / 255, 64 / 255, 1)
			// 	} else {
			// 		this.Out_lb_radio1.effectColor = Color(136 / 255, 95 / 255, 76 / 255, 1)
			// 	}
			// })
			// this.tog_btn_radio2.onValueChanged.AddListener((value?) => {
			// 	if (value) {
			// 		RadioBtnCallBack(2)
			// 		this.Out_lb_radio2.effectColor = Color(210 / 255, 107 / 255, 64 / 255, 1)
			// 	} else {
			// 		this.Out_lb_radio2.effectColor = Color(136 / 255, 95 / 255, 76 / 255, 1)
			// 	}
			// })
			Util.AddClickEvent(this._btn_radio2, () => {
				if (select_list[2]) return
				RadioBtnCallBack(2)
				select_list[2] = !select_list[2]
				this.SetTabState()
			}
				, this, false)
			Util.AddClickEvent(this._btn_radio1, () => {
				if (select_list[1]) return
				RadioBtnCallBack(1)
				select_list[1] = !select_list[1]
				this.SetTabState()
			}
				, this, false)
			Util.AddClickEvent(this._btn_radio0, () => {
				if (select_list[0]) return
				RadioBtnCallBack(0)
				select_list[0] = !select_list[0]
				this.SetTabState()

			}
				, this, false)

			Util.AddClickEvent(this._btn_cancel, () => {
				this.Close()
			}
				, this, true)

			Util.AddClickEvent(this._btn_enter, () => {
				if (!data) {
					return
				}
				let random_pool = []
				for (let i in select_grade) {

					let v = select_grade[i]
					table.insert(random_pool, v)
				}
				if (random_pool.length > 0) {
					let sort = (a?, b?) => {
						return a.grade < b.grade
					}
					table.sort(random_pool, sort)
					data.random_pool = random_pool
					model.SetActData(data)
					model.Fire(CustomActivityDefine.EVENT.UPDATE_VIEW, base_type, sub_type, 33139)
				}
				this.Close()
			}
				, this, true)
		}

		this.Select_Callback = (grade_info?) => {
			if (data && data.pool && data.pool.length != 0) {
				Message.show("奖池锁定,重置奖励方可重选")
				return
			}
			let rare = select_rare
			let need_num = rare_need_num[rare]
			let select_num = rare_select_num[rare]
			let v = grade_info
			if (!v) {
				return
			}
			if (Number(need_num) == Number(select_num) && !select_grade[v.grade]) {
				Message.show("该类型奖励已选满")
			} else {
				if (select_grade[v.grade]) {
					delete select_grade[v.grade]
					//select_grade[] = null
				} else {
					select_grade[v.grade] = v
				}
				this.RefRadioBtn()
				this.RefSelectReward()
			}
		}

		this.InitView = () => {
			if (base_type == null || sub_type == null) {
				return
			}
			info = model.GetActInfo(base_type, sub_type)
			data = model.GetActData(base_type, sub_type)
			if (!info || !data) {
				return
			}
			this.InitGradeDic()
			this.RefRadioBtn(true)
			let source = this.getSource()
			_soureArr = new LoopScrowViewMgr()
			_soureArr.SetData(this._list_reward, SelectItem, source, LoopScrCon.Vertical)
		}

		this.getSource = () => {
			if (!pool_dic) {
				return
			}
			let rare = select_rare
			let list = pool_dic[rare]
			let _soure = []
			if (list) {
				for (let i in list) {

					list[i].rare_select_num = rare_select_num
					list[i].select_grade = select_grade
					list[i].base_type = base_type
					list[i].sub_type = sub_type
					list[i].need_num = rare_need_num
					list[i].rare = rare
					list[i].Select_Callback = (grade_info?) => {
						this.Select_Callback(grade_info)
					}
					table.insert(_soure, list[i])
				}
			}
			return _soure
		}

		this.InitGradeDic = () => {
			if (!data || !data.reward_list || data.reward_list.length == 0) {
				return
			}
			let b = base_type
			let s = sub_type
			for (let _tmpi in data.reward_list) {
				var v = data.reward_list[_tmpi]
				let grade = v.grade
				let cond = v.condition
				if (cond) {
					if (cond.match("stage") == null) {
						let _cond = model.GetActCondition(b, s, "data", grade)
						if (_cond && _cond.rare) {
							let key = Number(_cond.rare)
							pool_dic[key] = pool_dic[key] || {}
							pool_dic[key][grade] = v
						}
					}
				}
			}
		}

		this.RefRadioBtn = (bool?) => {
			let cond = model.GetActCondition(base_type, sub_type, "info")
			if (!cond || !data) {
				return
			}
			let pool = null
			if (!Util.IsTableEmpty(select_grade)) {
				pool = select_grade
			} else if (data.pool.length > 0) {
				pool = data.pool
			} else if (data.pool.length == 0 && data.random_pool && bool) {
				pool = data.random_pool
			}
			if (pool) {
				for (let i in pool) {

					let v = pool[i]
					select_grade[v.grade] = v
				}
			}
			for (let i = 0; i <= 2; i++) {
				let num = 0
				if (pool) {
					for (let key in pool) {

						let v = pool[key]
						if (v.rare == i) {
							num = num + 1
						}
					}
				}
				rare_select_num[i] = num
				let name = null
				if (i == 0) {
					name = "稀有"
				} else if (i == 1) {
					name = "史诗"
				} else {
					name = "传说"
				}
				let need_num = cond["rare_" + i]
				rare_need_num[i] = Number(need_num)
				this["_lb_radio" + i].text = name + "(" + num + "/" + need_num + ")"
			}
		}

		this.RefSelectReward = () => {
			if (_soureArr) {
				_soureArr.replaceAll(this.getSource())
			}
		}


		this.Remove = () => {
			if (_soureArr) {
				_soureArr.DeleteMe()
				_soureArr = null
			}
			// this.tog_btn_radio0.onValueChanged.RemoveAllListeners()
			// this.tog_btn_radio1.onValueChanged.RemoveAllListeners()
			// this.tog_btn_radio2.onValueChanged.RemoveAllListeners()
			select_rare = 2
			pool_dic = []
			rare_select_num = []
			rare_need_num = []
			select_grade = {}
		}
	}


	public GetComponents() {
		[
			this._Group1,
			this._btn_radio2,
			this._img_radio2,
			this._check_radio2,
			this._lb_radio2,
			this._btn_radio1,
			this._img_radio1,
			this._check_radio1,
			this._lb_radio1,
			this._btn_radio0,
			this._img_radio0,
			this._check_radio0,
			this._lb_radio0,
			this._img_bg0,
			this._img_bg1,
			this._Image1,
			this._btn_cancel,
			this._img_cancel,
			this._lb_cancel,
			this._btn_enter,
			this._img_enter,
			this._lb_enter,
			this._list_reward,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_btn_radio2",
				"_img_radio2",
				"_check_radio2",
				"_lb_radio2",
				"_btn_radio1",
				"_img_radio1",
				"_check_radio1",
				"_lb_radio1",
				"_btn_radio0",
				"_img_radio0",
				"_check_radio0",
				"_lb_radio0",
				"_img_bg0",
				"_img_bg1",
				"_Image1",
				"_btn_cancel",
				"_img_cancel",
				"_lb_cancel",
				"_btn_enter",
				"_img_enter",
				"_lb_enter",
				"_list_reward",
			])
	}
}
window["SelectView"] = SelectView