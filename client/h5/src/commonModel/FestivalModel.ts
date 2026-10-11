import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { MainRoleVo } from '../sharedata/MainRoleVo';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { ErlangParser } from '../util/ErlangParser';
import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';
import { RoleManager } from './RoleManager';

export interface IS2CFestivalTasks {
	// 所有任务数据
	type_list: IS2CFestivalTaskType[];
}

export interface IS2CFestivalTaskType {
	// 任务类型 1 每日任务 2 每周任务 3 赛季任务
	type: number;
	task_list: IS2CFestivalTaskInfo[];
	// 任务刷新时间戳
	refresh_time: number;
}

export interface IS2CFestivalTaskInfo {
	// 任务id
	task_id: number;
	// 已完成次数
	finish_times: number;
	// 当前任务数值
	cur_num: number;
	// 状态 0 未完成 1 未领取 2 已领取
	status: number;
}

export interface IS2CFestivalBasicInfo {
	uid: number; // 祭典唯一id
	act_id: number; // 活动id
	type: number; // 祭典类型 0 普通版 1 豪华版 2 至尊版
	lv: number; // 当前等级
	exp: number; // 当前累计经验
	expired_time: number; // 过期时间戳
	reward_list: IS2CFestivalBasicInfoRewaed[];
}

export interface IS2CFestivalBasicInfoRewaed {
	lv: number; // 祭典等级
	// reward1 :string // 奖励 客户端读配置获取
	status1: number; // 状态 1 未领取 2 已领取
	// reward2 :string // 高级奖励 客户端读配置获取
	status2: number; // 状态 1 未领取 2 已领取
}

export interface ICConfFiestaTask {
	id: number;
	type: number;
	content: string;
	desc: string;
	open_day: number;
	open_lv: number;
	times: number;
	target_num: number;
	exp: number;
	link_id: number;
	sort: number;
}

export interface ICConfFiestaLvExp {
	id: number;
	act_id: number;
	lv: number;
	exp: number;
	reward: string;
	premium_reward: string;
	is_key_stage: number;
	isOrder?: boolean
}

export interface IFestivalGetRewardParam {
	type: EnumFestivalGetRewardType,
	rewars1: any[];
	rewars2?: any[];
	festivalType?: EnumFestivalType,
	festivalTypeName?: EnumFestivalTypeName
}

export enum EnumFestivalTaskTab {
	// 每日任务
	eDay = 1,
	// 每周任务
	eWeek,
	// 赛季任务
	eSeason,
}

export enum EnumFestivalInstructionType {
	// 7天
	eSeven = 22301,
	// 30天
	eThirty = 22302

}

export enum EnumFestivalGetRewardType {
	// 无购买并领取
	eNotBuy,
	// 已购买并领取
	eBought,
	// 购买界面
	eBuy
}

/**
 * 庆典类型
 */
export enum EnumFestivalType {
	// 豪华庆典
	eLuxury = 1,
	// 至尊庆典
	eSupreme = 2
}

export enum EnumFestivalTypeName {
	// 豪华庆典
	eLuxury = 'content1',
	// 至尊庆典
	eSupreme = 'content2'
}


/**
 * 祭典事件类型类
 */
export class FestivalModelEvent {
	static _cname = 'FestivalModelEvent';
	/**所有任务更新 */
	public static FESTIVAL_UPDATE_TASK_ALL: string =
		FestivalModelEvent._cname + '.' + 'UPDATE_TASK_ALL';
	/**祭典信息初始化 */
	public static FESTIVAL_BASIC_INIT: string =
		FestivalModelEvent._cname + '.' + 'BASIC_INIT';
	/**祭典协议发送 */
	public static FESTIVAL_REQUEST_PROTO: string =
		FestivalModelEvent._cname + '.' + 'REQUEST_PROTO';
	/**打开祭典 */
	public static OPEN_FESTIVAL_VIEW: string =
		FestivalModelEvent._cname + '.' + 'OPEN_FESTIVAL_VIEW';
	/**关闭祭典 */
	public static CLOSE_FESTIVAL_VIEW: string =
		FestivalModelEvent._cname + '.' + 'CLOSE_FESTIVAL_VIEW';
	/**祭典任务页签选中 */
	public static FESTIVAL_TASK_TAB_SELECT: string =
		FestivalModelEvent._cname + '.' + 'FESTIVAL_TASK_TAB_SELECT';
	/**祭典任务刷新 */
	public static FESTIVAL_TASK_UPDATE: string =
		FestivalModelEvent._cname + '.' + 'FESTIVAL_TASK_UPDATE';
}

export class FestivalModel extends EventDispatcher {
	private static _instance: FestivalModel;
	public static GetInstance() {
		if (!FestivalModel._instance) {
			FestivalModel._instance = new FestivalModel();
		}
		return FestivalModel._instance;
	}

	public static ICON_TYPE: number = 223;
	private readonly goosId: number = 37120001; // 拿这个商品id做经验换算;
	// 每次登陆红点,点击祭典按钮后设置false
	private _loginRedDot: boolean = true;
	// 本次登陆不在提示
	private _loginTips: boolean = false;

	// 祭典基础信息
	private _festivalBasicInfo: IS2CFestivalBasicInfo;
	// 页签对应任务数据
	private _tasksMap: TMap<EnumFestivalTaskTab, IS2CFestivalTaskType>;
	// 祭典等级奖励
	private _levelMap: TMap<number, IS2CFestivalBasicInfoRewaed>;
	// 所有任务数据
	private _taskAll: IS2CFestivalTasks;


	// 配置
	private _confFiestaTask: any;
	private _confFiestaLvExp: any;
	private _confFiestaKv: any;
	private _confFiestaAct: any;
	private _confFiestaTaskTab: any;
	private confGoodsEffect: any;

	public constructor() {
		super();
		this._tasksMap = new TMap<EnumFestivalTaskTab, IS2CFestivalTaskType>();
		this._levelMap = new TMap<number, IS2CFestivalBasicInfoRewaed>();
	}

	public get confFiestaLvExp() {
		return this._confFiestaLvExp;
	}

	public get loginRedDot() {
		return this._loginRedDot;
	}
	public set loginRedDot(bool: boolean) {
		this._loginRedDot = bool;
	}

	public get loginTips() {
		return this._loginTips;
	}
	public set loginTips(bool: boolean) {
		this._loginTips = bool;
	}

	public GetFestivalBasicInfo(): IS2CFestivalBasicInfo {
		return this._festivalBasicInfo;
	}

	public SetFestivalBasicInfo(value: IS2CFestivalBasicInfo) {
		this._festivalBasicInfo = value;

		for (const iterator of value.reward_list) {
			this.SetLevelMap(iterator);
		}
		this.UpdateEntranceRedDot();
		this.Fire(FestivalModelEvent.FESTIVAL_BASIC_INIT);

	}

	public SetTaskAll(value: IS2CFestivalTasks) {
		for (const iterator of value.type_list) {
			this._tasksMap.set(iterator.type, iterator);
		}
		this.UpdateEntranceRedDot();
		this.Fire(FestivalModelEvent.FESTIVAL_UPDATE_TASK_ALL);
	}

	public GetTasksByTypeMap(type: EnumFestivalTaskTab): IS2CFestivalTaskType {
		return this._tasksMap.get(type);
	}

	public SetTasksByTypeMap(value: IS2CFestivalTaskType): void {
		return this._tasksMap.set(value.type, value);
	}

	public GetTasksByTypeMapValues(): IS2CFestivalTaskType[] {
		return this._tasksMap.values;
	}

	public GetTasksByTypeMapKeys(): string[] {
		return this._tasksMap.keys;
	}

	public GetTaskByTypes() {
		let tabs: string[] = this._tasksMap.keys.filter((key: string) => {
			return this.GetTasksByTypeMap(+key).task_list.length > 0;
		});

		return tabs

	}

	public GetLevelMap(lv: number): IS2CFestivalBasicInfoRewaed {
		return this._levelMap.get(lv);
	}

	public SetLevelMap(data: IS2CFestivalBasicInfoRewaed): void {
		this._levelMap.set(data.lv, data);
	}

	public GetLevelMapValues(): IS2CFestivalBasicInfoRewaed[] {
		return this._levelMap.values;
	}

	public GetLevelMapKeys(lv: number): string[] {
		return this._levelMap.keys;
	}

	/**
	 * 是否首次查看祭典
	 */
	public GetFestivalFirstCheck() {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		let mainVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
		return Boolean(Laya.LocalStorage.getJSON(`festivalTips_${mainVo.role_id}_${info.uid}_${info.act_id}`)) || info.exp > 0;
	}


	public SetFestivalFirstCheck() {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		let mainVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
		Laya.LocalStorage.setJSON(`festivalTips_${mainVo.role_id}_${info.uid}_${info.act_id}`, true);
	}


	/**
	 * 获取入口开启状态
	 */
	public GetEntranceOpenState() {
		return this._festivalBasicInfo?.uid > 0;
	}

	/**
	 * 初始化配置
	 */
	public async InitConfig() {
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_fiesta_task',
			false,
			undefined,
			(obj) => {
				this._confFiestaTask = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_fiesta_task', false);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_fiesta_lv_exp',
			false,
			undefined,
			(obj) => {
				this._confFiestaLvExp = obj;
				ResManager.GetInstance().DestoryGameConfig(
					this,
					'config_fiesta_lv_exp',
					false
				);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_fiesta_kv',
			false,
			undefined,
			(obj) => {
				this._confFiestaKv = obj;
				ResManager.GetInstance().DestoryGameConfig(
					this,
					'config_fiesta_kv',
					false
				);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_fiesta_act',
			false,
			undefined,
			(obj) => {
				this._confFiestaAct = obj;
				ResManager.GetInstance().DestoryGameConfig(
					this,
					'config_fiesta_act',
					false
				);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'ClientConfigFiestaITaskTab',
			true,
			undefined,
			(obj) => {
				this._confFiestaTaskTab = obj;
				ResManager.GetInstance().DestoryGameConfig(
					this,
					'ClientConfigFiestaITaskTab'
				);
			}
		);
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_goods_effect',
			false,
			undefined,
			(obj) => {
				this.confGoodsEffect = obj;
				ResManager.GetInstance().DestoryGameConfig(
					this,
					'config_goods_effect', false
				);
			}
		);
	}

	/**
	 * 获取任务类型名字
	 * @param type 
	 * @returns 
	 */
	public GetTaskName(type: string): string {
		return this._confFiestaTaskTab && this._confFiestaTaskTab[type];
	}

	/**
	 * 获取任务单条数据
	 */
	public GetSingleConfFiestaTask(taskId: number): ICConfFiestaTask {
		return this._confFiestaTask && this._confFiestaTask[taskId.toString()];
	}

	/**
	 * 该祭典是否购买
	 */
	public GetFestivalIsBuy() {
		if (this._festivalBasicInfo) {
			return this._festivalBasicInfo.type > 0
		}

		return false
	}

	/**
	 * 判断该类型的祭典礼包是否为直购
	 * @param type 
	 * @returns 
	 */
	public GetTypeFestivalDirectPurchase(type: string): boolean {
		if (!this._festivalBasicInfo) {
			return
		}
		let conf = this._confFiestaAct[this._festivalBasicInfo.uid.toString()];
		let content = ErlangParser.GetInstance().parse(conf[type]);
		return content[0][0] === 'cost1';
	}

	/**
	 * 获取指定祭典礼包配置项
	 */
	public GetTypeFestivalTypeConf(type: string): any[] {
		if (!this._festivalBasicInfo) {
			return
		}
		let conf = this._confFiestaAct[this._festivalBasicInfo.uid.toString()];
		let content = ErlangParser.GetInstance().parse(conf[type]);
		return content[0][1];
	}

	/**
	 * 获取祭典奖励列表配置
	 */
	public GetFestivalAwardsConfs(id: number, actId: number) {
		let conf = this._confFiestaLvExp;
		let confs: ICConfFiestaLvExp[] = [];
		for (const iterator in conf) {
			if (conf.hasOwnProperty(iterator)) {
				let ref: ICConfFiestaLvExp = conf[iterator];
				let reward = ErlangParser.GetInstance().parse(ref.reward);
				let premiumReward = ErlangParser.GetInstance().parse(ref.premium_reward);
				if (id == ref.id && actId == ref.act_id && (reward.length > 0 || premiumReward.length > 0)) {
					confs.push(ref)
				}
			}
		}

		return confs;

	}

	/**
	 * 获取祭典奖励指定等级配置
	 * @returns 
	 */
	public GetFestivalAwardsConf(lv: number, id: number, actId: number) {
		let conf = this._confFiestaLvExp;
		for (const iterator in conf) {
			if (conf.hasOwnProperty(iterator)) {
				let ref: ICConfFiestaLvExp = conf[iterator];
				if (ref.lv == lv && ref.id == id && ref.act_id == actId) {
					return ref
				}
			}
		}

		return null;
	}


	/**
	 * 获取到指定等级的所有经验
	 */
	public GetFestivalLevelToTalExp(lv: number, id: number, actId: number) {
		let totalExp: number = 0;
		let conf = this._confFiestaLvExp;
		for (const iterator in conf) {
			if (conf.hasOwnProperty(iterator)) {
				let ref: ICConfFiestaLvExp = conf[iterator];
				if (ref.lv == lv && ref.id == id && ref.act_id == actId) {
					totalExp += ref.exp
				}
			}
		}

		return totalExp;
	}

	/**
	 * 获取当前等级对应的索引
	 */
	public GetFetivalCurLevelByIndex() {
		if (!this._festivalBasicInfo) {
			return;
		}
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		let confs: ICConfFiestaLvExp[] = this.GetFestivalAwardsConfs(info.uid, info.act_id);
		if (info.lv == 0) {
			return -1;
		}

		if (info.lv == confs[confs.length - 1].lv) {
			return confs.length - 1;
		}

		let index: number = confs.findIndex((value: ICConfFiestaLvExp) => {
			return value.lv === info.lv
		});
		let lv: number = info.lv;
		if (index == -1) {
			let lvIndex: number = -1;
			while (true) {
				lv -= 1;
				lvIndex = confs.findIndex((value: ICConfFiestaLvExp) => {
					return value.lv === lv
				});
				if (lvIndex > 0) {
					return lvIndex;
				}
			}
		}

		return index;

	}

	/**
	 * 获取下个高阶奖励
	 * @param lv 当前滚动可见的最高等级
	 */
	public GetFestivalOrderReward(lv: number) {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		let confs: ICConfFiestaLvExp[] = this.GetFestivalAwardsConfs(info.uid, info.act_id);
		let conf: ICConfFiestaLvExp = null;
		for (const iterator of confs) {
			if (iterator.lv > lv && iterator.is_key_stage) {
				conf = iterator;
				break;
			}
		}

		return conf;
	}


	/**
	 * 获得祭典当前等级到下一等级需要的印花数量
	 */
	public GetFetivalCurLvToNextLvCostExpNum() {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		let nextTotal: number = this.GetFestivalLevelToTalExp(info.lv + 1, info.uid, info.act_id);
		let exp: number = nextTotal - info.exp; // 距离下一集还需要的经验
		let sca: number = JSON.parse(this.confGoodsEffect[this.goosId.toString()]['effect_list'])[0][1];
		// 所需要的印花数量
		let num = Math.ceil(exp / sca);
		return num
	}

	/**
	 * 获取功能描述类型
	 */
	public GetFestivalInstructionType(): EnumFestivalInstructionType {
		if (this._festivalBasicInfo) {
			return this._festivalBasicInfo.act_id > 1 ? EnumFestivalInstructionType.eThirty : EnumFestivalInstructionType.eSeven;
		}
		return null;
	}

	/**
	 * 获取当前等级开通高级祭典可以领取的奖励
	 */
	public GetFestivalOrderRewards(type: EnumFestivalTypeName) {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		if(!this._confFiestaAct) return
		let conf = this._confFiestaAct[this._festivalBasicInfo.uid.toString()];
		let exp: number = ErlangParser.GetInstance().parse(conf[type])[1][1][0][1];
		let totalExp: number = Number(info.exp) + Number(exp);

		let confs: ICConfFiestaLvExp[] = this.GetFestivalAwardsConfs(info.uid, info.act_id)
		let lv: number = confs[confs.length - 1].lv;
		for (const iterator in this._confFiestaLvExp) {
			if (this._confFiestaLvExp.hasOwnProperty(iterator)) {
				let ref: ICConfFiestaLvExp = this._confFiestaLvExp[iterator];
				if (ref.id == info.uid && ref.act_id == info.act_id && totalExp < ref.exp) {
					lv = ref.lv - 1;
					break
				}
			}
		}

		let map: TMap<number, any> = new TMap<number, any>();

		for (const iterator of confs) {
			let reward: any = ErlangParser.GetInstance().parse(iterator.premium_reward)[0];
			if (iterator.lv <= lv) {
				let item: any = map.get(reward[1]);
				if (item) {
					let num = Number(item[2]) + Number(reward[2]);
					item[2] = num;
					map.set(reward[1], item)
				} else {
					map.set(reward[1], reward)
				}
			}
		}

		return map.values;

	}

	/**
	 * 获取所有高级奖励
	 */
	public GetAllPremiumReward() {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		let confs: ICConfFiestaLvExp[] = this.GetFestivalAwardsConfs(info.uid, info.act_id);
		let rewards: any[] = [];
		for (const iterator of confs) {
			let reward: any = ErlangParser.GetInstance().parse(iterator.premium_reward)[0];
			rewards.push(reward);
		}

		let map: TMap<number, any> = new TMap<number, any>();

		for (const iterator of rewards) {
			let item: any = map.get(iterator[1]);
			if (item) {
				let num = Number(item[2]) + Number(iterator[2]);
				item[2] = num;
				map.set(iterator[1], item)
			} else {
				map.set(iterator[1], iterator)
			}

		}

		return map.values;
	}



	/**
	 * 获取指定页签红点
	 * @param type
	 */
	public GetTaskTabRedDot(type: EnumFestivalTaskTab): boolean {
		let task: IS2CFestivalTaskType = this._tasksMap.get(type);
		if (task) {
			let bool: boolean = task.task_list.some((data: IS2CFestivalTaskInfo) => {
				return data.status === 1;
			});

			return bool;
		}

		return false;
	}

	/**
	 * 判断任务页签是有都有红点
	 */
	public GetTaskTabEveryRedDotAll() {
		if (this._tasksMap?.keys) {
			let bool: boolean = this._tasksMap.keys.every((key: string) => {
				return this.GetTaskTabRedDot(+key);
			});

			return bool;
		}

		return false;
	}

	/**
	 * 任务页签总红点
	 */
	public GetTaskTabRedDotAll(): boolean {
		if (this._tasksMap?.keys) {
			let bool: boolean = this._tasksMap.keys.some((key: string) => {
				return this.GetTaskTabRedDot(+key);
			});

			return bool;
		}

		return false;
	}


	/**
	 * 获取祭典奖励红点
	 */
	public GetFestivalAwardRedDot() {
		let info: IS2CFestivalBasicInfo = this._festivalBasicInfo;
		if (this._levelMap?.values && info) {
			let levels: IS2CFestivalBasicInfoRewaed[] = this._levelMap.values.filter((levelInfo: IS2CFestivalBasicInfoRewaed) => {
				let conf: ICConfFiestaLvExp = this.confFiestaLvExp[`${info.uid}@${levelInfo.lv}`];
				if(conf){
					let reward = ErlangParser.GetInstance().parse(conf.reward);
					let premiumReward = ErlangParser.GetInstance().parse(conf.premium_reward);
					return (reward.length > 0 || premiumReward.length > 0);
				}
				return false
			});

			let bool: boolean = levels.some((value: IS2CFestivalBasicInfoRewaed) => {
				return (value.status1 == 1 || value.status2 == 1);
			});
			return bool;
		}

		return false;
	}


	/**
	 * 祭典入口红点
	 */
	public GetFestivalEntranceReDot() {
		return this.GetTaskTabRedDotAll() || this.GetFestivalAwardRedDot() || this.loginRedDot;
	}

	/**
	 * 入口红点更新
	 */
	public UpdateEntranceRedDot() {
		this.loginRedDot = false;
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, FestivalModel.ICON_TYPE, this.GetFestivalEntranceReDot())
	}


}

window['FestivalModel'] = FestivalModel;
