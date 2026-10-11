import { BaseItem1 } from "../common/BaseItem1"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { AtlasUrl, Util } from "../util/Util"

export class ReincarnationFourItem extends BaseItem1 {
	id
	model
	need_refresh
	need_setRed
	select_cache
	vo
	state
	select_state
	is_red
	public constructor(parent?) {
		super(parent)
		this.id = 0;
		this.need_refresh = false;
		this.need_setRed = false;
		this.model = ReincarnationModel.GetInstance();
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationFourItem"
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {


		if (this.need_refresh) {
			this.SetState(this.state)
		}
		if (this.select_cache) {
			this.SetSelect(this.select_state)
			this.select_cache = false
		}
		if (this.need_setRed) {
			this.SetRedDot(this.is_red)
		}
	}

	public InitEvent() {


		Util.AddClickEvent(this.con, () => {
			if (this.id) {
				this.vo.state = this.state
				this.model.Fire(ReincarnationModel.OPEN_TIPS_VIEW, this.vo)
			}
		}
			, this, true)
	}

	public SetData(vo?, turn?) {

		this.vo = vo
		this.vo.turn = turn
		this.id = vo.task_id
	}

	public SetState(state?) {


		this.state = state
		if (this.is_loaded) {
			this.ClearUIEffect(this.effectGp)
			this.red_dot.visible = false
			if (this.state == 0) {

			} else if (this.state == 1) {
				let can_awaken = this.model.CellCanAwake(this.vo.id)
				if (can_awaken) {
					this.red_dot.visible = true
					this.AddUIEffect("UI_1127_04", this.effectGp, null, null, true)
				}
			} else if (this.state == 2) {
				//this:ClearUIEffect(this.effectGp)
			}
			Util.SetImageGray(this.gray_bg, this.state != 2)
			this.fire.skin = AtlasUrl("reincarnation", this.state != 2 ? "ui_task_14" : "ui_task_15")
			Util.SetImageGray(this.gray_bg, this.state != 2)

			this.select_img.visible = this.state == 1
		} else {
			this.need_refresh = true
		}
	}

	public SetSelect(bool?) {


		this.select_state = bool
		if (this.is_loaded) {
			if (bool) {
				this.select_img.visible = true
			} else {
				this.ClearUIEffect(this.effectGp)
				this.select_img.visible = false
			}
		} else {
			this.select_cache = true
		}
	}

	public SetRedDot(bool?) {


		this.is_red = bool
		if (this.is_loaded) {
			this.ClearUIEffect(this.effectGp)
			if (bool) {
				this.red_dot.visible = true
				this.AddUIEffect("UI_1127_04", this.effectGp, null, null, true)
			} else {
				this.red_dot.visible = false
				this.ClearUIEffect(this.effectGp)
			}
		} else {
			this.need_setRed = true
		}
	}

	public DeleteMe() {

		this.ClearUIEffect(this.effectGp)
		super.DeleteMe()
	}


	public ReOpen_callback() {
		if (this.state == 1) {
			this.AddUIEffect("UI_1127_04", this.effectGp, null, null, true)
		}
	}

	con: Laya.Box
	gray_bg: Laya.Image
	select_img: Laya.Image
	fire: Laya.Image
	effectGp: Laya.Box
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.con,
			this.gray_bg,
			this.select_img,
			this.fire,
			this.effectGp,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"con",
				"gray_bg",
				"select_img",
				"fire",
				"effectGp",
				"red_dot",
			])
	}
}
window["ReincarnationFourItem"] = ReincarnationFourItem