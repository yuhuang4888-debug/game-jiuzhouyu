import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LinkTool } from "../common/LinkTool"
import { LinkViewType } from "../common/LinkViewType"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { EveningMainBaseView } from "../evening/EveningMainBaseView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { DestinyTurntableIcon } from "./DestinyTurntableIcon"
import { DestinyTurntableItem } from "./DestinyTurntableItem"

export class DestinyTurntableView extends BaseItem1 {
	Image: Laya.Image
	gp_pro: Laya.Box
	Image2: Laya.Image
	gp_bar_po: Laya.Box
	img_bar_po: Laya.Image
	Image31: Laya.Image
	Image4: Laya.Image
	Image5: Laya.Image
	img_bar: Laya.Image
	Image3: Laya.Image
	lb_pro: Laya.Label
	btn: Laya.Image
	img_left: Laya.Image
	img_right: Laya.Image
	img_title: Laya.Image
	Image6: Laya.Image
	gp_icon: Laya.HBox
	gp_item: Laya.Box
	red: Laya.Image
	Text1: Laya.Label
	lb_time: Laya.Label
	gp_effect: Laya.Box
	bar_effect: Laya.Box
	arrow: Laya.Box
	xianshi1: Laya.Image
	xianshi: Laya.Image
	btn_gift: Laya.Image
	gift_red: Laya.Image

	onTimer
	Animation
	InitEvent
	InitIcon
	InitIntegral
	InitItem
	LoadSuccess
	RemoveTimer
	ShowAnimation
	ShowReward
	SetDoublePoint
	HaveSameAct

	_speedTime
	base_type
	end_time
	reward_list
	running
	sub_type
	target_index

	gift_data

	have_double = true
	once_can_do = true
	jump_id_for_des = { "23": "vip卡", "191": "超值投资", "61": "月卡" }
	target_jump_id
	public constructor(parent?) {
		super(parent)

		this.base_file = "destinyTurntable"
		this.layout_file = "DestinyTurntableView"
		this.layer_value = Enum_UILayer.UI
		let model = CustomActivityModel.GetInstance()
		let timerid2 = null

		let icon_list = []
		let item_list = []
		let itemMax = 6
		let pos_list = [{ x: 70, y: 170 }, { x: 160, y: 5 }, { x: 75, y: -150 }, { x: -100, y: -150 }, { x: -185, y: 5 }, { x: -95, y: 170 }]
		let timerid = null
		let selectIndex = 0
		let lastItem = null
		let roundCount = 0 //转的圈数
		let roundCountMax = 2 //转的最大圈数
		let cacheSpeedIndex = null //缓存当前减速的索引
		let speedCount = 3 //减速个数
		let speedTime = 2 //减速停顿次数
		let clickTime = 0
		let otherJump = null   //66
		this.base_type = 99
		this.sub_type = 1
		let is_new_double_time = false
		let new_double_list = []

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
			let Mask_: Laya.Sprite;
			Mask_ = new Laya.Sprite();
			Mask_.graphics.drawRect(0, 0, 0, 200, "#ffffff");
			Mask_.pos(0, 0);
			this.img_bar.mask = Mask_

			// let effect_gp = this.bar_effect
			// effect_gp.width = Laya.stage.width
			// effect_gp.height = Laya.stage.height
			//this.AddUIEffect("UI_2038", effect_gp, null, 1, true)
		}
		this.preload_client_config = {
			"ClientLinK": false,
			"ClientDesTurnTablePoint": false
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btn, () => {
				if (this.running) {
					Message.show("抽奖中~")
					return
				}

				if (TimeUtil.getServerTime() - clickTime < 0.5) {
					return
				}
				clickTime = TimeUtil.getServerTime()

				let actData = model.GetActData(this.base_type, this.sub_type)
				let isMax = actData.turn > actData.max_turn
				if (isMax) {
					return
				}
				if (actData.point < actData.need_point) {
					//Message.show("天命值不足")
					Alert.Show("当前天命值不足，是否前往获取天命值？", Alert_Type.Two, () => {
						//OpenFun.OpenFunHandler(otherJump)
						LinkTool.GetInstance().ShowLinkView(LinkViewType.DestinyTurntable)
					}, null, "确定", "取消")
					return
				}
				model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33240, this.base_type, this.sub_type)
			}, this, true)

			Util.AddClickEvent(this.btn_gift, () => {
				if (this.gift_data) {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.base_type, this.sub_type, this.gift_data.grade)
				}else{
					Message.show("当前无免费奖励领取~")
				}	
			}, this, true)

			this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
				if (base_type == this.base_type && sub_type == this.sub_type) {
					this.SetDoublePoint()
					this.InitItem()
					this.InitIcon()
					this.InitIntegral()
				}
			})

			this.BindEvent(model, CustomActivityDefine.EVENT.DESTINY_TURNTABLE_INTEGRAL, () => {
				this.InitIntegral()
			})

			this.BindEvent(model, CustomActivityDefine.EVENT.DESTINY_TURNTABLE_RUN, (index?, scmd_reward?) => {
				this.ShowAnimation(index - 1)
				this.reward_list = ErlangParser.GetInstance().Parse(scmd_reward)
			})

			this.BindEvent(model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
				if (!this.base_type) return;
				if (this.base_type == base_type && this.sub_type == sub_type) {
					let rewards = model.GetActReward(reward_data.base_type, reward_data.sub_type, reward_data.form_type, reward_data.reward)
					new CongratulationObtainView(rewards, 10).Open()
					let moneys = [];
					let ids: number[] = [31, 34, 35];
					for (const iterator of rewards) {
						let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
						if (ids.indexOf(type_id_) != -1) {
							moneys.push(iterator);
						}
					}
	
					if (moneys && moneys.length > 0) {
						if (result_data.grade == 0) { // 0是免费的
							let point = this.btn_gift.localToGlobal(new Laya.Point(this.btn_gift.width / 2, 0))
							GlobalEventSystem.Fire(EventName.REWARD_FLY, moneys, point, undefined, undefined, 0, 0);
						}
					}
	
				}
				this.InitItem()
				this.CheckGiftRed()
			})
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetImageSpriteTrans(this, this.Image, GameResPath.GetIcon("destinyTurntable", "uikfhd_001"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.Image2, GameResPath.GetIcon("destinyTurntable", "uikfhd_006ab"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bar, GameResPath.GetIcon("destinyTurntable", "uikfhd_006ac"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_left, GameResPath.GetIcon("destinyTurntable", "uitmzp_021a"))
			//ResManager.GetInstance().SetOutsideImageSprite(this, this.img_right, GameResPath.GetIcon("destinyTurntable", "uitmzp_021a"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_title, GameResPath.GetIconOtherPath("destinyTurntable", "uitmzp_011"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.Image6, GameResPath.GetIcon("destinyTurntable", "uitmzp_014"))
			//lua_resM:SetOutsideImageSprite(this, this.Image3, GameResPath.GetIcon("destinyTurntable","uikfhd_006ac"))
			let data = {
				//load_call_back = (obj?) => {
				// let renders = obj.GetComponentsInChildren(typeof(UnityEngine.Renderer))
				// for (let i = 0; i < renders.Length; i++){
				// 	let mats = renders[i].materials
				// 	for (let j = 0; j < mats.Length; j++){
				// 		if (mats[j] ) {
				// 			mats[j].SetFloat("_Stencil", 1)
				// 			mats[j].renderQueue = 3000 //UI使用3000
				// 			mats[j].SetFloat("_StencilComp",4)
				// 			mats[j].SetFloat("_Stencil",1)
				// 			mats[j].SetFloat("_StencilOp",2)
				// 		}
				// 	}
				//}
				//}
			}
			//this.AddUIEffect("UI_2038_", this.layer_value, this.img_bar, {x = 0 , y = -126}, null, true, data)

			model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33238, this.base_type, this.sub_type)
			//this:InitItem()

			let actInfo = model.GetActInfo(this.base_type, this.sub_type)
			if (actInfo) {
				this.end_time = actInfo.etime
				timerid2 = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer()
				}, 1)
				this.onTimer()
			}
		}


		this.onTimer = () => {
			if (this.end_time >= TimeUtil.getServerTime()) {
				this.lb_time.text = TimeUtil.timeConvert(this.end_time - TimeUtil.getServerTime(), "hh-mm-ss")
			} else {
				this.lb_time.color = ColorUtil.TryParseHtmlString(Enum_ColorUtil_Dark.RED)
				this.lb_time.text = "已结束";
				this.RemoveTimer();
			}
		}

		this.RemoveTimer = () => {
			if (timerid2) {
				GlobalTimerQuest.CancelQuest(timerid2)
				timerid2 = null
			}
		}

		this.InitItem = () => {
			let actData = model.GetActData(this.base_type, this.sub_type)
			let reward_list = Util.DeepCopy(actData.reward_list)
            if (reward_list && Util.TableSize(reward_list) > 0) {
                for (let key in reward_list) {
                    let vo = reward_list[key]
                    let condition = ErlangParser.GetInstance().parse(vo.condition)
                    for (let k in condition) {
                        if (condition[k][0] == "is_free" && condition[k][1] == "true") {
                            this.gift_data = vo
                            table.remove(reward_list, Number(key))
                            break
                        }
                    }
                }
            }
			for (let i = 0; i < itemMax; i++) {
				let item: DestinyTurntableItem = item_list[i]
				let data = reward_list[i]
				if (!item) {
					item = new DestinyTurntableItem(this.gp_item)
					item.Load()
					let pos = pos_list[i]

					table.insert(item_list, item)
					if (i == 1) {
						item.SetSelect(true)
					}
					item.ExcuteCallback(() => {
						item.SetPos(pos.x, -pos.y)
					})
				}

				item.SetData(data)
			}

			this.CheckGiftRed()
		}

		this.SetDoublePoint = () => {
			let condition = model.GetActCondition(this.base_type, this.sub_type, "info")
			if (!condition) return
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if (condition.double_opday) {
				for (let key in condition.double_opday) {
					let min_day = condition.double_opday[key] && Number(condition.double_opday[key][0])
					let max_day = condition.double_opday[key] && Number(condition.double_opday[key][1])

					is_new_double_time = min_day && max_day && min_day <= open_day && max_day >= open_day
					if (is_new_double_time) {
						let time = TimeUtil.GetFutureZeroStamp(1)
						model.SetDesTinyEndTime(time)
						break
					}
				}

			}
			if (!is_new_double_time && condition.double_timestamp) {

				let now_time = TimeUtil.getServerTime()
				for (let key in condition.double_timestamp) {
					let min_time = condition.double_timestamp[key] && Number(condition.double_timestamp[key][0])
					let max_time = condition.double_timestamp[key] && Number(condition.double_timestamp[key][1])
					is_new_double_time = min_time && max_time && min_time <= now_time && max_time >= now_time
					if (is_new_double_time) {
						model.SetDesTinyEndTime(max_time)
						break
					}
				}

			}
			new_double_list = []
			this.xianshi.visible = this.xianshi1.visible = is_new_double_time
			if (is_new_double_time && condition.double_point2) {
				let point_list = condition.double_point2
				for (let key in point_list) {
					let value = point_list[key]
					if (value && value[2]) {
						let day_list = value[2]
						for (let key in day_list) {
							let v = day_list[key]
							let min = v && v[0] ? Number(v[0]) : 0
							let max = v && v[1] ? Number(v[1]) : 0
							if (min && max && min <= open_day && max >= open_day) {
								table.insert(new_double_list, { jump_id: Number(value[1]), isDouble: true })
								break
							}
						}
					}

				}
			}
			model.SetDesTinyDouble(new_double_list)
		}

		this.HaveSameAct = (jump_id, list) => {
			let bool = false
			if (list && Util.TableSize(list) > 0) {
				for (let key in list) {
					let vo = list[key]
					if (vo.jump_id == jump_id) {
						bool = true
						break
					}
				}
			}

			return bool
		}

		this.InitIcon = () => {

			let actData = model.GetActData(this.base_type, this.sub_type)
			let iconData = actData.double_point
			let iconList = []
			let double_list = []
			if (new_double_list && Util.TableSize(new_double_list) > 0) {
				iconList = Util.DeepCopy(new_double_list)
				double_list = Util.DeepCopy(new_double_list)
			}
			for (let i in actData.double_point) {
				var icon = actData.double_point[i]
				if (icon.is_buy <= 0 && iconList.length < 3 && !this.HaveSameAct(icon.jump_id, new_double_list)) {
					icon.isDouble = true
					table.insert(iconList, icon)
				}
				if (icon.is_buy <= 0 && !this.HaveSameAct(icon.jump_id, new_double_list)) {

					table.insert(double_list, icon)
				}
			}
			this.have_double = Util.TableSize(iconList) > 0
			if (this.CanShowArrow()) {
				if (Util.TableSize(iconList) > 0) {
					let need = actData.need_point - actData.point
					iconList = this.GetArrowTarget(iconList, need)
				}

				this.ShowArrow()

			}
			let list = this.SetLinkWay(double_list)
			model.SetDesTinyGetWay(list)

			let max = 3
			if (iconList.length < max) {
				let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientLinK", true)
				let cfg = cfg_[LinkViewType.DestinyTurntable]
				let LinkList = LinkTool.GetInstance().SortList(LinkViewType.DestinyTurntable, cfg.linkList)
				for (let i = 0; i < LinkList.length; i++) {
					let icon = LinkList[i]
					icon.link = true
					table.insert(iconList, icon)
					if (iconList.length >= max)
						break
				}
			}
			table.insert(iconList, { other: true, jump_id: otherJump })

			for (let i in iconList) {
				let data = iconList[i]
				let item = icon_list[i]
				if (!item) {
					item = new DestinyTurntableIcon(this.gp_icon)
					item.Load()
					table.insert(icon_list, item)
				}
				item.SetData(data)
			}


		}

		this.InitIntegral = () => {
			let actData = model.GetActData(this.base_type, this.sub_type)
			let isMax = actData.turn > actData.max_turn
			this.lb_pro.text = isMax && "0/0" || actData.point + "/" + actData.need_point
			let point = isMax && 0 || Math.min(actData.point / actData.need_point, 1)
			let turn_down = actData.turn > actData.max_turn
			this.img_bar.mask.graphics.clear()
			let mask_width = turn_down ? 0 : point * 550
			this.img_bar.mask.graphics.drawRect(0, 0, mask_width || 1, 200, "#ffffff");
			//this.img_bar.width = point * 636
			let rotation = 12 + (170 - 12) * point


			this.red.visible = (point >= 1 && !turn_down)
			//this.gp_bar_po.localRotation = Quaternion.Euler(0, 0, rotation)
			// if (point >= 1) {
			// 	this.AddUIEffect("UI_2009_b_zt", "UI", this.gp_effect, null, 1.5, true, {
			// 		load_call_back =() => {
			// 			this.CoverEffect(this.btn, "UI")
			// 		}
			// 	})
			// } else {
			// 	this.ClearUIEffect(this.gp_effect)
			// }
		}

		this.ShowAnimation = (index?) => {
			this.running = true
			this.target_index = index
			timerid = GlobalTimerQuest.AddPeriodQuest(() => {
				this.Animation()
			}, 0.07)
		}

		this.Animation = () => {
			if (lastItem) {
				lastItem.SetSelect(false)
			}
			let item = item_list[selectIndex]
			item.SetSelect(true)
			lastItem = item

			if (roundCount >= roundCountMax) {
				let speedIndex = this.target_index - speedCount //减速
				if (speedIndex <= 0) {
					speedIndex = itemMax - speedIndex
				}

				if (selectIndex >= speedIndex || selectIndex < this.target_index) {
					if (cacheSpeedIndex != selectIndex) {
						cacheSpeedIndex = selectIndex
						this._speedTime = speedTime
					}
					this._speedTime = this._speedTime - 1
					if (this._speedTime > 0) {
						return
					}
				}

				if (selectIndex >= this.target_index) { //结束
					this.running = false
					roundCount = 0
					selectIndex = 0
					cacheSpeedIndex = null
					//lastItem = null
					GlobalTimerQuest.CancelQuest(timerid)
					timerid = null
					this.InitItem()
					this.InitIntegral()
					this.ShowReward()
					return
				}
			}


			selectIndex = selectIndex + 1
			if (selectIndex >= itemMax) {
				selectIndex = 0
				roundCount = roundCount + 1
			}
		}

		this.ShowReward = () => {
			Util.ShowCongratulationView(this.reward_list)
		}

		this.DeleteMe = () => {
			for (let i in item_list) {
				var item = item_list[i]
				item.DeleteMe()
			}
			item_list = []

			for (let i in icon_list) {
				var icon = icon_list[i]
				icon.DeleteMe()
			}
			icon_list = []

			if (timerid) {
				GlobalTimerQuest.CancelQuest(timerid)
				timerid = null
			}

			this.RemoveTimer()
			this.ClearUIEffect(this.gp_effect)
			super.DeleteMe()
		}
	}

	public Close() {

		if (this.running) {
			Message.show("抽奖中~")
			return
		}
		//super.Close(this)
	}
	private SetListArrow(list) {

		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientDesTurnTablePoint", true)
		if (!cfg || Util.TableSize(list) <= 0) return
		let cfg1 = cfg.need_point

		let get_count_list = []

		for (let k in list) {
			let v = list[k]
			let l = []
			if (v.jump_id == 23) {
				l = this.GetVipList(cfg1)
				get_count_list = get_count_list.concat(l)
			}
			else if (v.jump_id == 191) {
				l = cfg1[191]
				get_count_list = get_count_list.concat(l)
			}
			else if (v.jump_id == 61) {
				l = cfg1[61]
				get_count_list = get_count_list.concat(l)
			}
		}
		return get_count_list
	}
	private GetVipList(cfg1) {
		let self_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
		let vip_list = []
		switch (self_vip) {
			case 0:
				vip_list = ((vip_list.concat(cfg1[23][0])).concat(cfg1[23][1])).concat(cfg1[23][2])
				break;
			case 1:
				vip_list = (vip_list.concat(cfg1[23][1])).concat(cfg1[23][2])
				break;
			case 2:
				vip_list = vip_list.concat(cfg1[23][2])
				break;
			case 4:
				vip_list = []
				break;
		}
		return vip_list
	}
	private GetArrowTarget(list, need) {
		let arrow_list = this.SetListArrow(list)
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientDesTurnTablePoint", true)
		if (!cfg) return
		let cfg2 = cfg.count_for_type
		let min_need = 0
		for (let k in arrow_list) {
			let v = arrow_list[k]
			if (v > need && (v < min_need || min_need == 0))
				min_need = v
		}
		if (min_need != 0) {
			let target = cfg2[min_need]
			this.target_jump_id = target
			let sort_fun = (t, l) => {
				let data
				for (let i = 0; i < l.length; i++) {
					let value = l[i]
					if (value.jump_id == t) {

						data = value
						l.splice(i, 1)
						break
					}
				}
				l.unshift(data)
				return l
			}
			list = sort_fun(target, list)
		}
		else
			this.once_can_do = false

		return list
	}
	private CanShowArrow() {
		let data = CustomActivityModel.GetInstance().GetActData(this.base_type, this.sub_type)
		let info = CustomActivityModel.GetInstance().GetDesTinyInfo()
		if (!info) return false
		let target = info.target
		return Number(data.need_point) > Number(data.point) && Number(target) >= Number(data.need_point - data.point)
	}

	public CheckGiftRed() {
        if (this.gift_data) {
            this.btn_gift.visible = this.gift_data.status == 1
        }
    }

	private ShowArrow() {
		let des
		this.arrow.x = 105
		let eff_scaleX = 0.5
		let eff_scaleY = 1
		if (this.have_double && this.once_can_do) {
			let name = this.target_jump_id ? this.jump_id_for_des[this.target_jump_id] : "本礼包"
			des = `点击图标前往购买${name}即可抽取天命豪礼`
		}
		if (this.have_double && !this.once_can_do)
			des = "双倍途径双倍提升，助你更快获取天命大奖"
		if (!this.have_double && this.once_can_do) {
			des = "通过以下途径可以快速提高天命值哦~"
			this.arrow.x = 315
			eff_scaleX = 2.6
		}
		let step_cfg = { direction: 2, text: des, "effect_scaleX": eff_scaleX, "effect_scaleY": eff_scaleY }
		GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.arrow, this.layer_value, null, null, false, false, step_cfg, true)
	}
	private SetLinkWay(list) {
		let l = []
		let index = 1
		for (let key in list) {
			let v = list[key]
			if (v.isDouble) {
				table.insert(l, { "jump_id": v.jump_id, "index": index })
				index++
			}

		}
		for (let key in list) {
			let v = list[key]
			if (!v.isDouble) {
				table.insert(l, { "jump_id": v.jump_id, "index": index })
				index++
			}

		}
		return l
	}

	public GetComponents() {
		[
			this.Image,
			this.gp_pro,
			this.Image2,
			this.gp_bar_po,
			this.img_bar_po,
			this.Image31,
			this.Image4,
			this.Image5,
			this.img_bar,
			this.Image3,
			this.lb_pro,
			this.btn,
			this.img_left,
			this.img_right,
			this.img_title,
			this.Image6,
			this.gp_icon,
			this.gp_item,
			this.red,
			this.Text1,
			this.lb_time,
			this.gp_effect,
			this.bar_effect,
			this.arrow,
			this.xianshi,
			this.xianshi1,
			this.btn_gift,
			this.gift_red
		]
			= this.GetChildrenByNames([

				"Image",
				"gp_pro",
				"Image2",
				"gp_bar_po",
				"img_bar_po",
				"Image31",
				"Image4",
				"Image5",
				"img_bar",
				"Image3",
				"lb_pro",
				"btn",
				"img_left",
				"img_right",
				"img_title",
				"Image6",
				"gp_icon",
				"gp_item",
				"red",
				"Text1",
				"lb_time",
				"gp_effect",
				"bar_effect",
				"arrow",
				"xianshi",
				"xianshi1",
				"btn_gift",
				"gift_red"
			])
	}
}
window["DestinyTurntableView"] = DestinyTurntableView