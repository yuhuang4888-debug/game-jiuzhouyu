import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, TransformCurrency, Util } from "../util/Util"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { OpenFun } from "../common/OpenFun"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { PlatformManager } from "../PlatformManager"

interface Args_list {
	desc: string,					//显示的描述
	enough: boolean,				//充值的金额是否足够
	canGet: boolean,				//是否可以领取
	config_reward_times: number, 	//单笔充值 配置的可领取次数
	reward_times: number, 			//单笔充值 已经领取次数	
	cycle_rank_buy: number 			//单笔充值 充值进度，玩家充值了多少次
}

export class AccumRechargeItem extends BaseItemRenderer {

	VHS_Scroller1
	_Viewport1
	_canGet
	_enough
	_model: CustomActivityModel
	parent_wnd
	_ac_item: LoopScrowViewMgr
	fly_list
	is_request = false
	WIDTH = 698
	HEIGT = 163
	public static width = 698
	public static height = 163

	public constructor(parent) {
		super()

		this._enough = false
		this._canGet = false
		this.base_file = "activity"
		this.layout_file = "AccumRechargeItem"

		this._model = CustomActivityModel.GetInstance()

		this.load_callback = () => {
			SetHtmlStyle(this._lb_progress, { c: "#663915", f: 22, ww: false, w: 250 })
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		this.InitEvent()
		ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("activity", "cjgh_002"))
	}

	public DeleteMe() {
		if (this._ac_item) {
			this._ac_item.DeleteMe()
			this._ac_item = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data.base_type == 109) {
				return true
			}

			let data = this.data
			let args_list: Args_list
			if(PlatformManager.IsEyouEnPlatform()){
				this._Image111.width = 581
			}else{
			this._Image111.width = 466
			}
			this._lb_task_pg.visible = false

			this._btn_get.y = this._btn_recharge.y = 73
			let html_color = "#ffea97"
			switch (this.data.base_type) {
				case 14:
					ResManager.GetInstance().SetImageSpriteTrans(this.base_item, this._Image111, GameResPath.GetIcon("activity", "cjgh_004"))
					this._lb_title.style.fontSize = 20
					this._lb_title.y = 13
					args_list = this.GetAccumRechargeArgs(data)
					this.SwitchBtnStyle(1)
					break;
				case 109:
					ResManager.GetInstance().SetImageSpriteTrans(this.base_item, this._Image111, GameResPath.GetIcon("activity", "cjgh_004"))
					this._lb_title.style.fontSize = 20
					this._lb_title.y = 16
					args_list = this.GetAccumRechargeArgs(data)
					this.SwitchBtnStyle(1)
					break;
				case 7:
					if (this.data.sub_type == 9) {
						ResManager.GetInstance().SetImageSpriteTrans(this.base_item, this._Image111, GameResPath.GetIcon("activity", "cjgh_004"))
						this._lb_title.style.fontSize = 20
					} else {
						ResManager.GetInstance().SetTexture(this.base_item, this._Image111, GameResPath.GetIcon("activity", "uidjtz_006"), null, this, true)
						this._lb_title.style.fontSize = 22
					}
					args_list = this.GetAccumRechargeArgs(data)
					this.SwitchBtnStyle(1)
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_SINGLE:
					ResManager.GetInstance().SetImageSpriteTrans(this.base_item, this._Image111, GameResPath.GetIcon("activity", "cjgh_004"))
					this._lb_title.style.fontSize = 22
					args_list = this.GetSingleRechargeArgs(data)

					//剩余次数
					let left_times = args_list.config_reward_times - args_list.reward_times

					//单次完成进度
					this._lb_task_pg.text = `(${args_list.cycle_rank_buy}/1)`
					this._lb_task_pg.color = data.status == 1 ? ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.GREEN) : ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED)
					this._lb_task_pg.visible = left_times > 0 && data.status.status != 2


					//剩余次数
					this._lb_progress.visible = left_times > 0 && left_times < 100
					let left_str = left_times > 0 ? HtmlColorTxt(left_times + "", Enum_ColorUtil_Dark.GREEN) : left_times + ""
					this._lb_progress.innerHTML = `剩余次数：${left_str}`
					SetHtmlCenter(this._lb_progress, { x: 0, w: 161, y: 0, h: 35 })

					//按钮和颜色设置
					this._btn_get.y = this._btn_recharge.y = 65
					this.SwitchBtnStyle(2)
					html_color = "#ffffff"
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_LOOP:
					ResManager.GetInstance().SetImageSpriteTrans(this.base_item, this._Image111, GameResPath.GetIcon("activity", "cjgh_004"))
					this._Image111.width = 338
					this._lb_title.style.fontSize = 22
					args_list = this.GetAccumRechargeArgs(data)
					this.SwitchBtnStyle(1)
					break;
				default:
					ResManager.GetInstance().SetTexture(this.base_item, this._Image111, GameResPath.GetIcon("activity", "uidjtz_006"), null, this, true)
					this._lb_title.style.fontSize = 22
					args_list = this.GetAccumRechargeArgs(data)
					this.SwitchBtnStyle(1)
					break;
			}



			//描述
			// this._lb_title.style.valign = "center"
			this._lb_title.style.color = html_color
			this._lb_title.width = 720
			this._lb_title.innerHTML = args_list.desc

			let enough = args_list.enough
			let canGet = args_list.canGet

			//红点
			this._reddot.visible = canGet && enough

			//领取
			this._btn_get.visible = canGet && enough

			//充点小钱
			this._btn_recharge.visible = canGet && !enough

			//已领取
			this._img_over.visible = !canGet


			//保存数据
			this._enough = enough
			this._canGet = canGet

			//奖励
			let rewards = this._model.GetActReward(data.base_type, data.sub_type, data.form_type, data.reward)
			this.UpdateItems(rewards)
		}
	}

	public SwitchBtnStyle(type) {
		if (type == 1) {
			this.labelDisplay.text = "充点小钱"
			ResManager.GetInstance().SetImageSprite(this, this._Image11, "common", "com_rect_btn2")
			this.labelDisplay.strokeColor = "#3e9298"
		} else {
			this.labelDisplay.text = "前往充值"
			ResManager.GetInstance().SetImageSprite(this, this._Image11, "common", "com_rect_btn2")
			this.labelDisplay.strokeColor = "#3e9298"
		}
	}


	/***累计充值 相关参数(常用的是这个函数)*/
	public GetAccumRechargeArgs(data) {
		let str_temp = ""
		let cond = CustomActivityModel.GetInstance().GetActCondition(data.base_type, data.sub_type, "data", data.grade)
		let is_today = cond.type && Number(cond.type) == 1
		let total = null
		if (is_today) {
			total = this._model.GetActRechargeDay()
		} else {
			total = this._model.GetActRecharge(data.base_type, data.sub_type)
		}
		total = total == null && 0 || total
		let target = is_today && Number(cond.today_gold) || Number(cond.gold)
		target = target == null && 0 || target
		target = Number(target)

		total = Number(total)
		let enough1 = total >= target
		let canGet1 = data.status != 2


		let str = HtmlColorTxt(TransformCurrency(total) + "/" + TransformCurrency(target), "'#ffffff'")
		let day_ref = is_today && "<font color='#ffffff'>(每天重置)</font>" || ""
		let desc1 = Util.StrToHTML("累计充值" + str + "元" + day_ref)

		let arg: Args_list = {
			desc: desc1,
			enough: enough1,
			canGet: canGet1,
			config_reward_times: 0,
			reward_times: 0,
			cycle_rank_buy: 0
		}


		return arg
	}


	/***单笔充值 相关参数*/
	public GetSingleRechargeArgs(data) {
		let str_temp = ""
		let cond = CustomActivityModel.GetInstance().GetActCondition(data.base_type, data.sub_type, "data", data.grade)
		// console.warn("测试@GetSingleRechargeArgs", cond, data)

		let enough1 = data.status >= 1
		let canGet1 = data.status != 2  //0是不可领取  1可领取  2已领取

		let cycle_rank_buy = cond.cycle_rank_buy[0][1] || 0
		let crb = cycle_rank_buy - data.receive_times
		let left_times = cond.reward_times - data.receive_times
		crb = Math.min(crb, left_times)

		let arg: Args_list = {
			desc: data.desc,
			enough: enough1,
			canGet: canGet1,
			config_reward_times: cond.reward_times,
			reward_times: data.receive_times,
			cycle_rank_buy: crb
		}


		return arg
	}



	public InitEvent() {

		Util.AddClickEvent(this._btn_get, () => {
			let data = this.data

			if (this._canGet || (this._enough && data.status == 0)) {
				this.is_request = true
				this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, data.base_type, data.sub_type, data.grade)
			}
			CustomActivityModel.GetInstance().SetActRedDot()

		}, this, true)

		Util.AddClickEvent(this._btn_recharge, () => {

			if(this.data){
				if(this.data.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_SINGLE){
					//特殊处理,强制打开充值界面，运营约定就处理这一个
					VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView", true)
				}
				else{
					OpenFun.OpenFunHandler(21)
				}
			}
		}, this, true)


		// this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
		// 	if (!this.data) return
		// 	if (this.data.base_type == base_type && this.data.sub_type == sub_type && this.is_request) {
		// 		this.is_request = false
		// 		CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this._btn_get)
		// 	}
		// })


		this.BindEvent(this._model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?) => {
			if (this.data&&this.data.base_type == base_type && this.data.sub_type == sub_type&&this.data.grade==result_data.grade) {
				//飘字特效
				CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this._btn_get)
			}
		})
	}
	public UpdateItems(list?) {
		let t_list = this._model.TransReward(list)
		this.fly_list = this._model.GetFlyRewardList(list)
		if (!this._ac_item) {
			this._ac_item = new LoopScrowViewMgr()
			this._ac_item.SetData(this._gp_reward, CommonRewardItem, t_list, LoopScrCon.Horizontal, 1)
		} else {
			this._ac_item.replaceAll(t_list)
		}
	}

	public UpdateBtn() {
		let data = this.data
		let cond = CustomActivityModel.GetInstance().GetActCondition(data.base_type, data.sub_type, "data", data.grade)
		let is_today = cond.type && Number(cond.type) == 1
		let total = null
		if (is_today) {
			total = this._model.GetActRechargeDay()
		} else {
			total = this._model.GetActRecharge(data.base_type, data.sub_type)
		}
		total = total == null && 0 || total
		let target = is_today && Number(cond.today_gold) || Number(cond.gold)
		target = target == null && 0 || target
		let enough = total >= target
		let canGet = data.status != 2
		this._reddot.visible = canGet && enough
		this._btn_get.visible = canGet && enough
		this._btn_recharge.visible = canGet && !enough
		this._img_over.visible = !canGet
	}



	_img_bg: Laya.Image
	_Image111: Laya.Image
	_img_over: Laya.Image
	_btn_recharge: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_btn_get: Laya.Box
	_Image1: Laya.Image
	_reddot: Laya.Image
	labelDisplay1: Laya.Label
	_gp_reward: Laya.List
	_lb_title: Laya.HTMLDivElement
	_lb_progress: Laya.HTMLDivElement
	_lb_task_pg: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._Image111,
			this._img_over,
			this._btn_recharge,
			this._Image11,
			this.labelDisplay,
			this._btn_get,
			this._Image1,
			this._reddot,
			this.labelDisplay1,
			this._gp_reward,
			this._lb_title,
			this._lb_progress,
			this._lb_task_pg,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image111",
				"_img_over",
				"_btn_recharge",
				"_Image11",
				"labelDisplay",
				"_btn_get",
				"_Image1",
				"_reddot",
				"labelDisplay1",
				"_gp_reward",
				"_lb_title",
				"_lb_progress",
				"_lb_task_pg",
			])
	}
}
window["AccumRechargeItem"] = AccumRechargeItem