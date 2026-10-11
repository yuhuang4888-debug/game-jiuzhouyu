
/*@//////////////////////////////////////////////////////////////////
	@description:墓碑
	@author:wyb
//////////////////////////////////////////////////////////////////////*/

import { SceneEventType } from "../../common/EventName"
import { ResManager } from "../../common/ResManager"
import { BossModel } from "../../commonModel/BossModel"
import { RoleManager } from "../../commonModel/RoleManager"
import { ParticleManager } from "../../particalEffect/ParticleManager"
import { ColorUtil, Enum_ColorUtil_Dark } from "../../util/ColorUtil"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { TimeUtil } from "../../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt } from "../../util/Util"
import { Vector2 } from "../../util/Vector2"
import { CameraManager } from "../CameraManager"
import { EffectResType, SceneBaseType } from "../SceneConfig"
import { Character } from "./Character"
import { SceneObj } from "./SceneObj"

export class Grave extends Character {
	refresh_time
	timer_id
	boss_lv
	effect_id
	pos
	public static ParticleResName = "scene_bossIsDead"


	public constructor() {
		super()
		this._type = SceneBaseType.Grave
	}

	public ResetObj() {
		this.ResetCharacter()
	}
	public DeleteMe() {
		super.DeleteMe()
	}

	public ReleaseObj() {
		this.ReleaseCharacter()

		if (this.effect_id) {
			ParticleManager.GetInstance().DelEffect(this.effect_id)
			this.effect_id = null
		}


		if (this.name_board) {
			this.name_board.SetName("")
			this.name_board.SetGuildText("")
		}

		this.CancelTime()
	}

	public InitGraveVo(vo?) {

		this.vo = vo
		this.id = vo.boss_id
		this.name = vo.boss_name

		//boss等级
		if(this.scene_mgr.IsHolyTerritory()){
			this.boss_lv=RoleManager.GetInstance().mainRoleInfo.worldLv
		}else{
			this.boss_lv = vo.lv
		}

		this.refresh_time = vo.reborn_time-TimeUtil.getServerTime()
		this.SetHideNameBord(false)

		this.compress_id = this.scene.CompressObjId(SceneBaseType.Grave, this.id || 0)

		if(vo.boss_type==BossModel.GRAVE_KF_HOLY_BOSS_TYPE
			||vo.boss_type==BossModel.GRAVE_ETERNITY_BOSS_TYPE){
			this.pos = vo["pos"]
			
		}else{
			let eudemons_boss_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
			let boss_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			this.pos = BossModel.GetInstance().GetBossPos(vo.boss_id, vo.boss_type, eudemons_boss_cfg, boss_cfg)
		}
	



		//特效
		this.effect_id = ParticleManager.GetInstance().AddPosEffect(Grave.ParticleResName, new Vector2(this.pos.x, this.pos.y), true,
			null, null, false, null, null, null, 1, true, null, null, null, null, EffectResType.Other)
		if (this.name_board) this.name_board.SetHpVisible(false)


		//设置名字
		if(this.name_board){
			let name_str=`Lv.${this.boss_lv} ${this.name}`
			this.name_board.SetName(name_str, "#fcf910", 36)
		}

	
	}


	public LoadClotheResComplete() {

		super.LoadClotheResComplete()
	}


	public LoadInfoFromVo() {

		//this.SetMoveSpeed(this.vo.move_speed)
		this.SetRealPos(this.pos.x, this.pos.y, true)
		//this.DoStand()
		this.CancelTime()
		this.StartTimer()
		this.SetNameBoardPos()
	}

	public StartTimer() {

		var onTimer = () => {
			this.refresh_time = this.refresh_time - 1
			if (this.refresh_time <= 0) {
				this.ReleaseObj()
				this.CancelTime()
			} else {
				this.SetNameContent()
			}
		}
		this.timer_id = GlobalTimerQuest.AddPeriodQuest(onTimer, 1, -1)
	}

	public CancelTime() {

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}

	public SetNameContent() {
		if (this.name_board) {
			let time_str = `${TimeUtil.timeConvert(this.refresh_time, "hh:MM:ss")}后刷新`
			this.name_board.SetNpcName(time_str,ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED),2)
			
		}
	}

	public SetNameBoardPos() {
		if (this.name_board) {
			this.name_board.SetAttachResHeight(180) //设置一个默认高度
			this.name_board.UpdatePos(this.pos.x, this.pos.y)
		}

	}

	
	public Update(now_time?, elapse_time?) {
		super.Update(now_time, elapse_time)
	}

}

window["Grave"] = Grave