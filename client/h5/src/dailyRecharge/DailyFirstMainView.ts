import config from "../../node_modules/simple-git/dist/src/lib/tasks/config"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { AtlasUrl, Color, RefBoxChildsLayout, SetHtmlCenter, SetLocalPosition, Util,TransformCurrency } from "../util/Util"
import { DailyFirstBaseReward } from "./DailyFirstBaseReward"
import { DailyFirstBtnItem } from "./DailyFirstBtnItem"
import { DailyFirstReward } from "./DailyFirstReward"
import { Config } from "../common/Config"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { TimeUtil } from "../util/TimeUtil"
import { PlatformManager } from "../PlatformManager"

export class DailyFirstMainView extends BaseView1 {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_Image: Laya.Image
	_gp_accm_reward: Laya.Box
	_gp_grade1: Laya.Box
	_gp_grade2: Laya.Box
	_gp_grade3: Laya.Box
	_Image2: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.List
	_img_close: Laya.Image
	_lb_dec: Laya.HTMLDivElement
	_gp_btn: Laya.Box
	_btn_recharge: Laya.Box
	_Image11: Laya.Image
	btn_effect: Laya.Box
	labelDisplay: Laya.Label
	_gp_btn_effect: Laya.Box
	_img_red: Laya.Image
	meinv: Laya.Image
	money: Laya.Label
	_img_effect_bg: Laya.Image
	_img_limite_get: Laya.Image
	_img_reward: Laya.Image
	_img_tittle: Laya.Image
	html_tommory_reward: Laya.HTMLDivElement
	box_lb_dec: Laya.Box
	box_tommory_reward: Laya.Box
	box_money: Laya.Box


	ClearView
	CreateAwardItem
	CreateGradeGp
	GetSelectValue
	InitEvnet
	InitView
	OpenRewardView
	SetActInfo
	SetBtnInfo
	SwicthBtn
	SwicthGrade
	SwicthRechargeReward
	UpdateGradeBtnRed
	not_show_main_msg
	loop_mgr
	fly_list
	cfg
	ChangeRewardAndTittleTag
	tween_id_
	GetNextRewardTypeText
	IsLastDay

	public constructor() {
		super()
		let model = CustomActivityModel.GetInstance()
		let local_Number = Number
		let goods_model = GoodsModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let _daily_reward_list = []
		let _daily_grade_gp_list = []
		let _daily_grade_list = []
		let _accm_reward_item = null
		let _act_info = null
		let _act_data = null
		let _select_grade = 0
		this.base_file = "dailyRecharge"
		this.layout_file = "DailyFirstMainView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.not_show_main_msg = true
		let cur_sorting_order = null
		this.destroy_imm = true
		this.load_callback = () => {
		this.tween_id_ = 0

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_dec.size  = 18
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_dec.size  = 16
			// 	this._lb_dec.lineSpacing = 0.8
			// 	let csf = this._lb_dec.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDeltaX(this._lb_dec, 462.58)
			// 	SetAnchoredPositionY(this._lb_dec,-555.8)
			// }
			_daily_grade_gp_list = [this._gp_grade1, this._gp_grade2, this._gp_grade3]
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dailyRecharge", "mrsc_002"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("dailyRecharge", "mrsc_001"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image, GameResPath.GetIcon("dailyRecharge", "ui_ gift_02"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_effect_bg, GameResPath.GetIcon("dailyRecharge", "ui_First_012"), true)
			SetLocalPosition(this._img_reward, 148, 410)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.meinv, GameResPath.GetIcon("dailyRecharge", "mv"), true)
		}


		this.open_callback = () => {
			//cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this.InitEvnet()
			this.InitView()
		}

		this.destroy_callback = () => {
			this.ClearView()
		}

		this.InitView = () => {
			if (!_act_info) {
				return
			}
			_act_data = model.GetActData(_act_info.base_type, _act_info.sub_type)
			if (!_act_data) {
				return
			}
			_accm_reward_item = new DailyFirstReward(this._gp_accm_reward)
			_accm_reward_item.Load()
			_accm_reward_item.ExcuteCallback(() => {
				_accm_reward_item.SetData(_act_data.reward_list, _act_info.base_type, _act_info.sub_type)
			}
			)
			//this.RegisterMask(this._gp_reward)
			this.GetSelectValue(true)
			this.CreateGradeGp()
			this.SwicthGrade(_select_grade)
			this.ChangeRewardAndTittleTag(_act_info.sub_type)
			if (!this.tween_id_) {
				let end_value = this._img_reward.y + 20;
				this.tween_id_ = SYTweenLite.to(this, this._img_reward, SYTweenLite.UiAnimationType.POSY, end_value, 3, null, SYTweenFunc.PINGPONG, true)
			}
			
		}

		this.ChangeRewardAndTittleTag = (sub_type)=>{
			this.cfg = model.GetDailyChargeConfig(this.layout_file)
			if(!this.cfg){
				return
			}
			let cfg_data = this.cfg[sub_type]
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			this.html_tommory_reward.style.color = "#663915"
			this.html_tommory_reward.style.fontSize = 18
			this.html_tommory_reward.style.wordWrap = false
			this.html_tommory_reward.style.leading = 5
			for (let key in cfg_data) {
				let vo = cfg_data[key]
				let min_day = vo.open_day[0]
				let max_day = vo.open_day[1]
				if(open_day <= max_day && open_day >= min_day){
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward, GameResPath.GetIcon("dailyRecharge", vo.show_img), false)
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tittle, GameResPath.GetIcon("dailyRecharge", vo.show_tag), false)
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_limite_get, GameResPath.GetIcon("dailyRecharge", vo.show_tag2), true)
					let bool = this.IsLastDay() //为true，需要特殊处理
					if(bool){
						this.html_tommory_reward.innerHTML = this.GetNextRewardTypeText(open_day, this.cfg)
					}else{
						this.html_tommory_reward.innerHTML = vo.tomorrow_tex
					}
					break
				}
			}
			RefBoxChildsLayout(this.box_tommory_reward, 0, null, true, "center")
		}

		//last_day_star：活动结束最后一天刚开始开始的时间戳
		//可以理解为活动1月31号结束，然后这个时间戳是拿的1月30-1月31号00点
		this.IsLastDay = ()=> {
			let end_time = _act_info.etime
			let day = 1
			let one_day = day * 24 * 3600
			let last_day_star = end_time - one_day
			let current_time = TimeUtil.getServerTime()
			if(last_day_star < current_time && current_time <= end_time){
				return true
			}
			return false
		}

		this.GetNextRewardTypeText =(open_day,cfg_data) =>{
			let cond_data = ErlangParser.GetInstance().Parse(_act_info.condition)
			let sub_type = null
			for (let key in cond_data) {
				let vo = cond_data[key]
				if(vo[0] == "next_subtype"){
					sub_type = Number(vo[1])
				}
			}
			let new_cfg = cfg_data[sub_type]
			let tommory_text = null
			for (let key in new_cfg) {
				let vo = new_cfg[key]
				let min_day = vo.open_day[0]
				let max_day = vo.open_day[1]
				if(open_day <= max_day && open_day >= min_day){
					tommory_text = vo.tomorrow_tex
					break
				}
			}
			return tommory_text
		}

		this.GetSelectValue = (is_frist?) => {
			let grades = _act_data.reward_infos
			for (let i in grades) {

				if (grades[i].state == 1) {
					_select_grade = grades[i].id - 1
					return
				}
			}
			for (let i in grades) {

				if (grades[i].state == 0) {
					_select_grade = grades[i].id - 1
					return
				}
			}
			if (!is_frist) {
				return
			}
			_select_grade = 0
		}

		this.CreateGradeGp = () => {
			for (let index in _daily_grade_gp_list) {

				// [ts2lua]_daily_grade_gp_list下标访问可能不正确
				let btn_item = new DailyFirstBtnItem(_daily_grade_gp_list[index])
				btn_item.Load()
				btn_item.ExcuteCallback(() => {
					btn_item.SetData(local_Number(index) == _select_grade, local_Number(index))
				})
				table.insert(_daily_grade_list, btn_item)
				// [ts2lua]_act_data.reward_infos下标访问可能不正确
				let grade_info = _act_data.reward_infos[index]
			}
			this.UpdateGradeBtnRed()
		}

		this.UpdateGradeBtnRed = (grade?) => {
			let grade_info = null
			if (grade) {
				// [ts2lua]_act_data.reward_infos下标访问可能不正确
				grade_info = _act_data.reward_infos[grade]
				// [ts2lua]_daily_grade_list下标访问可能不正确
				let item = _daily_grade_list[grade - 1]
				if (!item) {
					return
				}
				// [ts2lua]lua中0和空字符串也是true，此处grade_info.state == 1需要确认
				item.SetRedDot((grade_info.state == 1 && (true) || (false)))
				return
			}
			for (let index in _daily_grade_list) {

				// [ts2lua]_act_data.reward_infos下标访问可能不正确
				grade_info = _act_data.reward_infos[index]
				// [ts2lua]_daily_grade_list下标访问可能不正确
				let item = _daily_grade_list[index]
				if (!item) {
					return
				}
				// [ts2lua]_daily_grade_list下标访问可能不正确
				// [ts2lua]lua中0和空字符串也是true，此处grade_info.state == 1需要确认
				_daily_grade_list[index].SetRedDot((grade_info.state == 1 && (true) || (false)))
			}
		}

		this.SwicthGrade = (grade?) => {
			if (!_act_data || !_act_data.reward_infos) {
				return
			}
			// [ts2lua]_act_data.reward_infos下标访问可能不正确
			let grade_info = _act_data.reward_infos[grade]
			if (grade_info) {
				this.SwicthBtn(grade_info)
				// [ts2lua]lua中0和空字符串也是true，此处local_Number(grade_info.val) >= local_Number(grade_info.max)需要确认
				let color = (local_Number(grade_info.val) >= local_Number(grade_info.max) ? ("#639c12") : ("#ff4f50"))

				this._lb_dec.style.fontSize = 20
				//this._lb_refresh_time.style.valign = "center"
				// this._lb_dec.style.color = "#663915"
				this._lb_dec.style.color = "#ffffff"
				this._lb_dec.width = 500
				if (PlatformManager.IsEyouPlatform()) {
					this._lb_dec.innerHTML = Util.StrToHTML(Util.StrToHTML("Acc. Top-up of&nbsp;<font color='#cf4702'>" + Number(grade_info.max) / 10 + "0 Jade</font>&nbsp;to claim <br>the rewards below<font color='" + color + "'>(" + Number(grade_info.val) + "/" + Number(grade_info.max) + ")</font>"))
				} else {
				this._lb_dec.innerHTML = Util.StrToHTML(Util.StrToHTML("今日累充<font color='#ffe222'>" + Number(grade_info.max) / 10 + "元</font>可领取以下奖励")
					)
				}
				this.money.text = TransformCurrency(Number(grade_info.val)) + " 元"
				this.SwicthRechargeReward(grade_info)
				RefBoxChildsLayout(this.box_lb_dec, 0, null, true, "center")
				RefBoxChildsLayout(this.box_money, 0, null, true, "center")
			}
		}

		this.SwicthBtn = (grade_info?) => {
			let data = {
				// custom_sorting_order = cur_sorting_order,
				// load_call_back =() => {
				// 	// this.CoverEffect(this.labelDisplay,this.layer_value,cur_sorting_order+1)
				// 	// this.CoverEffect(this._img_red,this.layer_value,cur_sorting_order+1)
				// }
			}
			if (0 == grade_info.state) {
				this.SetBtnInfo("立即领取", false, "#c5373d", false)
				// this.AddUIEffect("UI_2004_2", this.layer_value, this.btn_effect, null, null, true,data)
				// this.AddUIEffect("UI_2004_3", this.layer_value, this._gp_btn_effect, null, null, true,data)
			} else if (1 == grade_info.state) {
				this.SetBtnInfo("领取", false, "#c5373d", true)
				// this.AddUIEffect("UI_2004_2", this.layer_value, this.btn_effect, null, null, true,data)
				// this.AddUIEffect("UI_2004_3", this.layer_value, this._gp_btn_effect,null, null, true,data)
			} else if (2 == grade_info.state) {
				this.SetBtnInfo("已领取", true, Color(144 / 255, 144 / 255, 144 / 255, 128 / 255), false)
				this.ClearUIEffect(this._gp_btn_effect)
				this.ClearUIEffect(this.btn_effect)
			}
		}

		this.SetBtnInfo = (content?, is_gray?, stokeColor?, is_red?) => {
			// let label = <Laya.Label>this._btn_recharge.getChildAt(2)
			this.labelDisplay.text = content
			// label.text = content
			this.labelDisplay.strokeColor = stokeColor
			//label.strokeColor = Color(130/255,171/255,32/255,128/255)
			Util.SetImageGray(this._Image11, is_gray)
			this._img_red.visible = is_red
			// SetLocalPosition(label, is_gray ? 40 : 50, 16)
		}

		this.SwicthRechargeReward = (grade_info?) => {
			if (_daily_reward_list.length > 0) {
				for (let i in _daily_reward_list) {

					_daily_reward_list[i].SetVisible(false)
				}
			}
			let reward_list = []
			let cond = ErlangParser.GetInstance().Parse(grade_info.condition)
			let rare
			if (cond && cond[2]) {
				rare = cond[2][1][0]
			}
			let rare_list = []
			let _list = []
			for (let _tmpi in grade_info.reward_list) {
				var reward = grade_info.reward_list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(reward.style, reward.typeId)
				let good_basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (!good_basic) {
					return
				}
				let goods_data = null
				goods_data = (goods_data ? (goods_data) : ({}))
				goods_data.type_id = type_id
				goods_data.count = reward.count
				goods_data.lock = lock
				goods_data.good_basic = good_basic
				if (rare) {
					for (let k in rare) {
						var v = rare[k]
						if (Number(v) == type_id) {
							goods_data.is_rare = true
						}
					}
				}
				if (goods_data.is_rare) {
					table.insert(rare_list, goods_data)
				} else {
					table.insert(_list, goods_data)
				}
			}
			let sortFunc = (a?, b?) => {
				return b.good_basic.color < a.good_basic.color
			}
			table.sort(_list, sortFunc)
			reward_list = rare_list.concat(_list)
			let index = 0
			let reward_dir = []
			for (let _tmpi in reward_list) {
				var reward = reward_list[_tmpi]
				if (reward.good_basic.max_overlap == 0) {
					let i = 0
					do {
						table.insert(reward_dir, { type_id: reward.type_id, good_num: 1, lock: reward.lock, rare: reward.is_rare })
						//this.CreateAwardItem(reward.type_id, 1, index, reward.lock, reward.is_rare)
						index = index + 1
						i = i + 1
					} while ((i < local_Number(reward.count))
					)
				} else {
					table.insert(reward_dir, { type_id: reward.type_id, good_num: reward.count, lock: reward.lock, rare: reward.is_rare })
					//this.CreateAwardItem(reward.type_id, reward.count, index, reward.lock, reward.is_rare)
					index = index + 1
				}
			}
			this.CreateAwardItem(reward_dir)
		}

		this.CreateAwardItem = (list) => {//type_id?, good_num?, index?, lock?, rare?

			this.fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(list, 1)
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, DailyFirstBaseReward, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)
			}

		}

		this.InitEvnet = () => {
			let onCloseBtnClick = () => {
				this.Close()
			}

			Util.AddClickEvent(this._img_close, onCloseBtnClick, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			let onRechargeBtnClick = () => {
				if (!_act_data || !_act_data.reward_infos) {
					return
				}
				let info = _act_data.reward_infos[_select_grade]
				if (!info) return
				if (0 == info.state) {
					OpenFun.OpenFunHandler(21)
				} else if (1 == info.state) {
					model.RequireGetAward(_act_info.base_type, _act_info.sub_type, _select_grade + 1)
				} else if (2 == info.state) {
					Message.show("已领取该奖励")
					//this:ClearUIEffect(this._gp_btn_effect)
				}
			}
			// [ts2lua]_act_data.reward_infos下标访问可能不正确


			Util.AddClickEvent(this._gp_btn, onRechargeBtnClick, this, true)
			for (let _tmpi in _daily_grade_gp_list) {
				var group = _daily_grade_gp_list[_tmpi]
				Util.AddClickEvent(group, (e?) => {
					for (let k in _daily_grade_gp_list) {
						var v = _daily_grade_gp_list[k]
						if (v == e.currentTarget && _select_grade != Number(k)) {
							_select_grade = Number(k)
							model.Fire(local_CustomActivityDefine.EVENT.DAILYFRIST_SELECT, true, _select_grade)
							this.SwicthGrade(_select_grade)
						}
					}
				}
					, this, true)
			}
			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, grade?) => {
				if (base_type == _act_info.base_type && sub_type == _act_info.sub_type) {
					let reward = this.OpenRewardView(base_type, sub_type, grade)
					this.GetSelectValue(false)
					if (grade <= 3) {
						this.UpdateGradeBtnRed(_select_grade)
						// [ts2lua]_daily_grade_list下标访问可能不正确
						_daily_grade_list[grade - 1].SetRedDot(false)
						model.Fire(local_CustomActivityDefine.EVENT.DAILYFRIST_SELECT, true, _select_grade)
						this.SwicthGrade(_select_grade)
					}
					_accm_reward_item.UpdateView(_act_data.reward_list, _act_info.base_type, _act_info.sub_type)
					if (reward.length == 0) {
						return
					}
					let view = new CongratulationObtainView(reward, 10)
					view.Open()


					//飘字特效
					let fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(reward)
					CustomActivityModel.GetInstance().ShowActFlyReward(fly_list, this._gp_btn)
				}
			}
			)
			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_DAYILY_FIRST_VIEW, (base_type?, sub_type?) => {
				// if (base_type == _act_info.base_type && sub_type == _act_info.sub_type) {
					if (!_act_data) {
						this.InitView()
						return
					}
					_act_data = model.GetActData(base_type, sub_type)
					this.SwicthGrade(_select_grade)
					this.ChangeRewardAndTittleTag(sub_type)
					this.UpdateGradeBtnRed()
					_accm_reward_item.UpdateView(_act_data.reward_list, base_type, sub_type)
				// }
			}
			)
		}

		this.OpenRewardView = (base_type?, sub_type?, grade?) => {
			let reward_list = []
			let list = []
			if (grade <= 10) {
				list = _act_data.reward_infos
			} else {
				list = _act_data.reward_list
			}
			let reward = null
			for (let index in list) {

				// [ts2lua]list下标访问可能不正确
				if (list[index].id == grade) {
					// [ts2lua]list下标访问可能不正确
					list[index].state = 2
					// [ts2lua]list下标访问可能不正确
					reward = list[index].reward_list
					break
				}
			}
			for (let index in reward) {

				let dic = []
				// [ts2lua]reward下标访问可能不正确
				dic[0] = reward[index].style
				// [ts2lua]reward下标访问可能不正确
				dic[1] = reward[index].typeId
				// [ts2lua]reward下标访问可能不正确
				dic[2] = reward[index].count
				table.insert(reward_list, dic)
			}
			return reward_list
		}

		this.SetActInfo = (info?, parm?) => {
			if (!info) {
				return
			}
			_act_info = info
			if (parm.length > 0) {
				_select_grade = parm[0]
			}
		}

		this.ClearView = () => {
			if (_accm_reward_item) {
				_accm_reward_item.DeleteMe()
			}
			if (_daily_reward_list.length > 0) {
				for (let _tmpi in _daily_reward_list) {
					var reward = _daily_reward_list[_tmpi]
					reward.DeleteMe()
				}
				_daily_reward_list = []
			}
			if (_daily_grade_list.length > 0) {
				for (let _tmpi in _daily_grade_list) {
					var item = _daily_grade_list[_tmpi]
					item.DeleteMe()
				}
				_daily_grade_list = []
			}
			_daily_grade_gp_list = []
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}

			if (this.tween_id_) {
                SYTweenLite.Stop(this.tween_id_)
                this.tween_id_ = null
            }
		}
	}


	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._Image,
			this._gp_accm_reward,
			this._gp_grade1,
			this._gp_grade2,
			this._gp_grade3,
			this._Image2,
			this._Scroller1,
			this.Content,
			this._img_close,
			this._lb_dec,
			this._gp_btn,
			this._btn_recharge,
			this._Image11,
			this.btn_effect,
			this.labelDisplay,
			this._gp_btn_effect,
			this._img_red,
			this.meinv,
			this.money,
			this._img_effect_bg,
			this._img_limite_get,
			this._img_reward,
			this._img_tittle,
			this.html_tommory_reward,
			this.box_lb_dec,
			this.box_tommory_reward,
			this.box_money
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_Image",
				"_gp_accm_reward",
				"_gp_grade1",
				"_gp_grade2",
				"_gp_grade3",
				"_Image2",
				"_Scroller1",
				"Content",
				"_img_close",
				"_lb_dec",
				"_gp_btn",
				"_btn_recharge",
				"_Image11",
				"btn_effect",
				"labelDisplay",
				"_gp_btn_effect",
				"_img_red",
				"meinv",
				"money",
				"_img_effect_bg",
				"_img_limite_get",
				"_img_reward",
				"_img_tittle",
				"html_tommory_reward",
				"box_lb_dec",
				"box_tommory_reward",
				"box_money"
			])
	}
}
window["DailyFirstMainView"] = DailyFirstMainView