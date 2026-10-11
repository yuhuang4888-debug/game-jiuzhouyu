import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { EternityDefine, EternityEvent, EternityModel, EternityTimer } from "../commonModel/EternityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { HtmlColorTxt, Trim, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class EternityBossItem extends BaseItem1 {
	_Group1: Laya.Box
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_img_boss: Laya.Image
	_img_select: Laya.Image
	_gp_name: Laya.Box
	_lb_name: Laya.Label
	_lb_time: Laya.Label
	_gp_btn: Laya.Box
	_lb_server: Laya.HTMLDivElement
	_lb_state: Laya.Label
	_btn_go: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	UpdateTimer
	_data
	_dead_mon_data
	_map_data
	_model

	public constructor(parent?) {
		super(parent)



		this.base_file = "eternity"
		this.layout_file = "EternityBossItem"
		this._model = EternityModel.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_name.size  = 14
			// 	this._lb_time.size  = 14
			// }
			this.LoadSuccess()
			this.InitEvent()
		}
		this.UpdateTimer = () => {
			let time = this._data.reborn_time - TimeUtil.getServerTime()
			if (time < 0) {
				this._model.ClearTimer(EternityTimer.BOSS)
				this.SetTips()
			} else {
				this._lb_time.text = TimeUtil.timeConvert(time, "hh:MM:ss") + "后复活"
			}
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_go, () => {
			this.ClickGo()
		}
			, this, true)
		Util.AddClickEvent(this._Group1, () => {
			this.FindWay()
		}
			, this)
		this.BindEvent(this._model, EternityEvent.SELECT_MON, (mon_id?) => {
			if (!this._map_data) {
				return
			}
			this._img_select.visible = this._map_data.mon_id == mon_id
		}
		)
		this.BindEvent(GlobalEventSystem, SceneManager.START, (scene_id?) => {
			if (scene_id == EternityDefine.BOSS_SCENE) {
				//this.FindWay()
			}
		}
		)
	}

	public DeleteMe() {

		this._model.ClearTimer(EternityTimer.BOSS)
		super.DeleteMe()
	}

	public LoadSuccess() {
	}
	public SetData(data?) {

		this._data = data
		let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.mon_id, false)
		this._lb_name.text = (mdata && (mdata.name + " LV." + data.mon_lv) || (""))
		if (data.reborn_time > TimeUtil.getServerTime()) {
			this._lb_time.color = "#fe1a1a"
			this._model.ClearTimer(EternityTimer.BOSS)
			let func = () => {
				this.UpdateTimer()
			}
			this._model.StartTimer(EternityTimer.BOSS, 1, func)
			this.UpdateTimer()
			this.ShowBtn(false)
		} else {
			if (data.bl_server > 0) {
				let scene_id = SceneManager.GetInstance().GetSceneId()
				let server_this = RoleManager.GetInstance().GetMainRoleVo().server_unique_id
				let can_go = server_this == data.bl_server && scene_id != EternityDefine.BOSS_SCENE
				let str = HtmlColorTxt("S" + data.bl_server_num + "." + data.bl_server_name, "'#000000'")
				this._lb_server.style.fontSize = 16
				this._lb_server.style.color = "#000000"
				this._lb_server.style.wordWrap = false
				this._lb_server.innerHTML = Util.StrToHTML("归属：" + str)
				this._btn_go.visible = can_go
				this.ShowBtn(true)
				this._dead_mon_data = data
				this._lb_state.color = "#ff4f50"
				this._lb_state.text = (scene_id == EternityDefine.BOSS_SCENE && ("已死亡") || (""))
			} else {
				this.SetTips()
				this.ShowBtn(false)
			}
		}
	}

	public ShowBtn(visible?) {

		this._gp_btn.visible = visible
		this._gp_name.visible = !visible
	}

	public SetTips() {

		let scene_id = SceneManager.GetInstance().GetSceneId()
		let in_boss_scene = scene_id == EternityDefine.BOSS_SCENE
		this._lb_time.color = "#19ae4a"
		this._lb_time.text = (in_boss_scene && ("已复活") || ("获得归属可进入源界"))
	}

	public SetMapData(mData?) {

		this._map_data = mData
		let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mData.mon_id, false)
		this._lb_name.text = (mdata && (Trim(mdata.name)) || (""))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_boss, GameResPath.GetMonsterHeadPath(mdata.icon))
		let scene_id = SceneManager.GetInstance().GetSceneId()
		if (scene_id == EternityDefine.BOSS_SCENE) {
			//this.FindWay()
		}
	}

	public ClickGo() {

		if (!this._dead_mon_data) {
			return
		}
		let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this._dead_mon_data.mon_id, false)
		let name = (mdata && (mdata.name) || (""))
		name = HtmlColorTxt(name, Enum_ColorUtil_Dark.RED)
		let str = "我方服务器已成功击杀" + name + "，现已获得进入天启之源权限，是否立即进入？（进入天启之源后将不可退出）"
		Alert.Show(Util.StrToHTML(str), Alert_Type.Two, () => {
			this._model.Fire(EternityEvent.REQUEST_PROTO, 27902, "h", EternityDefine.BOSS_SCENE)
		}
			, null, "立即进入", "稍后进入")
	}

	public FindWay() {

		if (!this._map_data) {
			return
		}
		AutoFightManager.GetInstance().SetAutoFight(false)
		let tar_pos = new Vector2(this._map_data.x / SceneObj.GetLogicRealRatio().x, this._map_data.y / SceneObj.GetLogicRealRatio().y)
		Scene.GetInstance().MainRoleMove(tar_pos, 2, () => {
			AutoFightManager.GetInstance().SetAutoFight(true)
		}
		)
		this._model.Fire(EternityEvent.SELECT_MON, this._map_data.mon_id)
		Scene.GetInstance().SetClickTarget(null)
		
	}


	public GetComponents() {
		[
			this._Group1,
			this._img_bg,
			this._Image1,
			this._img_boss,
			this._img_select,
			this._gp_name,
			this._lb_name,
			this._lb_time,
			this._gp_btn,
			this._lb_server,
			this._lb_state,
			this._btn_go,
			this._Image2,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_img_bg",
				"_Image1",
				"_img_boss",
				"_img_select",
				"_gp_name",
				"_lb_name",
				"_lb_time",
				"_gp_btn",
				"_lb_server",
				"_lb_state",
				"_btn_go",
				"_Image2",
				"_Label1",
			])
	}
}
window["EternityBossItem"] = EternityBossItem