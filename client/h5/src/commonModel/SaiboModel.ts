import { ResManager } from "../common/ResManager"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"

export class SaiBoModelEvent {
	public static SELECT_BUY = "SaiBoModelEvent_SELECT_BUY";
	// 奖励页签选中
	public static SELECT_TAB = "SaiBoModelEvent_SELECT_TAB";
}

export class SaiboModel extends EventDispatcher {
	GetCostCfg
	GetCostCfgByTimes
	GetOnePoolCfg
	GetPoolAllNum
	GetPoolCurWaveRewards
	GetPoolStageCfg
	GetPoolWaveNum
	GetStageCfg
	GetStageNum
	InitDiscountNum
	InitReward
	ParseCfg
	discount_num

	private static instance: SaiboModel;

	// 配置
	private draw_pool_cfg_: any = null
	private draw_cost_cfg_: any = null
	private draw_stage_reward_cfg_: any = null

	public static GetInstance() {

		if (!SaiboModel.instance) {
			SaiboModel.instance = new SaiboModel();
		}
		return SaiboModel.instance;
	}

	public constructor() {
		super()


		this.discount_num = 0;
		let local_Erlang = ErlangParser.GetInstance()

		let stage_reward_dic_ = []
		let pool_dic_ = []
		let all_reward_num_dic_ = []


		this.InitDiscountNum = () => {
			if (this.draw_cost_cfg_) {
				for (let i in this.draw_cost_cfg_) {

					let vo = this.draw_cost_cfg_[i]
					if (vo.is_dis == 1) {
						this.discount_num = (this.discount_num > vo.max && (this.discount_num) || (vo.max))
					}
				}
			}
		}

		this.InitReward = () => {
			if (this.draw_stage_reward_cfg_) {
				for (let key in this.draw_stage_reward_cfg_) {

					let vo = this.draw_stage_reward_cfg_[key]
					if (!vo) {
						return
					}
					let base_type = vo.type
					let subtype = vo.subtype
					stage_reward_dic_[base_type] = stage_reward_dic_[base_type] || {}
					stage_reward_dic_[base_type][subtype] = stage_reward_dic_[base_type][subtype] || {}
					stage_reward_dic_[base_type][subtype][vo.stage] = stage_reward_dic_[base_type][subtype][vo.stage] || {}
					stage_reward_dic_[base_type][subtype][vo.stage][vo.grade] = vo
					if (vo.condition && typeof (vo.condition) == "string") {
						vo.condition = this.ParseCfg(vo.condition)
					}
					if (vo.dis_reward && typeof (vo.dis_reward) == "string") {
						vo.dis_reward = JSON.parse(vo.dis_reward)
					}
					if (vo.discount && typeof (vo.discount) == "string") {
						vo.discount = JSON.parse(vo.discount)
					}
					if (vo.reward && typeof (vo.reward) == "string") {
						vo.reward = JSON.parse(vo.reward)
					}
					if (vo.show && typeof (vo.show) == "string") {
						vo.show = JSON.parse(vo.show)
					}
				}
			}
			if (this.draw_cost_cfg_) {
				for (let i in this.draw_cost_cfg_) {
					const e = this.draw_cost_cfg_[i]
					let cost = e.cost
					if (cost && typeof (cost) == "string") {
						cost = ErlangParser.GetInstance().Parse(e);
					}
				}
			}
			if (this.draw_pool_cfg_) {
				for (let i in this.draw_pool_cfg_) {
					var vo = this.draw_pool_cfg_[i]
					if (vo) {
						let base_type = vo.type
						let subtype = vo.subtype
						pool_dic_[base_type] = pool_dic_[base_type] || {}
						pool_dic_[base_type][subtype] = pool_dic_[base_type][subtype] || {}
						pool_dic_[base_type][subtype][vo.wave] = pool_dic_[base_type][subtype][vo.wave] || {}
						pool_dic_[base_type][subtype][vo.wave][vo.grade] = vo
						all_reward_num_dic_[base_type] = all_reward_num_dic_[base_type] || {}
						all_reward_num_dic_[base_type][subtype] = all_reward_num_dic_[base_type][subtype] || 0
						let num = all_reward_num_dic_[base_type][subtype] + 1
						all_reward_num_dic_[base_type][subtype] = num
						let reward = vo.reward
						if (reward && typeof (reward) == "string") {
							vo.reward = JSON.parse(reward)
						}
					}
				}
			}
		}

		this.ParseCfg = (str?) => {
			str = JSON.parse(str)
			let dic = []
			for (let _tmpi in str) {
				var vo = str[_tmpi]
				dic[vo[0]] = vo[1]
			}
			return dic
		}

		this.GetStageNum = (base_type?, sub_type?) => {
			let pool_stage = stage_reward_dic_[base_type][sub_type]
			return Util.TableSize(pool_stage)
		}

		this.GetStageCfg = (base_type?, sub_type?, stage?, grade?) => {
			if (stage_reward_dic_[base_type] && stage_reward_dic_[base_type][sub_type]) {
				if (stage != null && grade != null) {
					if (stage_reward_dic_[base_type][sub_type][stage]) {
						return stage_reward_dic_[base_type][sub_type][stage][grade]
					}
				} else if (stage != null) {
					if (stage_reward_dic_[base_type][sub_type]) {
						return stage_reward_dic_[base_type][sub_type][stage]
					}
				} else {
					return stage_reward_dic_[base_type][sub_type]
				}
			}
			return null
		}

		this.GetPoolStageCfg = (base_type?, sub_type?) => {
			if (pool_dic_[base_type]) {
				return pool_dic_[base_type][sub_type]
			}
			return null
		}

		this.GetPoolWaveNum = (base_type?, sub_type?) => {
			let pool_stage = this.draw_pool_cfg_[base_type] && this.draw_pool_cfg_[base_type][sub_type]
			return Util.TableSize(pool_stage)
		}

		this.GetOnePoolCfg = (base_type?, sub_type?, wave?, grade?) => {
			let key = base_type + "@" + sub_type + "@" + wave + "@" + grade
			return this.draw_pool_cfg_[key]
		}

		this.GetPoolAllNum = (base_type?, sub_type?) => {
			return all_reward_num_dic_[base_type] && all_reward_num_dic_[base_type][sub_type]
		}

		this.GetPoolCurWaveRewards = (base_type?, sub_type?, wave?) => {
			if ((pool_dic_[base_type] && pool_dic_[base_type][sub_type]) && pool_dic_[base_type][sub_type]) {
				return pool_dic_[base_type][sub_type][wave]
			}
			return null
		}

		this.GetCostCfg = () => {
			return this.draw_cost_cfg_;
		}

		this.GetCostCfgByTimes = (times?) => {
			let next_times = times + 1
			if (this.draw_cost_cfg_) {
				for (let i in this.draw_cost_cfg_) {
					let vo = this.draw_cost_cfg_[i]
					if (next_times >= vo.min && next_times <= vo.max) {
						return vo
					}
				}
			}
			return null
		}
	}

	/**
	 * 初始化配置
	 */
	public async InitConfig() {
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_draw_cost',
			false,
			undefined,
			(obj) => {
				this.draw_cost_cfg_ = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_draw_cost', false);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_draw_normal_pool',
			false,
			undefined,
			(obj) => {
				this.draw_pool_cfg_ = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_draw_normal_pool', false);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_draw_stage_reward',
			false,
			undefined,
			(obj) => {
				this.draw_stage_reward_cfg_ = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_draw_stage_reward', false);
			}
		);
		this.InitReward();
		this.InitDiscountNum();
	}

}

