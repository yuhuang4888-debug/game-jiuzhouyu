import { BaseWindowComponent } from '../common/BaseWindowComponent';
import { OutWardBaseModel } from '../commonModel/OutWardBaseModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { FestivalModel, FestivalModelEvent } from '../commonModel/FestivalModel';
import "../festival/FestivalTaskView"
import "../festival/FestivalLevelAwardView"
import "../festival/FestivalCommodityView"

export enum EnumFestivalTabType {
	/**任务 */
	eTask,
	/**奖励 */
	eAward,
	/**祭典 */
	eFestival,
}

export class FestivalBaseView extends BaseWindowComponent {
	static _layout_file: string = 'FestivalBaseView';

	private get FestivalModel() {
		return FestivalModel.GetInstance();
	}

	public constructor() {
		super();
		this.dependent_res = ['festival'];
		// 页签名字
		this.tabStrList = [
			{ label: '任务' },
			{ label: '奖励' },
			{ label: '进阶祭典' },
		];
		// 页签对应的view
		this.viewClassList = [
			'FestivalTaskView',
			'FestivalLevelAwardView',
			'FestivalCommodityView',
		];
		// 默认的标题资源
		this.titleStr = 'festival.ui_title_jd';
		// 页签对应的背景图
		this.bg_list = ['ui_di_jd01.jpg', 'ui_db_jd018.jpg', 'ui_db_jd04.jpg'];
		// 货币显示
		this.money_list = [2, 1, 0];
		// this.titleList = [
		// 	'role.title_name',
		// 	'pet.ui_yuyi',
		// 	'pet.ui_yushou',
		// 	'pet.ui_shenbin',
		// ];

		// 功能描述
		this.instruction_list = [
			this.FestivalModel.GetFestivalInstructionType(),
			this.FestivalModel.GetFestivalInstructionType(),
			this.FestivalModel.GetFestivalInstructionType(),
		];

		// 加载回调
		this.window_load_back = () => {
			this.UpdateTaskTabRedDot();
			this.UpdateAwardTabRedDot();

		}
		// 打开回调
		this.window_open_back = () => {

		};
	}


	/**
	 * 更新任务页签红点
	 */
	private UpdateTaskTabRedDot() {
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, FestivalBaseView._layout_file, EnumFestivalTabType.eTask, this.FestivalModel.GetTaskTabRedDotAll());
		this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_UPDATE_TASK_ALL, () => {
			this.FestivalModel.UpdateEntranceRedDot();
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, FestivalBaseView._layout_file, EnumFestivalTabType.eTask, this.FestivalModel.GetTaskTabRedDotAll());
		});
	}

	/**
	 * 更新奖励页签红点
	 */
	private UpdateAwardTabRedDot() {
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, FestivalBaseView._layout_file, EnumFestivalTabType.eAward, this.FestivalModel.GetFestivalAwardRedDot());
		this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_BASIC_INIT, () => {
			this.FestivalModel.UpdateEntranceRedDot();
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, FestivalBaseView._layout_file, EnumFestivalTabType.eAward, this.FestivalModel.GetFestivalAwardRedDot());
		});
	}



	public Close() {
		super.Close();
	}

	public SelectView(index?) {
		super.SelectView(index);
	}


	public Open(...new_args) {
		let parms = new_args;
		this.SetDefaultIndex(this.FestivalModel.GetTaskTabRedDotAll() ? 0 : parms[0]);
		if (parms[0] && parms[1] && parms[0] == 3) {
			this.SetIndexParameter(parms[0], parms[1]);
		}
		if (this.HasOpen()) {
			this.LocalSetSelectIndex(parms[0]);
		} else {
			super.Open();
		}

	}
}

window['FestivalBaseView'] = FestivalBaseView;
