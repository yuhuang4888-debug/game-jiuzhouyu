import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager";
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { EventDispatcher } from "../util/EventDispatcher"

export const MapEvent = {
	MAP_REQUEST_PROTO: "MAP_REQUEST_PROTO",
};
window["MapEvent"] = MapEvent;
export class MapModel extends EventDispatcher {
	static Instance
	CanEnterScene
	CanOpenMapView
	CheckOpenAutoFight
	FiledSceneCanEnter
	GetSceneMonBySceneId
	InitConfig
	now_scene_id
	map_cfgs

	public static CLOSEMAPENTVIEW = "CLOSEMAPENTVIEW"
	public static CLEAR_WAY = "CLEAR_WAY"

	public constructor() {
		super()
		let scene_mgr = SceneManager.GetInstance()
		this.now_scene_id = null
		let scene_mon_list_ = null
		this.InitConfig = () => {
			this.map_cfgs = Config.PRELOAD_CLIENT_CONFIG.ClientMapConfig
		}

		this.CanOpenMapView = (scene_id?) => {
			scene_id = scene_id || scene_mgr.GetSceneId()
			let map_cfg = this.map_cfgs[scene_id]
			if (map_cfg) {
				return true
			}
			return false
		}

		this.GetSceneMonBySceneId = (scene_id?, cfgs?) => {
			if (!scene_mon_list_) {
				scene_mon_list_ = []
			}
			// [ts2lua]scene_mon_list_下标访问可能不正确
			if (!scene_mon_list_[scene_id] || scene_mgr.IsGuildFightScene(scene_id)) {
				this.now_scene_id = scene_id
				for (let key in cfgs) {

					// [ts2lua]Config.ClientMapConfig下标访问可能不正确
					let cfg = cfgs[key]
					if (cfg.scene_id == scene_id) {
						if (scene_mgr.IsGuildFightScene(scene_id)) {
							// [ts2lua]scene_mon_list_下标访问可能不正确
							//scene_mon_list_[scene_id] = GuildFightModel.GetInstance().GetMapList(cfg)
						} else {
							// [ts2lua]scene_mon_list_下标访问可能不正确
							scene_mon_list_[scene_id] = cfg
						}
					}
				}
			}
			// [ts2lua]scene_mon_list_下标访问可能不正确
			return scene_mon_list_[scene_id]
		}

		this.CheckOpenAutoFight = () => {
			let open = true
			if (scene_mgr.IsHolyBossScene()) {
				//let data = BossModel.GetInstance().GetBossTypeInfo(BossModel.BossType.holy)
				//if (data ) {
				//let bool = data.tired == data.max_tired
				//open = ! bool
				//if (bool ) {
				//Message.show("今日疲劳已满，无法对BOSS造成伤害！")
				//}
				//}
			}
			return open
		}

		//目标场景是否可以进入
		this.CanEnterScene = (scene_id?) => {
			return true
		}

		//世界地图里面的场景是否可以进入
		this.FiledSceneCanEnter = (scene_id?) => {
			let can_enter = false
			let cfgs = Config.PRELOAD_CLIENT_CONFIG.ClientWorldMapConfig
			if (cfgs.world_map) {
				let level = RoleManager.GetInstance().mainRoleInfo.level
				for (let k in cfgs.world_map) {
					var v = cfgs.world_map[k]
					if (v.scene_id == scene_id && v.scene_lv[1]) {
						if (level >= v.scene_lv[1]) {
							can_enter = true
							break
						}
					}
				}
			}
			return can_enter
		}

	}

	public static GetInstance() {

		if (!MapModel.Instance) {
			MapModel.Instance = new MapModel()
		}
		return MapModel.Instance
	}

}
window["MapModel"] = MapModel