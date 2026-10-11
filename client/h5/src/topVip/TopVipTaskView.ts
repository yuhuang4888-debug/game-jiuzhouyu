import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { RuneSelectMatView } from "../composite/RuneSelectMatView"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Util } from "../util/Util"
import { TopVipTaskItem } from "./TopVipTaskItem"

export class TopVipTaskView extends BaseItem1 {
	_Group4: Laya.Box
	_img_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Group2: Laya.Box
	_Image2: Laya.Image
	_Label2: Laya.Label
	top_icon_img: Laya.Image
	_top_icon_lb: Laya.HTMLDivElement
	item_bg_img: Laya.Image
	_Scroller1: Laya.List
	img_top_bg:Laya.Image
	InitEvent
	LoadSuccess
	LocalDeleteMe
	Scr_Scroller1
	TaskSort
	UpdateView
	loop_mgr
	task_item_gp

	public constructor(parent?) {
		super(parent)


		let model = TopVipModel.GetInstance()

		let local_TopVipEvent = TopVipEvent
		let item_list_ = null
		this.base_file = "topVip"
		this.layout_file = "TopVipTaskView"
		this.preload_server_config={
			"config_supreme_vip_currency_task":false
		}
		this.load_callback = () => {

			// this.RegisterMask(this.task_item_gp)
			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._top_icon_lb.size  = 16
			// 	SetAnchoredPositionX(this._top_icon_lb,-4)
			// }
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this,this.img_top_bg,GameResPath.GetIcon("topVip","uihflc_001a"))
			ResManager.GetInstance().SetImageSprite(this,this._Image2,"topVip","uihflc_002a")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("topVip", "uizurw_001"), true)
			ResManager.GetInstance().SetImageSprite(this, this.top_icon_img, "topVip", "uizurw_003", true)
			this._top_icon_lb.innerHTML = Util.StrToHTML("每日<font color='#c6ff00'>0点</font>重置特权任务、至尊币和商店商品购买次数")
			this._top_icon_lb.x=243-this._top_icon_lb.contextWidth/2
			this._top_icon_lb.y=16-this._top_icon_lb.contextHeight/2
		}

		this.UpdateView = () => {
			if (this.use_delete_method) {
				return
			}
			if (!item_list_) {
				item_list_ = []
			}
			let task_list = this.TaskSort()
			if (task_list && Util.TableSize(task_list) > 0) {
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this._Scroller1, TopVipTaskItem, task_list, LoopScrCon.Vertical, 1)
				} else {
					this.loop_mgr.replaceAll(task_list)
				}
			}
		}

		this.InitEvent = () => {
			model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45104)
			this.BindEvent(model, local_TopVipEvent.UPDATE_TOP_VIP_TASK_VIEW, () => {
				if (this.use_delete_method) { return }
				this.UpdateView()
			}
			)
		}

		this.TaskSort = () => {
			let config_supreme_vip_currency_task = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_currency_task", false)
			let task_list = model.GetSupremeVipTaskVo().task_list
			let finish_list = []
			let un_finish_list = []
			let receive_list = []
			for (let key in config_supreme_vip_currency_task) {

				// [ts2lua]config_supreme_vip_currency_task下标访问可能不正确
				let cfg = config_supreme_vip_currency_task[key]
				for (let _tmpi in task_list) {
					var task = task_list[_tmpi]
					if (cfg.task_id == task.task_id) {
						if (task.is_finish == 1 && task.is_commit != 1) {
							table.insert(receive_list, cfg)
						} else if (task.is_commit == 1) {
							table.insert(finish_list, cfg)
						} else {
							table.insert(un_finish_list, cfg)
						}
					}
				}
			}
			let list = []
			// list = table.merge(receive_list, un_finish_list)
			list=list.concat(receive_list)
			list=list.concat(un_finish_list)
			// table.merge(list, finish_list)
			list =list.concat(finish_list)
			return list
		}

		this.LocalDeleteMe = () => {
			item_list_ = null
		}


	}




	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Group4,
			this._img_bg,
			this._Group1,
			this._Image1,
			this._Label1,
			this._Group2,
			this._Image2,
			this._Label2,
			this.top_icon_img,
			this._top_icon_lb,
			this.item_bg_img,
			this._Scroller1,
			this.img_top_bg
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_img_bg",
				"_Group1",
				"_Image1",
				"_Label1",
				"_Group2",
				"_Image2",
				"_Label2",
				"top_icon_img",
				"_top_icon_lb",
				"item_bg_img",
				"_Scroller1",
				"img_top_bg"
			])
		this._top_icon_lb.style.fontSize=18
		this._top_icon_lb.style.color="#ffffff"
		// this._top_icon_lb.style.stroke=2
		this._top_icon_lb.style.strokeColor="#985417"
		this._top_icon_lb.width=470
		this._Scroller1.scrollBar.visible=false
	}
}
window["TopVipTaskView"]=TopVipTaskView