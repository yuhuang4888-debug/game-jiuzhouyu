import { AutoFightManager } from "../autofight/AutoFightManager"
import { EventName, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Scene } from "../scene/Scene"
import { MainRole } from "../scene/sceneobj/MainRole"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameMath } from "../util/GameMath"
import { Vector2 } from "../util/Vector2"
import { BossModel } from "./BossModel"

export class TreasureMapModel extends EventDispatcher {
	BossAddData
	BossDeleteData
	BossGetListByType
	BossSetData
	BossTtOpenEnterView
	GetTMCollect
	GetproviewReward
	InitConfig
	Reset
	SetFindingWayState
	SetProviewReward
	TreasureMove
	collecting
	findingWay
	goods_list
	is_change_scene
	is_next_use_type
	is_request
	limit_lv
	open_alert
	rotary_data
	scmd20301_data
	use_good_vo

	private confTreasureMap: any;

	public static TM_REQUEST_SCMD = "TreasureMapModel.TM_REQUEST_SCMD";
	public static TM_GET_REWARD = "TreasureMapModel.TM_GET_REWARD";
	public static TM_USE_GOODS = "TreasureMapModel.TM_USE_GOODS";
	public static TM_COLLECT = "TreasureMapModel.TM_COLLECT";
	public static TM_USE_GOODS_AGAIN = "TreasureMapModel.TM_USE_GOODS_AGAIN";
	public static TM_FINDING_WAY = "TreasureMapModel.TM_FINDING_WAY";
	public static TM_ROTARY_NUM = "TreasureMapModel.TM_ROTARY_NUM";
	public static TM_ROTARY_UPDATA = "TreasureMapModel.TM_ROTARY_UPDATA";
	public static TM_RECORD_LIST = "TreasureMapModel.TM_RECORD_LIST";

	private static _instance: TreasureMapModel;
	public static GetInstance() {
		if (!TreasureMapModel._instance) {
			TreasureMapModel._instance = new TreasureMapModel();
		}
		return TreasureMapModel._instance;
	}

	public constructor() {
		super()


		this.is_change_scene = false;
		this.goods_list = [];
		this.limit_lv = 0;
		this.is_next_use_type = 0;
		this.collecting = false;
		this.findingWay = false;
		this.open_alert = true;
		this.is_request = false;
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let proview_rewards_ = null
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		this.InitConfig = async () => {
			let callback = (cfg?) => {
				if (cfg) {
					if (cfg.lv_limit) {
						this.limit_lv = Number(cfg.lv_limit.value)
					}
					if (cfg.map1) {
						this.goods_list[1] = Number(cfg.map1.value)
					}
					if (cfg.map2) {
						this.goods_list[2] = Number(cfg.map2.value)
					}
				}
				this.confTreasureMap = cfg;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_treasure_map_kv', false);
			}

			await ResManager.GetInstance().LoadGameConfig(
				this,
				'config_treasure_map_kv',
				false,
				undefined,
				(obj) => {
					callback(obj);
				}
			);
		}

		this.SetProviewReward = (list?) => {
			proview_rewards_ = list
		}

		this.GetproviewReward = () => {
			return proview_rewards_
		}

		this.TreasureMove = (data?) => {
			let mainRole: MainRole = Scene.GetInstance().main_role
			let real_x = data.x / SceneObj.GetLogicRealRatio().x;
			let real_y = data.y / SceneObj.GetLogicRealRatio().y;
			let distance: number = GameMath.GetDistance(data.x, data.y, mainRole.x, mainRole.y, true)
			let rang = 1
			let end_func = () => {
				this.collecting = true;
				GlobalEventSystem.Fire(SceneEventType.CHANGE_FIND_WAY_STATE);
				let vo = this.use_good_vo;
				if (vo) {
					let collect_end = () => {
						this.Fire(TreasureMapModel.TM_COLLECT);
					}
					let close_call_back = () =>{
						this.collecting = false;
					}
					GlobalEventSystem.Fire(EventName.START_TO_COLLECT);
					Scene.GetInstance().MainRoleDoCollect();
					GlobalEventSystem.Fire(EventName.OPEN_COLLECT_VIEW, 0, 0, 2, true, collect_end, "挖宝中...", close_call_back, "ui_cj_1003");
				}
			}
			auto_fight_mgr.SetAutoFight(false);
			Scene.GetInstance().MainRoleMove(new Vector2(real_x, real_y), rang, end_func);
			if (distance > 35) {
				this.SetFindingWayState(true);
			}
		}

		this.Reset = () => {
			auto_fight_mgr.SetAutoFight(true)
			this.scmd20301_data = null
			this.use_good_vo = null
			this.is_change_scene = false
		}

		this.GetTMCollect = () => {
			return this.collecting
		}

		this.SetFindingWayState = (bool?) => {
			this.findingWay = bool
			this.Fire(TreasureMapModel.TM_FINDING_WAY, bool)

		}

		let BossType = BossModel.BossType
		this.BossTtOpenEnterView = (data?) => {
			if (!data) {
				return
			}
			local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossTurnEnterView", data)
		}

		this.BossAddData = (v?) => {
			if (!this.rotary_data) {
				this.rotary_data = []
				this.rotary_data[BossType.field] = []
				this.rotary_data[BossType.mystery] = []
			}
			if (BossType.field == v.boss_type) {
				table.insert(this.rotary_data[BossType.field], v)
			} else if (BossType.mystery == v.boss_type) {
				table.insert(this.rotary_data[BossType.mystery], v)
			}
		}

		this.BossDeleteData = (rotary_id?) => {
			if (rotary_id != null && this.rotary_data) {
				for (let key in this.rotary_data) {

					let list = this.rotary_data[key]
					if (list) {
						for (let i in list) {

							if (list[i].rotary_id == rotary_id) {
								list.splice(i, 1)
								this.Fire(TreasureMapModel.TM_ROTARY_NUM)
								return
							}
						}
					}
				}
			}
		}

		this.BossSetData = (scmd?) => {
			this.rotary_data = null
			let list = scmd && scmd.rotary_list
			if (list) {
				for (let _tmpi in list) {
					var v = list[_tmpi]
					this.BossAddData(v)
				}
			}
		}

		this.BossGetListByType = (type?) => {
			if (this.rotary_data) {
				return this.rotary_data[type]
			}
			return null
		}

		this.InitConfig();
	}


}
