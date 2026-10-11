import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { Message } from "../sysInfo/SysInfoController"
import { OpenFun } from "../common/OpenFun"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class LuckyDuobaoItem extends BaseItem1 {
	base_type
	grade_data
	jump_id
	model

	rewardView
	reward_list
	sub_type

	public constructor(parent?) {
		super(parent)
		this.base_file = "luckyDuobao"
		this.layout_file = "LuckyDuobaoItem"

		this.model = CustomActivityModel.GetInstance()
		this.reward_list = []

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, "resource/game/luckyDuobao/other/ui_task_05.png")
		ResManager.GetInstance().SetOutsideImageSprite(this, this.desc_bg, "resource/game/luckyDuobao/other/uimrbj_001.png")
		this.rewardScroll.hScrollBarSkin =  ""
		this.desc.style.fontSize = 20
		this.desc.style.color = "#fff1b9"
		this.desc.style.wordWrap = false
		
		this.InitEvent()
	}

	public InitEvent() {
		this.BindEvent(this.model, CustomActivityDefine.EVENT.UP_GRADE, (base_type?, sub_type?, scmd?) => {
			if (this.use_delete_method) { return }
			if (this.base_type && this.sub_type && base_type == this.base_type && sub_type == this.sub_type && this.grade_data) {
				for (let k in scmd.reward_list) {
					let v = scmd.reward_list[k]
					if (v.grade == this.grade_data.grade) {
						this.RefView()
					}
				}
			}
		})

		this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
			if (this.use_delete_method) { return }
			if (this.base_type && this.sub_type && base_type == this.base_type && sub_type == this.sub_type
				&& this.grade_data && this.grade_data.grade == result_data.grade) {
				this.RefView()
				let reward = this.model.GetActReward(this.base_type, this.sub_type, reward_data.form_type, reward_data.reward)
				Util.ShowCongratulationView(reward, 10)
			}
		})

		Util.AddClickEvent(this.btn, () => {
			if (this.grade_data && this.grade_data.status == 1) {
				this.model.RequireGetAward(this.base_type, this.sub_type, this.grade_data.grade)
			} else if (this.grade_data && this.grade_data.status == 2) {
				Message.show("已领取该奖励")
			} else if (this.jump_id) {
				OpenFun.OpenFunHandler(this.jump_id)
			}
		}, this, true)
	}

	public InitView() {
		this.RefView()
		this.RefRewardItem()
	}

	public RefView() {
		if (!this.base_type || !this.sub_type || !this.grade_data) { return }
		let data = this.grade_data
		//描述
		let cond = this.model.GetActCondition(this.base_type, this.sub_type, "data", this.grade_data.grade)
		if (cond) {
			this.jump_id = cond.jump_id
			let _name = OpenFun.OpenName(cond.jump_id)
			if (cond.treasure_hunt && cond.treasure_hunt[2]) {
				let need_num = Number(cond.treasure_hunt[2])
				let color = data.process >= need_num && "#b3ff48" || "#ffef67"
				let desc = _name + "次数达到" + "<font color='" + color + "'>" + data.process + "/" + need_num + "</font>" + "次可领取"
				this.desc.innerHTML = desc
			}
		}
		//按键红点
		this.red.visible = data.status == 1
		//按键文字
		let btn_text = "领取"
		let show_btn = true
		let img = "com_rect_btn1"
		if (data.status == 0) {
			btn_text = "前往夺宝"
			img = "com_rect_btn2"
		} else if (data.status == 2) {
			show_btn = false
		}

		this.btn.visible = show_btn
		this.draw.visible = !show_btn
		if (show_btn) {
			this.btn_name.text = btn_text
			ResManager.GetInstance().SetImageSprite(this, this.btn, "common", img)
		}
	}

	//奖励显示
	public RefRewardItem() {
		if (!this.base_type || !this.sub_type || !this.grade_data) { return }
		let data = this.grade_data
		let reward = this.model.GetActReward(this.base_type, this.sub_type, data.form_type, data.reward)
		if (reward && !Util.IsTableEmpty(reward)) {
			for (let k in reward) {
				let v = reward[k]
				let item = this.reward_list[k]
				if (!item) {
					item = new BaseAwardItem(this.Content)
					item.SetItemSize(90, 90)
					item.Load()
					table.insert(this.reward_list, item)
				}
				item.ExcuteCallback(() => {
					let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
					item.SetData(type, v[2], lock)
					item.SetVisible(true)
				})
			}
		}
		if (reward && reward.length < this.reward_list.length) {
			for (let i = reward.length + 1; i <= this.reward_list.length; i += 1) {
				let item = this.reward_list[i]
				if (item && item.display_obj) {
					item.display_obj.visible = false
				}
			}
		}
	}

	public SetDate(base_type?, sub_type?, grade_data?) {
		this.base_type = base_type
		this.sub_type = sub_type
		this.grade_data = grade_data
		this.InitView()
	}

	public DeleteMe() {
		if (this.reward_list && (this.reward_list.length > 0)) {
			for (let k in this.reward_list) {
				let v = this.reward_list[k]
				v.DeleteMe()
			}
			this.reward_list = []
		}
		super.DeleteMe()
	}

	bg: Laya.Image
	desc_bg: Laya.Image
	desc: Laya.HTMLDivElement
	rewardScroll: Laya.Panel
	Content: Laya.HBox
	btn: Laya.Image
	btn_name: Laya.Label
	red: Laya.Image
	draw: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.desc_bg,
			this.desc,
			this.rewardScroll,
			this.Content,
			this.btn,
			this.btn_name,
			this.red,
			this.draw,
		]
			= this.GetChildrenByNames([
				"bg",
				"desc_bg",
				"desc",
				"rewardScroll",
				"Content",
				"btn",
				"btn_name",
				"red",
				"draw",
			])
	}
}
window["LuckyDuobaoItem"] = LuckyDuobaoItem