import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TransformCurrency, Util } from "../util/Util"

export class TopVipTaskItem extends BaseItemRenderer {

	bg_img: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	task_name_lb: Laya.HTMLDivElement
	_Scroller1: Laya.Box
	item_gp: Laya.Image
	Content: Laya.HBox
	btn_gp: Laya.Box
	receive_gp: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	go_gp: Laya.Box
	_Image4: Laya.Image
	_Label2: Laya.Label
	complete_img: Laya.Image
	Scr_Scroller1
	item_list
	jump_id
	model
	now_stage
	task_id
	public static width = 698
	public static height = 157
	public constructor(parent) {
		super()

		this.WIDTH = 690
		this.HEIGT = 162
		this.model = TopVipModel.GetInstance();
		this.base_file = "topVip"
		this.layout_file = "TopVipTaskItem"
		// this.load_callback = () => {

			// this.LoadSuccess()
		// }
		this.Load()
	}

	public load_callback() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("topVip", "ui_task_05"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("topVip", "uimrbj_001"))
		this.InitEvent()
	}

	public InitEvent() {

		Util.AddClickEvent(this.go_gp, () => {
			OpenFun.OpenFunHandler(this.jump_id)
		}
			, this, true)
		Util.AddClickEvent(this.receive_gp, () => {
			this.model.Fire(TopVipEvent.TOP_VIP_REQUEST_PROTO, 45105, "h", this.task_id)
		}
			, this, true)
		this.BindEvent(this.model, TopVipEvent.CHANGE_TOP_VIP_Task_RECEIVE_STAGE, (task_id?) => {
			if (task_id == this.task_id) {
				this.go_gp.visible = false
				this.receive_gp.visible = false
				this.complete_img.visible = true
			}
		}
		)
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		let data = this.data
		this.jump_id = data.jump_id
		this.task_id = data.task_id
		this.ChangeBottonAndTaskStage()
		let content = JSON.parse(data.content)
		let target = null
		for (let _tmpi in content) {
			var N = content[_tmpi]
			target = N[1]
		}
		let task_name_text
		if(data.task_id == 102){
			task_name_text = data.name + "(" + "<font color='#ffffff'>" + TransformCurrency(this.now_stage)+ "/" + TransformCurrency(target) + ")"+ "</font>" 
		}else{
			task_name_text = data.name + "(" + "<font color='#ffffff'>" + this.now_stage + "/" + target + ")"+ "</font>" 
		}
		this.task_name_lb.innerHTML = Util.StrToHTML(task_name_text)
		let list = JSON.parse(data.reward)
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
		let index = 0
		// if (list.length < this.item_list.length) {
		// 	let i = list.length-1
		// 	do {
		// 		this.item_list[i].SetVisible(false)
		// 		i = i + 1
		// 	} while ((i < this.item_list.length-1))
		// }

		for (let _tmpi in list) {
			var vo = list[_tmpi]
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
			item.SetVisible(true)
		}
	}

	public ChangeReceiveStage(complete?, receive?) {

		if (!RoleManager.GetInstance().GetMainRoleVo().supreme_vip) {
			this.btn_gp.visible = false
		} else {
			this.btn_gp.visible = true
		}
		if (complete != 1) {
			this.go_gp.visible = true
			this.receive_gp.visible = false
			this.complete_img.visible = false
		} else if (complete == 1 && receive != 1) {
			this.go_gp.visible = false
			this.receive_gp.visible = true
			this.complete_img.visible = false
		} else {
			this.go_gp.visible = false
			this.receive_gp.visible = false
			this.complete_img.visible = true
		}
	}

	public ChangeBottonAndTaskStage() {

		let task_list = this.model.GetSupremeVipTaskVo().task_list
		let receive = null
		let complete = null
		let content = null
		for (let _tmpi in task_list) {
			var task = task_list[_tmpi]
			if (task.task_id == this.task_id) {
				receive = task.is_commit
				complete = task.is_finish
				content = task.content
				this.ChangeReceiveStage(complete, receive)
				this.ChangeTaskN(content)
			}
		}
	}

	public ChangeTaskN(content?) {

		this.now_stage = ErlangParser.GetInstance().Parse(content)[0][1]
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
			this.bg_img,
			this._Group1,
			this._Image1,
			this.task_name_lb,
			this._Scroller1,
			this.item_gp,
			this.Content,
			this.btn_gp,
			this.receive_gp,
			this._Image2,
			this._Label1,
			this._Image3,
			this.go_gp,
			this._Image4,
			this._Label2,
			this.complete_img,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"_Group1",
				"_Image1",
				"task_name_lb",
				"_Scroller1",
				"item_gp",
				"Content",
				"btn_gp",
				"receive_gp",
				"_Image2",
				"_Label1",
				"_Image3",
				"go_gp",
				"_Image4",
				"_Label2",
				"complete_img",
			])
		this.task_name_lb.style.fontSize=20
		this.task_name_lb.style.color="#ffffff"
		this.task_name_lb.style.wordWrap=false
	}
}
window["TopVipTaskItem"]=TopVipTaskItem