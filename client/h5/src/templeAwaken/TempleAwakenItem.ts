import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { StoryModel } from "../commonModel/StoryModel"
import { TempleAwakenModel, TempleAwakenEvent } from "../commonModel/TempleAwakenModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { EquipmentItem } from "../common/EquipmentItem"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { TaskModel } from "../commonModel/TaskModel"
import { Message } from "../sysInfo/SysInfoController"


export class TempleAwakenItem extends BaseItemRenderer {
	item_list
	model
	all_stage
	story_model
	ClickFunc
	task_info_data
	clickTime = 0
	public WIDTH = 698
	public HEIGT = 118
	public constructor(parent) {
		super()
		this.base_file = "templeAwaken"
		this.layout_file = "TempleAwakenItem"
		this.item_list = []
		this.model = TempleAwakenModel.GetInstance()
		this.story_model = StoryModel.GetInstance()
		this.load_callback = () => {
			this._scroller.hScrollBarSkin = ""
			SetHtmlStyle(this.task_detail, { f: 20, c: "#763320", ww: false, w: 500, st: 2, stc: "#dfd1cd" })
			this.LoadSuccess()
		}

		this.ClickFunc = () => {

			if(this.receive_img.visible)return//领取后不能再点击
			//点击延时
			let curTimeMs = new Date().getTime();
			if ((curTimeMs - this.clickTime) < 500) {
				return;
			}
			this.clickTime = curTimeMs


			if (this.reward_red.visible) {
				this.model.Fire(TempleAwakenEvent.REQUEST_PROTO, 42907, "hhh", this.data.chapter, this.data.sub_chapter, this.data.info.stage)
			} else {

				if (this.IsSpecialLevel()) {
					TaskModel.GetInstance().Fire(TaskModel.OPEN_UPALERT_VIEW)
					return
				}


				if (this.IsTempAwakeSkill()) {
					let heartBool = TaskModel.GetInstance().OpenHeartView(31002)
					if (!heartBool) {
						Message.show("任务不存在")
					}
					return
				}


				let open_id = this.data.info.jump_id
				if (open_id == 88 && ServerTimeModel.GetInstance().GetOpenServerDay() >= 6) {
					open_id = 99
				}
				if (!CommonManager.GetInstance().OpenFunCanJump(open_id, false)) {
					return
				}
				OpenFun.OpenFunHandler(open_id)
			}

		}

		this.Load()
	}


	/***等级任务 跳转 */
	public IsSpecialLevel() {
		if (this.data.info.jump_id == 0) {
			let info = this.data.info
			if ((info.chapter_id == 1001 && info.sub_chapter == 1 && info.stage == 1) ||
				info.chapter_id == 1001 && info.sub_chapter == 1 && info.stage == 3) {
				return true
			}
		}
		return false
	}


	/**技能觉醒任务跳转*/
	public IsTempAwakeSkill() {
		let info = this.data.info
		if (info.jump_id == 0) {
			if (info.chapter_id == 1001 && info.sub_chapter == 3 && info.stage == 5) {
				return true
			}
		}
		return false
	}

	public LoadSuccess() {

		//this.icon_click.visible = false 
		this.receive_img.visible = false
		this.InitEvent()
	}

	public InitEvent() {


		Util.AddClickEvent(this.getBtn, () => {
			if(!this.task_info_data){
				return
			}
			this.ClickFunc()
		}, this, true)

		Util.AddClickEvent(this._box_click_area, () => {
			if(!this.task_info_data){
				return
			}
			this.ClickFunc()
		}, this, true)

	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (!this.data) { return }
		this.all_stage = this.GetAllStage(this.data)
		this.task_detail.innerHTML = `${this.data.info.stage_name}&nbsp;(${HtmlColorTxt("0", Enum_ColorUtil_Dark.RED)}/${this.all_stage})`
		//this.progress.text = "(0/" + this.all_stage + ")"
		this.task.text = this.data.info.stage_desc
		this.reward_red.visible = false
		this.receive_img.visible = false

		let goods = ErlangParser.GetInstance().Parse(this.data.info.reward)
		if (goods) {
			for (let i = 0; i < goods.length; i++) {
				let info = goods[i]
				if (!info) {
					continue
				}
				let item = this.item_list[i]
				if (!item) {
					item = new EquipmentItem(this._content)
					item.SetItemSize(83, 83)
					item.Load()
					table.insert(this.item_list, item)
				}

				let [goods_id, lcok] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
				let goodsbasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
				item.SetData(goodsbasic.type_id, info[2])
				item.SetVisible(true)
			}

			for (let i = goods.length; i < this.item_list.length; i++) {
				if (this.item_list[i]) {
					let item = this.item_list[i]
					item.SetVisible(false)
				}
			}

		}

		this.UpdateItem()
	}

	public UpdateItem() {
		let task_info = this.model.GetSubChapterTaskInfo()
		if (task_info && Util.TableSize(task_info) > 0) {
			this.task_info_data = task_info[this.data.chapter] && task_info[this.data.chapter][this.data.sub_chapter]
				&& task_info[this.data.chapter][this.data.sub_chapter][this.data.info.stage]
			if (this.task_info_data ) {
				//已完成或正在进行中的任务
				let open_con = Number(ErlangParser.GetInstance().Parse(this.data.info.open_con)[0][1])
				let main_role_lv = RoleManager.GetInstance().GetMainRoleLevel()
				let process = this.GetProcess(this.data.info.client_process, this.task_info_data .process)
				let color = this.task_info_data .status >= 2 ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.RED
				this.task_detail.innerHTML = `${this.data.info.stage_name}&nbsp;(${HtmlColorTxt(process + "", color)}/${this.all_stage})`
				//this.progress.text = "(" + process + "/" + this.all_stage + ")"
				this.reward_red.visible = this.task_info_data .status == 2 && open_con <= main_role_lv
				this.getBtn.visible = false
				switch (this.task_info_data .status) {
					case 1://前往
						this.getBtn.visible = (this.data.info.jump_id != 0 || this.IsSpecialLevel() || this.IsTempAwakeSkill())
						ResManager.GetInstance().SetImageSprite(this, this._Image111, "common", "ui_button_rect14")
						this.labelDisplay1.strokeColor = "#3e9298"
						this.labelDisplay1.text = "前往"
						break;
					case 2://领取
						if (open_con <= main_role_lv) {
							this.getBtn.visible = true
							this.labelDisplay1.text = "领取"
							ResManager.GetInstance().SetImageSprite(this, this._Image111, "common", "ui_button_rect11")
							this.labelDisplay1.strokeColor = "#c95b37"
						}
						break;
					case 3://已领取
						this.receive_img.visible = true
						break;
				}


				if (this.reward_red.visible == true && this.data.chapter == 1001 && this.data.sub_chapter == 1 && this.data.info.stage == 1) {
					this.story_model.curr_view_story_step = 3
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.getBtn, "UI", 0, -10, null, null, null, true)
				} else {
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.getBtn)
				}
			}else{
				//还未开启的任务
				this.reward_red.visible =false
				this.getBtn.visible = false
				this.receive_img.visible =false
			}
		}


	}



	public GetAllStage(data?) {

		let cfg = ErlangParser.GetInstance().Parse(data.info.complete_con)
		let type = data.info.client_process
		if (type == 6) {
			return cfg[0][2] + "阶" + cfg[0][3] + "星"
		} else if (type == 2) {
			return cfg[0][1]
		} else if (type == 1) {
			return 1
		} else if (type == 5) {
			return cfg[0][4]
		} else if (type == 4) {
			return cfg[0][3]
		} else if (type == 3) {
			return cfg[0][2]
		}
	}
	public GetProcess(type?, process?) {

		if (type == 6) {
			let stage = Math.floor(process / 100)
			let star = process % 100
			return `${stage}阶${star}星`
		} else {
			return process
		}
	}
	public DeleteMe() {

		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
			}
			this.item_list = []
		}
		super.DeleteMe()
	}



	Image: Laya.Image
	Image1: Laya.Image
	Image2: Laya.Image
	Image3: Laya.Image
	task_detail: Laya.HTMLDivElement
	task: Laya.Label
	receive_img: Laya.Image
	getBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	reward_red: Laya.Image
	_box_click_area: Laya.Box
	_scroller: Laya.Panel
	_content: Laya.HBox
	public GetComponents() {
		[
			this.Image,
			this.Image1,
			this.Image2,
			this.Image3,
			this.task_detail,
			this.task,
			this.receive_img,
			this.getBtn,
			this._Image111,
			this.labelDisplay1,
			this.reward_red,
			this._box_click_area,
			this._scroller,
			this._content,
		]
			= this.GetChildrenByNames([

				"Image",
				"Image1",
				"Image2",
				"Image3",
				"task_detail",
				"task",
				"receive_img",
				"getBtn",
				"_Image111",
				"labelDisplay1",
				"reward_red",
				"_box_click_area",
				"_scroller",
				"_content",
			])
	}
}
window["TempleAwakenItem"] = TempleAwakenItem