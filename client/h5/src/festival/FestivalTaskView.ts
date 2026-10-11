
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { EnumFestivalProtocol } from '../commonController/FestivalController';
import { FestivalModel, FestivalModelEvent, EnumFestivalTaskTab, IS2CFestivalTaskType, IS2CFestivalTaskInfo, ICConfFiestaTask, ICConfFiestaLvExp, IS2CFestivalBasicInfo } from '../commonModel/FestivalModel';
import { ComActTimerView } from '../customActivity/ComActTimerView';
import { GlobalTimerQuest, Util } from '../util/Util';
import { FestivalTaskListItem } from './FestivalTaskListItem';
import { FestivalTaskTabListItem } from './FestivalTaskTabListItem';
import { BaseItem1 } from './../common/BaseItem1';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { Message } from '../sysInfo/SysInfoController';

export class FestivalTaskView extends BaseItem1 {
	public static readonly _layout_file: string = 'FestivalTaskView';
	private getAllBtn: Laya.Box;
	private tabList: Laya.List;
	private taskList: Laya.List;
	private timeLab: Laya.Label;
	private redImg: Laya.Image;

	private barImg: Laya.Image
    private barLab: Laya.Label
    private levelLab: Laya.Label
	private upBtn: Laya.Box

	private time_id: any;
	private conf: any;
	private loop_mgr: LoopScrowViewMgr;
	private loop_mgr1: LoopScrowViewMgr;
	private defSelectTabType: EnumFestivalTaskTab;
	private timer: ComActTimerView;

	private get FestivalModel() {
		return FestivalModel.GetInstance();
	}

	public constructor(parent?: any) {
		super(parent);

		this.base_file = 'festival';
		this.layout_file = 'FestivalTaskView';
		this.layer_value = Enum_UILayer.Activity;

		this.load_callback = () => {
			this.LoadSuccess();
			this.InitEvent();
		};
	}

	private LoadSuccess() {
		this.levelLab.fontSize = 32
        ResManager.GetInstance().LoadFont(this, "festival_level2", this.levelLab, 32);
		this.RenderTab();
		this.RenderTaskList();
		this.StartTimer();
		this.RenderView();
	}

	/**
	 * 渲染页签
	 */
	private RenderTab() {
		let tabs: string[] = this.FestivalModel.GetTaskByTypes();

		this.defSelectTabType = +tabs[0];

		// 默认选择有红点的页签
		for (const iterator of tabs) {
			if (this.FestivalModel.GetTaskTabRedDot(+iterator)) {
				this.defSelectTabType = +iterator;
				break;
			}
		}

		if (!this.loop_mgr1) {
			this.loop_mgr1 = new LoopScrowViewMgr();
			this.loop_mgr1.SetData(
				this.tabList,
				FestivalTaskTabListItem,
				tabs,
				LoopScrCon.Horizontal,
			);
		} else {
			this.loop_mgr1.replaceAll(tabs);
		}

		let len: number = tabs.length > 3 ? 3 : tabs.length;
		let spaceNum: number = len > 1 ? len - 1 : 0;
		let w: number = len * 150 + spaceNum * this.tabList.spaceX;
		this.tabList.x = Math.floor((720 - w) / 2);
		this.SetSelectIndex(this.defSelectTabType);
	}


	private SetSelectIndex(type: number) {
		let tabs: string[] = this.FestivalModel.GetTaskByTypes();
		let defIndex: number = tabs.findIndex((key: string) => {
			return type == Number(key);
		})
		this.loop_mgr1.SetSelectIndex(defIndex);
	}

	/**
	 * 渲染任务列表
	 */
	private RenderTaskList() {
		if (!this.defSelectTabType) {
			return
		}
		let task: IS2CFestivalTaskType = this.FestivalModel.GetTasksByTypeMap(this.defSelectTabType);
		// 按照任务id排序
		task.task_list.sort((a: IS2CFestivalTaskInfo, b: IS2CFestivalTaskInfo) => {
			let confA: ICConfFiestaTask = this.FestivalModel.GetSingleConfFiestaTask(a.task_id);
			let confB: ICConfFiestaTask = this.FestivalModel.GetSingleConfFiestaTask(b.task_id);
			return confA.sort - confB.sort;
		});

		// 排序顺序
		let sortKey = { 0: 2, 1: 1, 2: 3 };

		task.task_list.sort((a: IS2CFestivalTaskInfo, b: IS2CFestivalTaskInfo) => {
			return sortKey[a.status] - sortKey[b.status];
		});

		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr();
			this.loop_mgr.SetData(
				this.taskList,
				FestivalTaskListItem,
				task.task_list,
				LoopScrCon.Vertical
			);
		} else {
			this.loop_mgr.replaceAll(task.task_list);
		}


		this.redImg.visible = this.FestivalModel.GetTaskTabRedDotAll();
		this.getAllBtn.gray = !this.FestivalModel.GetTaskTabRedDotAll();
		this.getAllBtn.mouseEnabled = this.FestivalModel.GetTaskTabRedDotAll();
	}

	private RenderView() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confs: ICConfFiestaLvExp[] = this.FestivalModel.GetFestivalAwardsConfs(info.uid, info.act_id);
        let lv: number = info.lv == confs[confs.length - 1].lv ? info.lv : info.lv + 1;
        let targetNum: number = this.FestivalModel.GetFestivalLevelToTalExp(lv, info.uid, info.act_id);
        let confCurLvExp: ICConfFiestaLvExp = this.FestivalModel.GetFestivalAwardsConf(lv, info.uid, info.act_id);
        let barW: number = (info.exp / targetNum) * 352;
        this.barImg.width = barW > 352 ? 352 : barW;
        this.levelLab.changeText(`l${info.lv}`);
        this.barLab.changeText(`${confCurLvExp.exp - (targetNum - info.exp)}/${confCurLvExp.exp}`);
    }

	/**
	 * 倒计时
	 */
	public StartTimer() {
		let task: IS2CFestivalTaskType = this.FestivalModel.GetTasksByTypeMap(this.defSelectTabType);
		this.StopTimer();
		let loop_func = () => {
			let left_time = task.refresh_time - TimeUtil.getServerTime()
			if (left_time <= 0) {
				this.StopTimer();
				this.timeLab.text = '已结束';
			} else {
				let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
				this.timeLab.text = time;
			}
		}

		this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
		loop_func();
	}

	public StopTimer() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	/**
	 * 更新页签红点
	 */
	private UpdateTabRedDot() {
		let tabs: string[] = this.FestivalModel.GetTaskByTypes();
		if (!this.loop_mgr1) {
			this.loop_mgr1 = new LoopScrowViewMgr();
			this.loop_mgr1.SetData(
				this.tabList,
				FestivalTaskTabListItem,
				tabs,
				LoopScrCon.Horizontal,
			);
		} else {
			this.loop_mgr1.replaceAll(tabs);
		}
	}


	public InitEvent() {
		// 点击全部领取
		Util.AddClickEvent(
			this.getAllBtn,
			() => {
				this.FestivalModel.Fire(
					FestivalModelEvent.FESTIVAL_REQUEST_PROTO,
					EnumFestivalProtocol.eProtocol19404, 'ch', 0, 0
				);
			},
			this,
			true
		);

		// 选择页签回调
		this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_TASK_TAB_SELECT, (selectType?: number, index?: number) => {
			this.defSelectTabType = selectType;
			this.SetSelectIndex(selectType);
			this.RenderTaskList();
			this.StartTimer();
		});

		// 倒计时结束更新任务回调/领取任务回调
		this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_UPDATE_TASK_ALL, () => {
			// 页面数据更新
			this.StartTimer();
			this.RenderTaskList();

			// 更新红点
			this.UpdateTabRedDot();
		});

		// // 任务数据更新回调
		// this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_TASK_UPDATE, () => {
		// 	// 页面数据更新
		// 	this.StartTimer();
		// 	this.RenderTaskList();
		// });

		// 页签更变
		this.BindEvent(GlobalEventSystem, EventName.CHANGE_SUB_VIEW, (view_name: string) => {
			if (view_name == this.layout_file) {
				this.RenderTab();
				this.StartTimer();
				this.RenderTaskList();
				this.RenderView();
			}
		});

		this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_BASIC_INIT, () => {
            this.RenderView();
        });

		 // 点击升级庆典
		 Util.AddClickEvent(
            this.upBtn,
            () => {
                let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
                let confs: ICConfFiestaLvExp[] = this.FestivalModel.GetFestivalAwardsConfs(info.uid, info.act_id);
                if (info.lv < confs[confs.length - 1].lv) {
                    this.FestivalModel.Fire(
                        FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                        'FestivalUpLevelView',
                    );
                } else {
                    Message.show('已满级');
                }
            },
            this,
            true
        );
	}



	public DeleteMe() {
		if (this.timer) {
			this.timer.DeleteMe();
			this.timer = null
		}
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe();
			this.loop_mgr = null;
		}
		if (this.loop_mgr1) {
			this.loop_mgr1.DeleteMe();
			this.loop_mgr1 = null;
		}

		this.StopTimer();

		super.DeleteMe();
	}

	public GetComponents() {
		[this.tabList, this.taskList, this.getAllBtn, this.timeLab, this.redImg,  this.barImg, this.barLab, this.levelLab, this.upBtn] =
			this.GetChildrenByNames(['tabList', 'taskList', 'getAllBtn', 'timeLab', 'redImg', 'barImg','barLab','levelLab','upBtn']);
	}
}
window['FestivalTaskView'] = FestivalTaskView;
