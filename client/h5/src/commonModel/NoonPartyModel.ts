import { ResManager } from "../common/ResManager"
import { Scene } from "../scene/Scene"
import { MonsterType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameMath } from "../util/GameMath"
import { Config } from "../common/Config"
import { Util } from "../util/Util"

export const NoonPEvent = {
	UPDATE_EXP: "NE1",
	UPDATE_BOX: "NE2",
	REQUEST_PROTO: "NE3",
	OPEN_VIEW: "NE4",
	BOSS_RELIVE_TIME: "NE5",
	ENTER_SCENE: "NE6",
	UPDATE_END_TIME: "NE7"
}
window["NoonPEvent"] = NoonPEvent

export class NoonPartyModel extends EventDispatcher {

	static _instance
	
	CollectCountCond
	ExpInfo
	FindNearestCollect
	LvLimit
	AddCanNotCollectMon
	ClearNotCollectMon
	DeleteNotCollectMon
	CanCollect
	InitInfo


	box_info
	nomBoxId
	nomBoxMax
	nomGoodsId
	rareBoxId
	rareBoxMax
	rareGoodsId

	kv_cfg
	can_not_collect_mon_id_dic
	public constructor() {
		super()

		if (NoonPartyModel._instance) {
			return
		}
		this.nomBoxMax = 20;
		this.rareBoxMax = 10;
		this.LvLimit = 150;
		this.ExpInfo = 0;
		this.nomBoxId = 29007;
		this.rareBoxId = 29008;
		this.nomGoodsId = 32010182;
		this.rareGoodsId = 32010183;
		let scene = Scene.GetInstance()
		this.InitInfo = () => {
			this.kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_midday_party_key_value
			this.can_not_collect_mon_id_dic = null
		}

		this.FindNearestCollect = () => {
			if (!scene.main_role) {
				return
			}
			let mon,
				mindist,
				real_pos = scene.main_role.GetLogicPos(),
				mon_real_pos,
				monster,
				cant_collect_count = 0,
				collecnt_count = 0

			for (let id in scene.monster_list) {
				monster = scene.monster_list[id]
				if(monster.vo && monster.vo.type == MonsterType.COLLECT){
					if(!this.CollectCountCond(monster.vo.type_id)){
						continue
					}
					collecnt_count++
					if(!this.CanCollect(id)){
						cant_collect_count ++
						continue
					}
					mon_real_pos = monster.GetRealPos()
					let dist_pw = GameMath.GetDistance(mon_real_pos.x, mon_real_pos.y, real_pos.x, real_pos.y, false)
					if ((!mon || monster.vo.type_id > mon.vo.type_id) || (monster.vo.type_id == mon.vo.type_id && mindist > dist_pw)) {
						mon = monster
						mindist = dist_pw
					}
					
					
				}
			}

			if(!mon && cant_collect_count > 0){
				//如果当前采集怪物数量和屏蔽的采集怪数量相等,那么清理屏蔽采集怪列表
				if(collecnt_count == cant_collect_count){
					this.ClearNotCollectMon()
				}
			}

			return mon
		}

		/**判断剩余数量 */
		this.CollectCountCond = (type_id?) => {
			if (!this.box_info || !this.kv_cfg) {
				return
			}
			let nomBoxMax = null
			let rareBoxMax = null
			nomBoxMax = this.kv_cfg[5].value
			rareBoxMax = this.kv_cfg[6].value
			if (type_id == this.nomBoxId && this.box_info.low_box < nomBoxMax) {
				return true
			} else if (type_id == this.rareBoxId && this.box_info.high_box < rareBoxMax) {
				return true
			}
		}

		this.AddCanNotCollectMon = (mon_id?) => {
			if (!this.can_not_collect_mon_id_dic) {
				this.can_not_collect_mon_id_dic = {}
			}
			this.can_not_collect_mon_id_dic[mon_id] = true
		}
	
		this.ClearNotCollectMon = () => {
			this.can_not_collect_mon_id_dic = null
		}
	
		this.DeleteNotCollectMon = (mon_id?) => {
			if (this.can_not_collect_mon_id_dic && this.can_not_collect_mon_id_dic[mon_id]) {
				delete this.can_not_collect_mon_id_dic[mon_id]
			}
		}
	
		this.CanCollect = (mon_id?) => {
			let can_collect = true
			if (this.can_not_collect_mon_id_dic && this.can_not_collect_mon_id_dic[mon_id]) {
				can_collect = false
			}
			return can_collect
		}


	}

	public static GetInstance() {

		if (!NoonPartyModel._instance) {
			NoonPartyModel._instance = new NoonPartyModel()
		}
		return NoonPartyModel._instance
	}

}
window["NoonPartyModel"] = NoonPartyModel