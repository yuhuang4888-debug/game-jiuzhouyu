import { BaseItem1 } from "../common/BaseItem1"
import { Sprite } from "../scene/sceneobj/Sprite"
import { SkillManager } from "../skill/SkillManager"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

//圆形cd
export class CirCleCdView extends BaseItem1 {

	skill_mgr
	skill_id = null
	font_size = null
	callback = null
	all_time = 0
	last_time = 0
	curr_show_time = 0
	is_dead = false
	is_playing = false
	is_pause = false
	is_base_skill = false
	shape_mask: Laya.Sprite

	size = 0
	line_width

	need_refresh_data

	public constructor(parent) {
		super(parent)

		this.base_file = "uiComponent"
		this.layout_file = "CirCleCdView"
		this.is_load_res = false
		this.skill_mgr = SkillManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess = () => {

		this.display_obj.mouseEnabled = false
		
		this.shape_mask = new Laya.Sprite()
		this.shape_mask.alpha = 0.8
		this.display_obj.addChildAt(this.shape_mask, 1);
		
		this._img_mask.visible = false
		this.InitEvent()

		if(this.need_refresh_data){
			this.need_refresh_data = false
			this.UpdateItem()
		}
	}

	public InitEvent = () => {

		let onStartCdHandler = (skill_id, cdTime) => {
			if (this.skill_id == skill_id) {
				let skillVo = this.skill_mgr.getSkill(this.skill_id)
				if (skillVo && !skillVo.ignore_learn_level) {
					this.Show(cdTime, 0)
				}
			}
		}
		this.BindEvent(this.skill_mgr, SkillManager.START_SKILL_CD, onStartCdHandler)

		let onLockCDHandler = (lock) => {
			// if (this.skill_id != SkillManager.JUMP_SKILL_ID ) { //不能控制跳跃的cd状态
			if (lock) {
				this.PauseCD()
			} else {
				this.ContinueCD()
			}
			// }
		}
		this.BindEvent(this.skill_mgr, SkillManager.LOCK_CD, onLockCDHandler)

		let onRefreshCDHandler = (list) => {
			if (!this.IsPlaying()) {
				return
			}
			for (let index in list) {
				let vo = list[index]
				if (this.skill_id == vo.skill_id) {
					let left_cd_time = (vo.cd_time - TimeUtil.getServerTimeMs()) / 1000
					let skillVo = this.skill_mgr.getSkill(this.skill_id)
					if (skillVo != null) {
						let real_cd_time = skillVo.GetLeftCD()
						if (real_cd_time > left_cd_time) {
							let cd_time = skillVo.getCd() / 1000
							let last_time = cd_time - left_cd_time
							skillVo.refreshCD(real_cd_time - left_cd_time)
							this.Show(cd_time, last_time)
						}
					}
					break
				}
			}
		}
		this.BindEvent(this.skill_mgr, SkillManager.REFRESH_CD, onRefreshCDHandler)
	}


	public SetData = (callback?, is_base_skill?, skill_id?, size?, font_size?) => {
		this.callback = callback
		this.is_base_skill = is_base_skill
		this.skill_id = skill_id
		this.size = size || 86
		this.font_size = font_size

		if(this.is_loaded){
			this.UpdateItem()
		}
		else{
			this.need_refresh_data = true
		}
	}

	public UpdateItem(){

		this._lb_cd.fontSize = this.font_size
		this.display_obj.width = this.size
		this.display_obj.height = this.size
		this._img_mask.width = this.size
		this._img_mask.height = this.size
		this.line_width = this.size / 2 + 0.1
		this.shape_mask.x = this._img_mask.width / 2
		this.shape_mask.y = this._img_mask.height / 2
		this.SetSkillId(this.skill_id)
	}


	public IsPlaying = () => {
		return this.is_playing
	}

	public SetSkillId = (skill_id?) => {

		this.RemoveTimer()
		this._lb_cd.changeText("")
		this.DrawMaskCircle(0)
		this.skill_id = skill_id
		this.skill_mgr.AddCDItem(this.skill_id, this)
		let skillVo = this.skill_mgr.getSkill(this.skill_id)
		if (skillVo != null) {
			let cdTime = skillVo.GetLeftCD()
			if (cdTime > 0) {
				let cd = skillVo.getCd() / 1000
				this.Show(cd, cd - cdTime)
			}
		}
	}

	public Show = (all_time?, last_time?, skill_id?) => {

		this.RemoveTimer()
		this.all_time = all_time
		this.last_time = last_time || 0
		this.curr_show_time = 0

		if (this.all_time == 0 || this.last_time >= this.all_time) {
			this._lb_cd.changeText("")
			this.DrawMaskCircle(0)
			return
		}
		if (!this.is_base_skill) {
			let cur_percent = 1 - this.last_time / this.all_time
			this.DrawMaskCircle(cur_percent)
			let left_time = this.all_time - this.last_time - this.curr_show_time
			if (left_time > 1) {
				this._lb_cd.changeText(String(Math.ceil(left_time)))
			} else {
				this._lb_cd.changeText(left_time.toFixed(1))
			}
		}
		this.AddTimer()
	}


	public AddTimer = () => {
		Runner.GetInstance().AddRunObj(this, 3)
		this.is_playing = true
	}

	public RemoveTimer = () => {
		Runner.GetInstance().RemoveRunObj(this.hashCode)
		this.is_playing = false
	}

	//暂停cd
	public PauseCD = () => {
		this.is_pause = true
	}

	public ContinueCD = () => {
		this.is_pause = false
	}

	public Update = (now_time?, elapse_time?) => {

		if (this.is_pause) { return }
		this.curr_show_time = elapse_time + this.curr_show_time
		let cur_percent = 1 - (this.last_time + this.curr_show_time) / this.all_time
		if (cur_percent <= 0) {
			cur_percent = 0
			this.RemoveTimer()
			this._lb_cd.changeText("")
			this.DrawMaskCircle(0)

			if (this.callback) {
				this.callback()
			}
			return
		}

		if (!this.is_base_skill) {
			this.DrawMaskCircle(cur_percent)

			let left_time = this.all_time - this.last_time - this.curr_show_time
			if (left_time > 1) {
				this._lb_cd.changeText(String(Math.ceil(left_time)))
			} else {
				this._lb_cd.changeText(left_time.toFixed(1))
			}
		}
	}

	public DrawMaskCircle = (angle) => {
		angle = 1 - angle
		this.shape_mask.graphics.clear();
		this.shape_mask.graphics.drawPie(0, 0, this.line_width, angle * 360 - 90, 360 - 90, 0x000000)

	}

	public DeleteMe() {
		this.RemoveTimer()
		this.skill_mgr.RemoveCdItem(this.skill_id)
		super.DeleteMe()
	}

	_img_mask: Laya.Image
	_lb_cd: Laya.Label
	public GetComponents() {
		[
			this._img_mask,
			this._lb_cd,
		]
			= this.GetChildrenByNames([

				"_img_mask",
				"_lb_cd",
			])
	}
}
window["CirCleCdView"] = CirCleCdView