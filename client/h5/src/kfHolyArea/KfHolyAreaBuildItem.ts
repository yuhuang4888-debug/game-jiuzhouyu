import { BaseItem1 } from "../common/BaseItem1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Util, SetSizeDelta, HtmlColorTxt, SetLocalPositionY, SetLocalPosition, SetSizeDeltaX } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { KfHolyAreaDefine } from "./KfHolyAreaDefine"
import { ColorUtil } from "../util/ColorUtil"
import { SceneManager } from "../scene/SceneManager"
import { TimeUtil } from "../util/TimeUtil"
import { ColorType } from "../util/ColorUtil"
import { table } from "../common/table"
import { SYTweenLite } from "../util/SYTweenLite"
import { RoleManager } from "../commonModel/RoleManager"
import { KfHolyAreaBuildMsgScoreItem } from "./KfHolyAreaBuildMsgScoreItem"
export class KfHolyAreaBuildItem extends BaseItem1 {
	_img_scene: Laya.Image
	_lb_server: Laya.Label
	_lb_desc: Laya.HTMLDivElement
	_gp_effect: Laya.Box
	_gp_box: Laya.Box
	_gp_behind: Laya.Box
	_img_box: Laya.Image
	_gp_front: Laya.Box
	desc_gp: Laya.Box
	_lb_desc1: Laya.HTMLDivElement
	_img_progress: Laya.Image
	_lb_score: Laya.Label
	_server_bg: Laya.Image

	model
	need_refresh_data
	scene_id
	tween_list
	type
	vo
	wait_time_id
	posx
	posy
	ProgressWidth = 116

	public constructor(parent) {
		super(parent)


		this.base_file = "kfHolyArea"

		this.layout_file = "KfHolyAreaBuildItem"

		this.model = KfHolyAreaModel.GetInstance()

		this.load_callback = () => {

			this.LoadSuccess()

		}

	}



	public LoadSuccess() {




		this.InitEvent()

	}



	public InitEvent() {


		Util.AddClickEvent(this._gp_box, () => {
			this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28408, this.scene_id)
			this._gp_box.visible = false
		}, this, true)

		Util.AddClickEvent(this._img_scene, () => {
			if (this.vo) {
				this.model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaBuildMsgView", this.vo.scene)
			}
		}, this, true)

		Util.AddClickEvent(this.desc_gp, () => {
			if (this.vo) {
				this.model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaBuildMsgView", this.vo.scene)
			}
		}, this, true)

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}



	public SetData(vo?, type?, x?, y?) {


		this.vo = vo

		this.type = type
		this.posx = x
		this.posy = y

		if (this.is_loaded) {

			this.UpdateView()

		} else {
			this.need_refresh_data = true

		}

	}



	public UpdateView() {


		let vo = this.vo

		if (vo) {
			this.display_obj.x = this.posx
			this.display_obj.y = this.posy

			ResManager.GetInstance().SetImageSprite(this, this._img_scene, "kfHolyArea_asset", KfHolyAreaDefine.BuildRes[this.type - 1], true)

			if (this.vo.bl_server == 0) {

				if (this.vo.before_blserver > 0) {
					this._lb_server.color = ColorUtil.TryParseHtmlString("#FFFFFF")
					this._server_bg.visible = this._lb_server.visible = true
					let desc = ""
					if (this.model.IsCampMode()) {
						desc = "暂由" + this.model.GetCampName(this.vo.before_blserver) + "占领"
					} else {
						let server_list = this.model.GetCampServerList(this.vo.before_blserver)
						let server_data = server_list[0]
						if (server_data) {
							desc = "暂由S" + server_data.server_num + "." + server_data.server_name + "占领"
						}
					}
					this._lb_server.text = desc 
				} else {
					this._server_bg.visible = this._lb_server.visible = false
				}

			} else {
				this._lb_server.color = "#fff950"//ColorUtil.TryParseHtmlString(KfHolyAreaDefine.Blserver_Color)
				this._server_bg.visible = this._lb_server.visible = true
				if (this.model.IsCampMode()) {
					this._lb_server.text = this.model.GetCampName(this.vo.bl_server) + "占领"
				} else {
					let server_list = this.model.GetCampServerList(this.vo.bl_server)
					let server_data = server_list[0]
					if (server_data) {
						this._lb_server.text = "S" + server_data.server_num + "." + server_data.server_name + "占领"
					}
				}
			}
			if(this._server_bg.visible){
				let bg_width = this._lb_server.width + 40
				if(bg_width < 127){
					bg_width = 127
				}
				this._server_bg.width = bg_width
			}

			if(this._server_bg.visible){
				let bg_width = this._lb_server.width + 40
				if(bg_width < 127){
					bg_width = 127
				}
				this._server_bg.width = bg_width
			}

			SetSizeDelta(this._gp_box, this._img_scene.width, this._img_scene.height)
			this._gp_box.visible = vo.bl_reward_recieve == 1
			ResManager.GetInstance().SetImageSprite(this, this._img_box, "kfHolyArea_asset", "box_" + vo.con_type + "_0", true)
			if (this._gp_box.visible) {
				this.StartAction()
			} else {
				this.StopAction()
			}
			this.scene_id = this.vo.scene
			let sceneInfo = SceneManager.GetInstance().GetSceneInfo(this.vo.scene)
			let boss_count = 0
			for (let _tmpi in this.vo.boss_info) {
				let vo = this.vo.boss_info[_tmpi]
				if (vo.reborn_time == 0 || TimeUtil.getServerTime() > vo.reborn_time) {
					boss_count = boss_count + 1
				}
			}
			let desc = ""
			this._lb_desc.style.fontSize = 18
			this._lb_desc.style.valign = "center"
			this._lb_desc.style.color = "#661c1c"
			this._lb_desc.style.bold = true
			this._lb_desc.style.wordWrap = false
			this._lb_desc.style.leading = 1
			if (sceneInfo) {
				desc = sceneInfo.name + ""
			}
			this._lb_desc.innerHTML = desc
			let color = boss_count == 0 ? "'#fe1a1a'" : "'#00fa64'"
			desc = "剩余怪物:" + HtmlColorTxt(boss_count, color) + "<br>"
			color = this.vo.person == 0 ? "'#fe1a1a'" : "'#00fa64'"
			if (this.model.IsCampMode()) {
				desc = desc + "阵营参战:" + HtmlColorTxt(this.vo.person, color)
			} else {
				desc = desc + "本服参战:" + HtmlColorTxt(this.vo.person, color)
			}
			if (this.vo.bl_server > 0) {
				SetSizeDeltaX(this._img_progress, this.ProgressWidth)
				this._lb_score.text = "已占领"
			} else {
				let occupyVal: number = 0;
				let total_score = 0
				for (let _tmpi in this.vo.boss_info) {
					var _temp = this.vo.boss_info[_tmpi]
					let type_cfg = this.model.GetMonsterTypeCfg(_temp.mon_type, this.vo.con_type)
					if (type_cfg) {
						total_score = total_score + type_cfg.san_score
					}
				}
				if (this.vo.server && this.vo.server.length > 0) {
					let my_server_id = RoleManager.GetInstance().GetMainRoleVo().server_id;
					
					for (let i = 0, len = this.vo.server.length; i < len; i++) {
						let _camp = this.vo.server[i].camp;
						let server_list = this.model.GetCampServerList(_camp)
						let server_data = server_list[0];
						if (server_data) {
							if (server_data.server_id == my_server_id) {
								occupyVal = this.vo.server[i].score
								break
							}
						}
					}	
				}
				this._lb_score.text = occupyVal + "/" + total_score
				SetSizeDeltaX(this._img_progress, occupyVal / total_score * this.ProgressWidth)
			}

			this._lb_desc1.style.fontSize = 18
			this._lb_desc1.style.valign = "center"
			this._lb_desc1.style.color = "#ffffff"
			this._lb_desc1.width = 150
			//this._lb_desc1.style.bold = true
			this._lb_desc1.style.stroke = 2
			this._lb_desc1.style.leading = 4
			this._lb_desc1.style.strokeColor = "#3b484f"
			this._lb_desc1.innerHTML = desc
			this.UpdateEffect()


			if (1 == this.type) {
				SetLocalPositionY(this._lb_server, 70)
				SetLocalPositionY(this._server_bg, 68)
				SetLocalPositionY(this.desc_gp, 125)
			} else if (2 == this.type) {
				SetLocalPositionY(this._lb_server, 85)
				SetLocalPositionY(this._server_bg, 83)
				SetLocalPositionY(this.desc_gp, 130)
			} else if (3 == this.type) {
				SetLocalPositionY(this._lb_server, 100)
				SetLocalPositionY(this._server_bg, 98)
				SetLocalPosition(this.desc_gp, 27, 145)
			}
		}
	}

	public StartAction() {
		this.StopAction()
		this.PlayTween()
	}

	public StopAction() {
		this.ClearTween()
		this.ClearTimer()
	}

	public PlayTween() {
		if (!this.tween_list) {
			this.tween_list = []
		}

		table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, -30, 0.15, () => {
			table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 30, 0.3, () => {
				table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 0, 0.15, () => {
					this.WaitTime()
				}))
			}))
		}))
	}

	public WaitTime() {
		this.ClearTween()
		this.wait_time_id = setTimeout(() => {
			this.PlayTween()
		}, 0.15)
	}

	public ClearTimer() {
		if (this.wait_time_id) {
			clearTimeout(this.wait_time_id)
			this.wait_time_id = false
		}
	}

	public ClearTween() {
		if (this.tween_list) {
			for (let i = 0; i < this.tween_list.length; i++) {
				var v = this.tween_list[i]
				SYTweenLite.Stop(v)
			}
			this.tween_list = false
		}
	}

	public UpdateEffect() {
		this.ClearUIEffect(this._gp_effect)
		if (this.vo.bl_server == 0 && this.model.IsCanAttackScene(this.scene_id)) {
			this.AddUIEffect("UI_2017", this._gp_effect, { x: -0.5, y: -2 }, 10, true)
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this._gp_effect)
		this.StopAction()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_scene,
			this._lb_server,
			this._lb_desc,
			this._gp_effect,
			this._gp_box,
			this._gp_behind,
			this._img_box,
			this._gp_front,
			this.desc_gp,
			this._lb_desc1,
			this._img_progress,
			this._lb_score,
			this._server_bg,
		]
			= this.GetChildrenByNames([
				"_img_scene",
				"_lb_server",
				"_lb_desc",
				"_gp_effect",
				"_gp_box",
				"_gp_behind",
				"_img_box",
				"_gp_front",
				"desc_gp",
				"_lb_desc1",
				"_img_progress",
				"_lb_score",
				"_server_bg",
			])
	}
}
window["KfHolyAreaBuildItem"] = KfHolyAreaBuildItem