import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { RecelationActivateItem } from "./RecelationActivateItem"

export class RevelationActiveView extends BaseView1 {
	res_mgr
	model

	data
	item_list
	timer_id
	tween_id

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationActiveView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.use_background = true
		this.is_center = true

		this.model = RevelationModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.data = null
		this.item_list = []

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			/*
			SetLocalScale(this.form, 0.9, 0.9, 0.9)
			this.tween_id = SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.SCALE, new Vector3(1.1, 1.1, 1.1), 0.03, () => {
				this.timer_id = setTimeout(() => {
					if (!this.use_delete_method) {
						this.tween_id = SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.SCALE, new Vector3(1, 1, 1), 0.05)
					}
				}, 0.03)
			})
			*/
		}

		this.close_callback = () => {
			for (let key in this.item_list) {
				let item = this.item_list[key]
				item.DeleteMe()
			}
			this.item_list = []
		}
	}

	public Close() {
		if (this.timer_id) {
			clearTimeout(this.timer_id)
			this.timer_id = null
		}

		/*
		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
		
		this.tween_id = SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.SCALE, new Vector3(1.02, 1.02, 1.02), 0.09, () => {
			this.timer_id = setTimeout(() => {
				if (!this.use_delete_method) {
					this.tween_id = SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.SCALE, new Vector3(0.8, 0.8, 0.8), 0.1, () => {
						super.Close(this)
					})
				}
			}, 0.09)
		})
		*/
		super.Close()
	}

	public Open(...new_args) {
		if (new_args) {
			this.data = new_args[0]
		}
		super.Open()
	}

	private InitEvent() {
		Util.AddClickEvent(this.btn_go, () => {
			//OpenFun.OpenFunHandler(137)
			this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationSuitView")
			this.Close()
		}, this, true)
	}

	private LoadSuccess() {
		this.res_mgr.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("revelation", "ui_shape_05"))
		this.res_mgr.SetOutsideImageSprite(this, this.img_title, "resource/game/revelation/other/ui_Apocalypse_04.png")

		let cfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_suit", false)
		if (cfg) {
			let curCfg = cfg[this.data.star + "@" + this.data.num]
			if (curCfg) {
				let list = JSON.parse(curCfg.attr)
				let index = 0
				let info = null
				let item = null
				for (let key in list) {
					info = list[key]
					item = this.item_list[index]
					if (!item) {
						item = new RecelationActivateItem(this.gp_attrCon)
						item.Load()
						table.insert(this.item_list, item)
					}
					item.SetData(info)
					index = index + 1
				}
				this.lb_title.text = curCfg.name + this.data.num + "件套"
			}
		}
	}

	_Group1: Laya.Box
	img_bg: Laya.Image
	img_title: Laya.Image
	img_title2: Laya.Image
	gp_attrCon: Laya.VBox
	lb_title: Laya.Label
	lb_tips: Laya.Label
	btn_go: Laya.Image
	lb_go: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this.img_bg,
			this.img_title,
			this.img_title2,
			this.gp_attrCon,
			this.lb_title,
			this.lb_tips,
			this.btn_go,
			this.lb_go,
		]
			= this.GetChildrenByNames([
				"_Group1",
				"img_bg",
				"img_title",
				"img_title2",
				"gp_attrCon",
				"lb_title",
				"lb_tips",
				"btn_go",
				"lb_go",
			])
	}
}
window["RevelationActiveView"] = RevelationActiveView