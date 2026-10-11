
import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { ErlangParser } from "../util/ErlangParser"
import { Message } from "../sysInfo/SysInfoController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { GrowthForceEvent, GrowthForceModel, GrowthForceModelEvent } from "../commonModel/GrowthForceModel"
import "../growthForce/GrowthFightWelfareItem"
import { GrowthFightWelfareItem } from "../growthForce/GrowthFightWelfareItem"
import { Config } from "../common/Config"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { OpenFun } from "../common/OpenFun"
import { DailyModel } from "../commonModel/DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { GrowthForceView } from "./GrowthForceView"

export class GrowthFightWelfareView extends BaseItem1 {

	LayoutItems
	GetRewardData //奖池
	item_list
	InitEvent
	SetSelect
	GetItemPos
	PlayAnimation
	MoveIndex
	GetMoveNextIndex
	IsReceive
	reward_data
	UpdateList
	GetRandomIndex
	GetMaxIndex
	DoCongratulation
	_model
	UpdateRoundTxt
	UpdateFightInfo
	NewRound  //新的一轮初始化
	UpdateItemState
	RefreshBtnText
	SetCheck

	//更新状态
	cur_reward_index
	is_new_round
	wait_time_id

	//是否正在播放抽取动画
	is_playing


	public constructor(parent) {
		super(parent)


		this.base_file = "growthForce"
		this.layout_file = "GrowthFightWelfareView"
		this._model = GrowthForceModel.GetInstance()
		this.item_list = []

		this.cur_reward_index = 0
		this.is_new_round = false
		this.wait_time_id = null
		this.is_playing = false

		this.load_callback = () => {
			this._model.FightWelfareSend()//打开界面请求下数据
			this._model.fight_welfare_login_red = false
			this._image_sel.visible = false
			ResManager.GetInstance().LoadFont(this, "fight_welfare", this.timeLb3, 32, false, () => {
				this.UpdateRoundTxt()
			})
			this.InitEvent()
			this.NewRound()
			this.SetCheck()
			//console.warn(this._model.IsFightWelfareGotAll())
			this.RefreshBtnText()
		}


		this.UpdateRoundTxt = () => {
			this.timeLb3.text = this._model.fight_welfare_round
		}

		this.UpdateFightInfo = () => {
			SetHtmlStyle(this._html_desc, { c: "#663915", f: 22, lh: 28, w: 256 })
			let fighting = this._model.fight_welfare_combat
			let need_fight = this._model.fight_welfare_next_combat
			let color = fighting >= need_fight ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.RED
			this._html_desc.innerHTML = `最高战力：${HtmlColorTxt(fighting + "", color)}<br>需要战力：${need_fight}`
		}

		this.InitEvent = () => {

			Util.AddClickEvent(this._btn_agree, () => {

				if (this._model.IsFightWelfareGotAll()) {
					Message.show("奖池已被搬空~")
					return
				}

				//摇奖  有抽奖次数就行
				if (this._model.fight_welfare_time > 0) {
					if (!this.is_playing) {
						this.is_playing = true
						this._model.FightWelfareRoll()
					}
				} else {
					DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 5, 1)
					GrowthForceModel.GetInstance().Fire(GrowthForceModelEvent.CLOSE_VIEW, GrowthForceView._layout_file)
					//Message.show("战力不足")
				}
			}, null, true)

			Util.AddClickEvent(this._anime, () => {
				this._model.is_skip_animation = !this._model.is_skip_animation
				this.SetCheck()
			}, this, true)


			this.BindEvent(this._model, GrowthForceEvent.UPDATE_FIGHT_WELFARE, (is_new, reward_id) => {
				//is_new 是否是新的一轮  reward_id是数组下标
				this.is_new_round = is_new
				//播放抽奖动画
				if (reward_id > 0) {
					this.cur_reward_index = reward_id - 1
					this.PlayAnimation(this.cur_reward_index)
				}
				this.redImg.visible = this._model.fight_welfare_time > 0 && !this._model.IsFightWelfareGotAll()
			})
		}


		this.SetCheck = () => {
			let source = (this._model.is_skip_animation && this._model.is_skip_animation != 0) && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this._anime, "common", source)
		}


		//新的一轮开始，重新设置
		this.NewRound = () => {
			this.LayoutItems()
			this.UpdateList()//更新奖池抽取状态
			this.UpdateFightInfo()
			this.UpdateRoundTxt()
			this.is_playing = false
		}

		//更新物品状态
		this.UpdateItemState = () => {
			for (let i = 0; i < this.item_list.length; i++) {
				let item: GrowthFightWelfareItem = this.item_list[i]
				if (item) {
					item.SetReceive(this.IsReceive(i))
				}
			}
		}

		this.LayoutItems = () => {

			this.reward_data = this.GetRewardData()
			if (this.reward_data && this.reward_data.length > 0) {
				for (let i = 0; i < this.reward_data.length; i++) {
					var vo = this.reward_data[i]
					let item: GrowthFightWelfareItem = this.item_list[i]
					if (!item) {
						item = new GrowthFightWelfareItem(this._box_items)
						item.Load()
						item.SetVisible(true)
						table.insert(this.item_list, item)

						let arr_pos = this.GetItemPos(i)
						item.SetPosition(arr_pos[0], arr_pos[1])
					}
					item.SetData(vo)
					item.SetReceive(this.IsReceive(i))
				}
			}
		}

		this.GetItemPos = (i) => {
			let gap = 130 //间隔
			let top = 2   //上边距
			let left = 5	//左边距
			let index = i + 1
			let temp1 = index % 3
			temp1 = temp1 >= 1 ? 1 : 0
			let temp_index = Math.floor(index / 3) + temp1
			let x = 0, y = 0

			let temp2 = i % 3  //0 1 2
			switch (temp_index) {
				case 1:
					x = temp2 * gap
					y = 0
					break;
				case 2:
					x = 3 * gap
					y = temp2 * gap
					break;
				case 3:
					x = (3 - temp2) * gap
					y = 3 * gap
					break;
				case 4:
					x = 0
					y = (3 - temp2) * gap
					break;
			}
			return [x + left, y + top]
		}

		//i  0 - 11
		this.SetSelect = (i) => {
			let arr_pos = this.GetItemPos(i)
			this._image_sel.pos(arr_pos[0] + this._box_items.x - 11, arr_pos[1] + this._box_items.y - 11)

			let item = this.item_list[i]
			if (item) {
				item.PlayAnimation()
			}
		}


		//是否已经抽取到  0-11
		this.IsReceive = (index) => {
			if (this._model.fight_welfare_list[(index + 1)]) return true
			return false
		}

		this.GetRewardData = () => {
			let round = this._model.fight_welfare_round
			let list = []
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_combat_welfare_reward
			if (!cfg) return []
			for (let i = 1; i <= this._model.max_item_num; i++) {
				let key = `${round}@${i}`
				let data = ErlangParser.GetInstance().parse(cfg[key].reward)
				list.push([Number(data[0][0]), Number(data[0][1]), Number(data[0][2])])
			}
			return list;
		}


		let cur_item_list = []  //还没有领取的奖励列表
		let round = 2 //
		let max_num = 0
		let acce1_time = 0 //加速度
		let acce1_index = 0 //小于等于该index使用增速
		let acce1_x = 0.2 	//限速标志1 位于总程的百分比 数值越大，越急促
		let acce2_time = 0 //减速度
		let acce2_index = 0 //大于等于该index使用增速
		let acce2_x = 0.7 	//限速标志2 位于总程的百分比  数值越大，越急促
		let min_time = 20 //匀速(>acce1_index&&<acce2_index)
		let max_time = 250 //开始转动时间


		//*** 更新*/
		this.UpdateList = () => {
			cur_item_list = []
			for (let i = 0; i < this._model.max_item_num; i++) {
				if (!this.IsReceive(i)) {
					cur_item_list.push(i)
				}
			}
		}

		this.GetRandomIndex = () => {
			let r = Util.RandomRange(0, cur_item_list.length - 1)
			return r
		}



		this.PlayAnimation = (target_index) => {
			this._image_sel.visible = true
			Laya.timer.clear(this, this.MoveIndex)

			let target_real_index = cur_item_list.indexOf(target_index)
			if (target_real_index == -1) {
				console.warn("物品已经领取:" + target_index)
				return
			}

			//跳过动画
			if (this._model.is_skip_animation) {
				this.SetSelect(cur_item_list[target_real_index])
				this.DoCongratulation()
				return
			}

			let real_index = this.GetRandomIndex()
			max_num = this.GetMaxIndex(real_index, target_real_index)

			//奖池中只剩下一个奖励 就不用摇了
			if (max_num == (round + 2)) {
				this.SetSelect(cur_item_list[real_index])
				this.DoCongratulation()
				return
			}

			//获取限速标志点
			acce1_index = Math.floor(max_num * acce1_x)
			acce2_index = Math.floor(max_num * acce2_x)
			//计算各个加速度
			acce1_time = Math.ceil(max_time / acce1_index)
			acce2_time = Math.ceil(max_time / (max_num - acce2_index))

			Laya.timer.once(max_time, this, this.MoveIndex, [real_index, max_time, 1])
		}

		this.MoveIndex = (real_index, time, count) => {
			if (this.use_delete_method) return
			this.SetSelect(cur_item_list[real_index])
			if (count <= acce1_index) {
				time = time - acce1_time  //加速过程
			} else if (count > acce2_index) {
				time = time + acce2_time  //减速过程
			} else {
				time = min_time
			}
			count++
			if (count > max_num) {
				Laya.timer.clear(this, this.MoveIndex)
				this.DoCongratulation()
				return
			}
			real_index++
			if (real_index >= cur_item_list.length) real_index = 0

			Laya.timer.once(time, this, this.MoveIndex, [real_index, time, count])
		}

		this.GetMaxIndex = (randon_real_index, target_real_index) => {
			let num = (cur_item_list.length - randon_real_index) + round * cur_item_list.length + (target_real_index + 1)
			return num;
		}


		this.DoCongratulation = () => {
			if (this.wait_time_id) {
				clearTimeout(this.wait_time_id)
				this.wait_time_id = null
			}
			this.wait_time_id = setTimeout(() => {
				this.is_playing = false
				this.UpdateList()//更新奖池抽取状态
				this.UpdateItemState()
				this.UpdateFightInfo()

				if (this.reward_data && this.reward_data.length > 0) {
					let vo = this.reward_data[this.cur_reward_index]
					if (vo) {
						let list = []
						table.insert(list, { "0": vo[0], "1": vo[1], "2": vo[2] })
						let view = new CongratulationObtainView(list, 10)
						view.Open()
					}
				}


				if (this.is_new_round) {
					this.is_new_round = false
					this.NewRound()
				}

				this.RefreshBtnText()
				// if(this._model.IsFightWelfareGotAll()){
				// 	//this._model.Fire(GrowthForceEvent.CLOSE_FIGHT_WELFARE)
				// }
			}, 300);

		}


		this.RefreshBtnText = () => {
			let boo = this._model.IsFightWelfareGotAll()
			this._btn_agree.gray = boo
			if (boo) {
				this.labelDisplay111.text = "已结束"
			} else {
				if (this._model.fight_welfare_time > 0) {
					this.labelDisplay111.text = "开始抽奖"
				}
				else {
					this.labelDisplay111.text = "我要变强"
				}
			}

		}


	}


	public DeleteMe() {
		Laya.timer.clearAll(this)
		if (this.item_list && this.item_list.length > 0) {
			for (let i = 0; i < this.item_list.length; i++) {
				let item = this.item_list[i]
				item.DeleteMe()
				item = null
			}
			this.item_list.length = 0
		}

		if (this.wait_time_id) {
			clearTimeout(this.wait_time_id)
			this.wait_time_id = null
		}
		super.DeleteMe()
	}



	_box_items: Laya.Box
	_image_sel: Laya.Image
	_img_tip: Laya.Image
	_lb_desc: Laya.Label
	_box_round: Laya.Box
	_img_di: Laya.Image
	timeLb3: Laya.Label
	_img_lun: Laya.Image
	_anime: Laya.Image
	_html_desc: Laya.HTMLDivElement
	_Label2: Laya.Label
	_btn_agree: Laya.Box
	_Image111: Laya.Image
	labelDisplay111: Laya.Label
	redImg: Laya.Image
	public GetComponents() {
		[
			this._box_items,
			this._image_sel,
			this._img_tip,
			this._lb_desc,
			this._box_round,
			this._img_di,
			this.timeLb3,
			this._img_lun,
			this._anime,
			this._html_desc,
			this._Label2,
			this._btn_agree,
			this._Image111,
			this.labelDisplay111,
			this.redImg,
		]
			= this.GetChildrenByNames([

				"_box_items",
				"_image_sel",
				"_img_tip",
				"_lb_desc",
				"_box_round",
				"_img_di",
				"timeLb3",
				"_img_lun",
				"_anime",
				"_html_desc",
				"_Label2",
				"_btn_agree",
				"_Image111",
				"labelDisplay111",
				"redImg",
			])
	}
}
window["GrowthFightWelfareView"] = GrowthFightWelfareView