import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { EnumGrowthBenefitsProtocol } from '../commonController/GrowthBenefitsController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';
import { ActivityIconManager } from './ActivityIconManager';
import { GrowthForceModel } from './GrowthForceModel';
import { RoleManager } from './RoleManager';
import { Config } from '../common/Config';


export interface IConfGrowWelfareInfo {
    /**任务id */
    task_id: number,
    condition: string,
    reward: string;
    desc: string,
    open_day: number,
    jump_id: number
}

export interface IGrowWelfareTaskParam {
    /**任务id */
    task_id: number,
    /**任务进度 */
    process: number,
    /**任务状态  0不可领取， 1可领取， 2已领取*/
    status: EnumGrowWelefareTaskState
}

export enum EnumGrowWelefareTaskState {
    /**不可领取 */
    eNotAvailable,
    /**可领取 */
    eAvailable,
    /**已领取 */
    eReceived
}


/**
 * 成长福利事件类型类
 */
export class GrowthBenefitsModelEvent {
    static _cname = 'GrowthBenefitsModelEvent';
    /**页签选中 */
    public static TAB_SELECT: string = GrowthBenefitsModelEvent._cname + '_' + 'TAB_SELECT';
    /**请求数据 */
    public static REQUEST_PROTO: string = GrowthBenefitsModelEvent._cname + '_' + 'REQUEST_PROTO';
    /**任务更新 */
    public static UPDATE_TASK: string = GrowthBenefitsModelEvent._cname + '_' + 'UPDATE_TASK';
}



export class GrowthBenefitsModel extends EventDispatcher {
    private static _instance: GrowthBenefitsModel;

    private taskMap: TMap<number, IConfGrowWelfareInfo>;
    private taskStateMap: TMap<number, IGrowWelfareTaskParam>;
    private tabs: number[] = [];


    private confGrowWelfareInfo: any;
    private confWelfare: any;


    public constructor() {
        super();
        this.taskMap = new TMap<number, IConfGrowWelfareInfo>();
        this.taskStateMap = new TMap<number, IGrowWelfareTaskParam>();
    }



    public static GetInstance() {
        if (!GrowthBenefitsModel._instance) {
            GrowthBenefitsModel._instance = new GrowthBenefitsModel();
        }
        return GrowthBenefitsModel._instance;
    }

    public GetTaskMapClear() {
        this.taskMap.clear();
    }

    public GetTaskStateMapClear() {
        this.taskStateMap.clear();
    }

    public GetTaskMap(taskId: number): IConfGrowWelfareInfo {
        return this.taskMap.get(taskId);
    }

    public SetTaskMap(taskId: number, data: IConfGrowWelfareInfo): void {
        this.taskMap.set(taskId, data);
    }

    public GetTaskMapAll(): IConfGrowWelfareInfo[] {
        return this.taskMap.values;
    }


    public GetTaskStateMap(taskId: number): IGrowWelfareTaskParam {
        return this.taskStateMap.get(taskId);
    }

    public SetTaskStateMap(taskId: number, data: IGrowWelfareTaskParam): void {
        this.taskStateMap.set(taskId, data);
    }

    public GetTaskStateMapAll(): IGrowWelfareTaskParam[] {
        return this.taskStateMap.values;
    }

    public GetTabs(): number[] {
        return this.tabs;
    }

    /**
     * 根据创角天数获取对应任务数据
     * @param day 创角天数
     */
    public GetTasksByDay(day: number): IConfGrowWelfareInfo[] {
        let taskAll: IConfGrowWelfareInfo[] = this.GetTaskMapAll();
        let tasks: IConfGrowWelfareInfo[] = [];
        if (taskAll?.length > 0) {
            for (const iterator of taskAll) {
                if (iterator.open_day == day) {
                    tasks.push(iterator);
                }
            }
        }

        return tasks;
    }

    /**
     * 判断该天数是否已经领取完
     * @param day 
     */
    public GetTaskDayIsAllReceive(day: number) {
        let tasks: IConfGrowWelfareInfo[] = this.GetTasksByDay(day);
        for (const iterator of tasks) {
            let task: IGrowWelfareTaskParam = this.GetTaskStateMap(iterator.task_id);
            if (!task) {
                return false;
            }
            if (task?.status != EnumGrowWelefareTaskState.eReceived) {
                return false
            }
        }

        return true;

    }


    /**
     * 获取任务是否全部领取完
     */
    public GetTaskIsAllReceive(): boolean {
        for (const iterator of this.GetTaskMapAll()) {
            let task: IGrowWelfareTaskParam = this.GetTaskStateMap(iterator.task_id);
            if (!task) {
                return false;
            }
            if (task?.status != EnumGrowWelefareTaskState.eReceived) {
                return false
            }
        }

        return true;

    }

    /**
     * 获取指定天数的红点状态
     * @param day 天数
     */
    public GetDayRedDotState(day: number) {
        let curDay: number = RoleManager.GetInstance().GetRoleCreateDay() + 1;

        if (curDay < day) {
            return false;
        }

        let bool: boolean = this.taskStateMap.values.some((data: IGrowWelfareTaskParam) => {
            let task: IConfGrowWelfareInfo = this.GetTaskMap(data.task_id);
            if (task?.open_day == day) {
                return data.status == EnumGrowWelefareTaskState.eAvailable;
            }
        });

        return bool;

    }

    /**
     * 获取成长福利总红点
     */
    public GetDayRedDotStateAll() {
        let tabs: number[] = this.GetTabs();
        
        let bool: boolean = tabs.some((day: number) => {
            return this.GetDayRedDotState(day)
        });

        return bool;
    }




    public async InitConfig() {
        await ResManager.GetInstance().LoadGameConfig(
            this,
            'config_grow_welfare_info',
            false,
            undefined,
            (obj) => {
                this.confGrowWelfareInfo = obj;
                ResManager.GetInstance().DestoryGameConfig(
                    this,
                    'config_grow_welfare_info', false
                );
            }
        );
        this.InitTaskMap();
    }

    private InitTaskMap() {
        let conf = this.confGrowWelfareInfo;
        for (const key in conf) {
            if (Object.prototype.hasOwnProperty.call(conf, key)) {
                const element: IConfGrowWelfareInfo = conf[key];
                this.taskMap.set(element.task_id, element);
                if (this.tabs.indexOf(+element.open_day) == -1) {
                    this.tabs.push(+element.open_day);
                }
            }
        }
    }


    public GetEntranceOpenState(): boolean {
        let info = Config.PRELOAD_SERVER_CONFIG["config_welfare_cfg"]['8'];

        if (info && RoleManager.GetInstance().GetMainRoleVo().level >= Number(info?.val) && !this.GetTaskIsAllReceive()) {
            return true;
        }

        if (GrowthForceModel.GetInstance().CheckFightWelfareOpen() && !GrowthForceModel.GetInstance().IsFightWelfareGotAll()) {
            return true
        }

        return false;

    }

    public refreshIcon() {
        if (this.GetEntranceOpenState()) {
            ActivityIconManager.GetInstance().addIcon(
                EnumGrowthBenefitsProtocol.eProtocol41720,
                null,
                null
            );
        } else {
            ActivityIconManager.GetInstance().deleteIcon(EnumGrowthBenefitsProtocol.eProtocol41720);
        }
    }


    public RefreshIconRed() {
        GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, EnumGrowthBenefitsProtocol.eProtocol41720)
    }

}

window['GrowthBenefitsModel'] = GrowthBenefitsModel;
