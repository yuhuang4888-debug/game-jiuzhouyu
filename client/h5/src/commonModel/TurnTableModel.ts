import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { table } from "../common/table";
import { EventDispatcher } from "../util/EventDispatcher";
import { CustomActivityDefine } from "./CustomActivityDefine";
import { CustomActivityModel } from "./CustomActivityModel";

export class TurnTableModelEvent {
	static TURN_BIG_DOWN: string = "TurnTableModelEvent_TURN_BIG_DOWN";
	static START_RETURN: string = "TurnTableModelEvent_START_RETURN";
	static RECORD_RETURN: string = "TurnTableModelEvent_RECORD_RETURN";
	static DATA_RETURN: string = "TurnTableModelEvent_DATA_RETURN"
}
// [ts2lua]window下标访问可能不正确

export class TurnTableModel extends EventDispatcher {
	_recordData
	_rewardDic
	_turnTableViewData
	convertTime
	getRecordData
	getTurnTableData
	recordData
	showReward
	startReturnData
	success_view
	turnTableViewData
	fly_list=[]

	private static _instance: TurnTableModel;
	public static GetInstance() {
		if (!TurnTableModel._instance) {
			TurnTableModel._instance = new TurnTableModel()
		}
		return TurnTableModel._instance
	}

	public constructor() {
		super()
		this._turnTableViewData = [];
		this._recordData = [];
		let local_TurnTableModelEvent = TurnTableModelEvent;
		let custom_activity_model = CustomActivityModel.GetInstance();
		this.turnTableViewData = (data?) => {
			// [ts2lua]this._turnTableViewData下标访问可能不正确
			this._turnTableViewData[data.base_type + "_" + data.sub_type] = data
			this.Fire(local_TurnTableModelEvent.DATA_RETURN);
		}

		this.getTurnTableData = (base_type?, sub_type?) => {
			// [ts2lua]this._turnTableViewData下标访问可能不正确
			return this._turnTableViewData[base_type + "_" + sub_type];
		}

		this.startReturnData = (data?) => {
			let info = this.getTurnTableData(data.base_type, data.sub_type);
			if (info) {
				//勾玉飘字
				this.fly_list=[]
				table.insert(this.fly_list,{
					0:0,
					1:data.goods_id,
					2:data.goods_num*data.n_times
				})
				this.fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(this.fly_list)
				//其他
				info.ticket_num = data.ticket_num;
				let bigIndex = info.reward_list.findIndex((value: any) => {
					return data.goods_num == value.goods_num
				});

				info.n_times_list.sort((a, b) => {
					return a.n_times - b.n_times;
				})

				let smallIndex = info.n_times_list.findIndex((value: any) => {
					return data.n_times == value.n_times;
				});
				if (!this._rewardDic) {
					this._rewardDic = [];
				}
				// [ts2lua]this._rewardDic下标访问可能不正确
				this._rewardDic["reward"] = [2, data.goods_id, data.goods_num];
				// [ts2lua]this._rewardDic下标访问可能不正确
				this._rewardDic["point"] = data.n_times;
				// [ts2lua]info下标访问可能不正确
				info["total_left_tickets"] = data.total_left_tickets;
				custom_activity_model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33132, data.base_type, data.sub_type);
				custom_activity_model.SetActRedDot(data.base_type, data.sub_type);
				this.Fire(local_TurnTableModelEvent.START_RETURN, bigIndex, smallIndex);
			}
			custom_activity_model.RefreshIconRed(data.base_type, data.sub_type)
		}


		this.showReward = () => {
			if (this._rewardDic) {
				// [ts2lua]this._rewardDic下标访问可能不正确
				let list = [this._rewardDic["reward"]];
				let nums: number = this._rewardDic["point"];
				let rawards: any[] = [];
				let cell: any = list[0];
				for (let i = 0; i < nums; i++) {
					rawards.push(JSON.parse(JSON.stringify(cell)));
					rawards[i]['double'] = i > 0;
				}
				// [ts2lua]this._rewardDic下标访问可能不正确
				this.success_view = new CongratulationObtainView(rawards, 10, null, null, null, null, null, nums)
				this.success_view.Open();
				this._rewardDic = null;
			}
		}

		this.recordData = (data?) => {
			// [ts2lua]this._recordData下标访问可能不正确
			this._recordData[data.base_type + "_" + data.sub_type] = data.list
			this.Fire(local_TurnTableModelEvent.RECORD_RETURN)
		}

		this.getRecordData = (base_type?, sub_type?) => {
			// [ts2lua]this._recordData下标访问可能不正确
			return this._recordData[base_type + "_" + sub_type]
		}

	}
}
window["TurnTableModelEvent"] = TurnTableModelEvent;
window["TurnTableModel"] = TurnTableModel;