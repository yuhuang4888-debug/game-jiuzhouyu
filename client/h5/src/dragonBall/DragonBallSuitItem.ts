import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util, SetLocalScale } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class DragonBallSuitItem extends BaseItem1 {
	need_refresh

	info
	data
	index
	model: DragonBallModel
	res_mgr: ResManager
	public constructor(parent?) {
		super(parent)

		this.base_file = "dragonBall"
		this.layout_file = "DragonBallSuitItem"

		this.model = DragonBallModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			if (this.need_refresh) {
				this.UpdateItem()
				this.need_refresh = undefined
			}
		}
	}

	public UpdateLock() {
		let info = this.info
		let data = this.model.GetDrageonData(info.dragon_id)
		if (!data || data.dragon_lv == 0) {
			this._img_lock.visible = true
			this._img_bg.gray = this._img_ball.gray = true
		}
		else {
			this._img_lock.visible = false
			this._img_bg.gray = this._img_ball.gray = false
		}
	}

	public UpdateLv(){
		let info = this.info
		let data = this.model.GetDrageonData(info.dragon_id)
		if (!data || data.dragon_lv == 0) {
			this._lb_desc.text = `Lv0`
		}
		else {
			this._lb_desc.text = `Lv${data.dragon_lv}`
		}
	}

	public UpdateItem() {
		let info = this.info
		
		this.res_mgr.SetImageSprite(this, this._img_ball, "dragonBall", info.res, true)
		this.UpdateLock()
		this.UpdateLv()
	}

	public InitEvent() {
		this.BindEvent(this.model, DragonBallModel.RecvFmt14300, (dragon_id) => {
			if (this.model.GetStatueActiveState()) {
				this.UpdateLock()
				this.UpdateLv()
			}
		})


		this.BindEvent(this.model, DragonBallModel.REFRESH_SUIT_LEVEL_UP_RED, (type) => {
			if (this.model.GetStatueActiveState()) {
				this.UpdateLock()
				this.UpdateLv()
			}
		})

		Util.AddClickEvent(this._img_bg, ()=>{
			if(this.info){
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DragonBallTipsView", this.info.dragon_id)
			}
		}, this, false)
	}

	public SetInfo(info) {
		this.info = info
		if (this.is_loaded) {
			this.UpdateItem()
		}
		else {
			this.need_refresh = true
		}
	}


	_img_bg: Laya.Image
	_img_ball: Laya.Image
	_img_lock: Laya.Image
	_lb_desc: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_ball,
			this._img_lock,
			this._lb_desc,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_ball",
				"_img_lock",
				"_lb_desc",
			])
	}
}
window["DragonBallSuitItem"] = DragonBallSuitItem