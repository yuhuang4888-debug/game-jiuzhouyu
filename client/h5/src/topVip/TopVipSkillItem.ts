import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

export class TopVipSkillItem extends BaseItem1 {
	_img_bg: Laya.Image
	_Scroller1: Laya.Box
	item_gp: Laya.Image
	Content: Laya.HBox
	_Group1: Laya.Box
	_Image1: Laya.Image
	task_detail_lb: Laya.HTMLDivElement
	_Group2: Laya.Box
	go_gp: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	receive_gp: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	_Image4: Laya.Image
	complete_img: Laya.Image
	Scr_Scroller1
	click_time
	index
	is_receive
	item_list
	jump_id
	model
	need_refresh_data
	now_stage
	reward
	target
	task_id
	task_str
	task_type

	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false;
		this.click_time = 0;
		this.model = TopVipModel.GetInstance();
		this.base_file = "topVip"
		this.layout_file = "TopVipSkillItem"
		this.is_receive = false
		this.load_callback = () => {

			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this.task_detail_lb.size  = 18
			// }
		}


	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("topVip", "ui_task_05"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("common2", "uity_016j"))
		this.InitEvent()
		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public Setdata(task_str?, task_id?, target?, jump_id?, index?, reward?) {

		this.task_str = task_str
		this.task_id = task_id
		this.target = target
		this.jump_id = jump_id
		this.index = index
		this.reward = reward
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {

		this.ChangeBottonAndTaskStage()
		this.CreateTaskReward()
		let str = this.task_str + "(" + "<font color='#ffffff'>" + this.now_stage + "</font>" + "/" + this.target + ")"
		this.task_detail_lb.innerHTML = Util.StrToHTML(str)
	}

	public InitEvent() {

		Util.AddClickEvent(this.go_gp, () => {
			if (this.task_type == 25) {
				Message.show("登陆天数不足")
			} else {
				OpenFun.OpenFunHandler(this.jump_id)
			}
		}
			, this, true)
		Util.AddClickEvent(this.receive_gp, () => {
			let is_receive = this.model.GetReceiveTask(this.task_id)
			if ((this.click_time && this.click_time != 0 && TimeUtil.getServerTime() - this.click_time < 2) || is_receive) {
				return
			}
			this.click_time = TimeUtil.getServerTime()
			this.model.Fire(TopVipEvent.TOP_VIP_REQUEST_PROTO, 45103, "h", this.task_id)
		}
			, this, true)
		this.BindEvent(this.model, TopVipEvent.CHANGE_TOP_VIP_SKILL_RECEIVE_STAGE, (task_id?) => {
			if (task_id == this.task_id) {
				this.go_gp.visible = false
				this.receive_gp.visible = false
				this.complete_img.visible = true
			}
		}
		)

	}

	public ChangeBottonAndTaskStage() {

		let task_list = this.model.GetSkillTaskList()
		let receive = null
		let complete = null
		let content = null
		for (let _tmpi in task_list) {
			var task = task_list[_tmpi]
			if (task.task_id == this.task_id) {
				receive = task.is_commit
				complete = task.is_finish
				content = task.content
				this.ChangeTaskN(content, complete)
				this.ChangeButton(receive, complete)
			}
		}
	}

	public ChangeButton(receive?, complete?) {

		if (complete != 1) {
			this.go_gp.visible = true
			this.receive_gp.visible = false
			this.complete_img.visible = false
		} else if (complete == 1 && receive != 1) {
			this.go_gp.visible = false
			this.receive_gp.visible = true
			this.complete_img.visible = false
			this.now_stage = this.target
		} else {
			this.go_gp.visible = false
			this.receive_gp.visible = false
			this.complete_img.visible = true
		}
	}

	public ChangeTaskN(content?, complete?) {

		let task_type = ErlangParser.GetInstance().Parse(content)[0][0]
		this.task_type = Number(task_type)
		if (Number(task_type) == 18) {
			if (complete && complete != 0) {
				this.now_stage = 1
			} else {
				this.now_stage = 0
			}
			this.target = 1
		} else {
			this.now_stage = ErlangParser.GetInstance().Parse(content)[0][1]
		}
	}

	public CreateTaskReward() {

		let index = 0
		if (this.item_list) {
			if (this.item_list && this.item_list.length > 0) {
				for (let _tmpi in this.item_list) {
					var obj = this.item_list[_tmpi]
					obj.DeleteMe()
				}
				this.item_list = null
			}
		}
		this.item_list = []
		for (let _tmpi in this.reward) {
			var vo = this.reward[_tmpi]
			// [ts2lua]this.item_list下标访问可能不正确
			let item = this.item_list[index]
			if (!item) {
				item = new BaseAwardItem(this.Content)
				// item.SetMaskId(1)
				item.Load()
				table.insert(this.item_list, item)
				item.SetItemSize(87,87)
			}
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				item.SetData(goods_vo.type_id, vo[2], lock)
			}
			index = index + 1
		}
	}

	public DeleteMe() {
		if (this.item_list && this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this.item_gp,
			this.Content,
			this._Group1,
			this._Image1,
			this.task_detail_lb,
			this._Group2,
			this.go_gp,
			this._Image2,
			this._Label1,
			this.receive_gp,
			this._Image3,
			this._Label2,
			this._Image4,
			this.complete_img,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Scroller1",
				"item_gp",
				"Content",
				"_Group1",
				"_Image1",
				"task_detail_lb",
				"_Group2",
				"go_gp",
				"_Image2",
				"_Label1",
				"receive_gp",
				"_Image3",
				"_Label2",
				"_Image4",
				"complete_img",
			])
		this.task_detail_lb.style.fontSize=22
		this.task_detail_lb.style.color="#ffffff"
		this.task_detail_lb.style.width=486
	}
}
window["TopVipSkillItem"]=TopVipSkillItem