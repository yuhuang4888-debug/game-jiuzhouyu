import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util, SetLocalScale } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { EffectResType } from "../scene/SceneConfig"

let local_Laya = Laya
export class DragonBallItem extends BaseItem1 {
	need_refresh
	cache_select
	need_refresh_zorder
	alpha_cache


	info
	data
	index
	model: DragonBallModel
	res_mgr: ResManager

	red_state
	config_ball_msg = Config.PRELOAD_CLIENT_CONFIG.ConfigDragonBallMsg
	move_stage
	has_set_effect
	public constructor(parent?) {
		super(parent)

		this.base_file = "dragonBall"
		this.layout_file = "DragonBallItem"

		this.model = DragonBallModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.red_state = false

		this.load_callback = () => {
			// this.display_obj.mouseThrough = true
			// this._img_icon.mouseThrough = true
			this.InitEvent()
			if (this.need_refresh) {
				this.UpdateItem()
				this.need_refresh = undefined
			}
			if (this.cache_select != null) {
				this.ShowSelect(this.cache_select)
				this.cache_select = undefined
			}
			if (this.need_refresh_zorder) {
				this.UpdateZOrder()
				this.UpdateRed()
				this.need_refresh_zorder = undefined
			}

			if (this.alpha_cache) {
				this.SetAlpha(this.alpha_cache);
				this.alpha_cache = undefined
			}
		}
	}

	public UpdateLock() {
		let info = this.info
		let data = this.model.GetDrageonData(info.dragon_id)
		if (!data || data.dragon_lv == 0) {
			this._img_lock.visible = true
			this._box_effect.visible = false
		}	
		else {
			this._img_lock.visible = false
			this._box_effect.visible = true
			if(!this.has_set_effect){
				this.has_set_effect = true
				this.AddUIEffect("ui_xinghe_1", this._box_effect, {x :0.3, y: -3.3}, 3.5, null, null, null, null, null, null, null, null, true, EffectResType.XingHe)
			}
		}
	}

	public UpdateItem() {
		let info = this.info
		this.res_mgr.SetImageSprite(this, this._img_icon, "dragonBall", info.res, true)
		this.UpdateLock()
		this.UpdateRed()
	}

	public InitEvent() {
		// Util.AddClickEvent(this._img_icon, (e: Laya.Event) => {
		// 	let info = this.info
		// 	if (info) {
		// 		this.model.Fire(DragonBallModel.SELECT_ITEM, this.index)
		// 	}
		// 	// e.stopPropagation()
		// }, this)


		// this.BindEvent(this.model, DragonBallModel.RecvFmt14301, (dragon_id) => {
		// 	if (this.model.GetStatueActiveState() && dragon_id == this.info.dragon_id) {
		// 		this.UpdateLock()
		// 	}
		// })

		this.BindEvent(this.model, DragonBallModel.RecvFmt14300, (dragon_id) => {
			if (this.model.GetStatueActiveState()) {
				this.UpdateLock()
			}
		})

		this.BindEvent(this.model, DragonBallModel.REFRESH_BALL_LEVEL_UP_RED, (dragon_id) => {
			if (this.model.GetStatueActiveState() && dragon_id == this.info.dragon_id) {
				this.UpdateRed()
			}
		})


		this._img_icon.on(Laya.Event.MOUSE_DOWN, this, this.TouchBegin)
	}

	pos_x
    is_drag_state
    public TouchBegin(e: Laya.Event) {
        this.is_drag_state = false
        this.pos_x = e.stageX
        local_Laya.stage.on(local_Laya.Event.MOUSE_MOVE, this, this.OnDraging)
        local_Laya.stage.on(local_Laya.Event.MOUSE_UP, this, this.TouchEnd)
        local_Laya.stage.on(local_Laya.Event.MOUSE_OUT, this, this.TouchEnd)
    }

    public OnDraging(e: Laya.Event) {
        if (e.stageX != this.pos_x) {
            this.is_drag_state = true
			let delta_x = e.stageX - this.pos_x
			if (delta_x > 0) {
				this.model.Fire(DragonBallModel.ROTATE_BY_ITEM, 7)
			} else {
				this.model.Fire(DragonBallModel.ROTATE_BY_ITEM, -7)
			}
			this.pos_x = e.stageX
        }
    }

    public TouchEnd(e: Laya.Event) {
        local_Laya.stage.off(local_Laya.Event.MOUSE_MOVE, this, this.OnDraging)
        local_Laya.stage.off(local_Laya.Event.MOUSE_UP, this, this.TouchEnd)
        local_Laya.stage.off(local_Laya.Event.MOUSE_OUT, this, this.TouchEnd)
		
        if (!this.is_drag_state) {
			let info = this.info
			if (info) {
				this.model.Fire(DragonBallModel.SELECT_ITEM, this.index)
			}
        }
		else{
			this.model.Fire(DragonBallModel.ROTATE_BY_ITEM_FINSIH)
		}
    }

	public SetInfo(info, index) {
		this.info = info
		this.index = index
		if (this.is_loaded) {
			this.UpdateItem()
		}
		else {
			this.need_refresh = true
		}
	}

	public ShowSelect(value?) {
		if (this.is_loaded) {
			this._img_select.visible = value
		} else {
			this.cache_select = value
		}
	}

	SetAlpha(alpha?) {
		if (this.is_loaded) {
			this.display_obj.alpha = alpha;
		} else {
			this.alpha_cache = alpha;
		}
	}

	public SetMoveStage(stage) {
		this.move_stage = stage
		if (this.is_loaded) {
			this.UpdateZOrder()
			this.UpdateRed()
		} else {
			this.need_refresh_zorder = true
		}
	}

	public UpdateZOrder() {
		let move_state = this.GetMoveStage()
		if (move_state >= 2 && move_state <= 4) {
			this.display_obj.zOrder = 0
		}
		else {
			this.display_obj.zOrder = 2
		}
	}

	public SetPosition(x: any, y: any): void {
		super.SetPosition(x, y)
		if(this.is_loaded){
			this.UpdateMouseEnabled()
		}
	}

	public UpdateMouseEnabled(){
		let y = this.display_obj.y
		if (y < 445) {
			this.display_obj.mouseEnabled = false
		}
		else {
			this.display_obj.mouseEnabled = true
		}
	}

	public GetMoveStage() {
		return this.move_stage
	}

	public UpdateRed() {
		// let move_state = this.GetMoveStage()
		// if (move_state >= 2 && move_state <= 4) {
		// 	this._img_red.visible = false
		// }
		// else {
		// 	if(this.info){
		// 		if (this.model.ball_level_up_red_dic[this.info.dragon_id]) {
		// 			this._img_red.visible = true
		// 		}
		// 		else {
		// 			this._img_red.visible = false
		// 		}
		// 	}
		// }
		if(this.info){
			if (this.model.ball_level_up_red_dic[this.info.dragon_id]) {
				this._img_red.visible = true
			}
			else {
				this._img_red.visible = false
			}
		}
	}

	public DeleteMe(){
		this.has_set_effect = undefined
		super.DeleteMe()
	}

	_img_icon: Laya.Image
	_img_select: Laya.Image
	_img_red: Laya.Image
	_img_lock: Laya.Image
	_box_effect: Laya.Box
	public GetComponents() {
		[
			this._img_icon,
			this._img_select,
			this._img_red,
			this._img_lock,
			this._box_effect,
		]
			= this.GetChildrenByNames([
				"_img_icon",
				"_img_select",
				"_img_red",
				"_img_lock",
				"_box_effect",
			])
	}
}
window["DragonBallItem"] = DragonBallItem