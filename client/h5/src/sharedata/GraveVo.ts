
/*@//////////////////////////////////////////////////////////////////
	@description:墓碑Vo
	@author:wyb
//////////////////////////////////////////////////////////////////////*/

import { SceneBaseType } from "../scene/SceneConfig"
import { EventDispatcher } from "../util/EventDispatcher"
import { PoseState } from "../util/StateMachineManager"
import { Trim } from "../util/Util"
import { Config } from "../common/Config"

export class GraveVo extends EventDispatcher {
	birth_angle
	birth_effect_res
	boss_id
	cfg_data
	classification
	color
	foot_effect_res
	icon_scale
	instance_id
	is_blood_bar
	is_hide_hp
	is_hit_ac
	level
	load_immediately
	monster_res
	name
	pos_x
	pos_y
	refresh_time
	type_id
	ure_res
	is_armor
	public constructor() {
		super()
	}


	public SetGraveVo(vo?) {

		this.instance_id = vo.boss_id	   //怪物唯一标识(int32)
		this.type_id = vo.type_id
		this.boss_id = vo.boss_id
		this.pos_x = vo.pos_x
		this.pos_y = vo.pos_y
		this.level = vo.level
		this.name = vo.name
		this.refresh_time = vo.refresh_time
		this.SetBasePropertyFromConfig()
	}

	public SetBasePropertyFromConfig() {

		this.CacheCfgData()
		if (this.cfg_data == null) {
			return
		}
		this.monster_res = this.cfg_data.icon
		this.ure_res = this.cfg_data.icon_texture
		this.is_armor = this.cfg_data.is_armor || 0 				//是否霸体
		//console.log("怪物资源缩放：", this.cfg_data.icon_scale, Number(this.cfg_data.icon_scale))
		this.icon_scale = Number(this.cfg_data.icon_scale)
		this.is_blood_bar = Number(this.cfg_data.is_blood_bar)
		this.color = Number(this.cfg_data.color)
		if (this.birth_angle == 0) {
			this.birth_angle = Number(this.cfg_data.direction)
			if (this.birth_angle == -1) {
				this.birth_angle = null
			}
		}
		this.birth_effect_res = Trim(this.cfg_data.mon_state) || "" //出生特效
		this.foot_effect_res = Trim(this.cfg_data.foot_icon) || "" //脚下特效
		this.classification = Trim(this.cfg_data.classification) || ""  //怪物分类名字
		this.load_immediately = Number(this.cfg_data.load_immediately) || 0 //是否立即加载怪物
		this.is_hit_ac = Number(this.cfg_data.is_hit_ac) || 0 //是否需要受击动作

		this.is_hide_hp = (this.cfg_data.is_hide_hp == 1)
		// console.log("怪物显示血条名字怪物显示血条名字", this.name, this.is_hide_hp, this.birth_angle == -1 , this.is_hit_ac, this.is_hit_ac != 0)
	}


	public CacheCfgData() {
        if (!this.cfg_data)
            this.cfg_data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.type_id, false); //Config.PRELOAD_SERVER_CONFIG.config_mon[this.type_id]
    }


	public GetFashionTextureId() {

		if (Number(this.ure_res) != 0) {
			return this.monster_res + "_" + this.ure_res
		}
	}


	public DeleteMe() {
		super.DeleteMe()
	}

}
window["GraveVo"]=GraveVo
