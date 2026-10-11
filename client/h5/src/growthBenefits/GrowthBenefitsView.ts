import { BaseItem1 } from "../common/BaseItem1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { EnumGrowWelefareTaskState, GrowthBenefitsModel, GrowthBenefitsModelEvent, IConfGrowWelfareInfo, IGrowWelfareTaskParam } from "../commonModel/GrowthBenefitsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { SYTweenLite } from "../util/SYTweenLite";
import { GrowthBenefitsTabItem } from "./GrowthBenefitsTabItem";
import { GrowthBenefitTaskItem } from "./GrowthBenefitTaskItem";

export class GrowthBenefitsView extends BaseItem1 {
    static _layout_file: string = 'GrowthBenefitsView';
    private conf: any;
    private loop_mgr1: LoopScrowViewMgr;
    private loop_mgr2: LoopScrowViewMgr;

    private get GrowthBenefitsModel() {
        return GrowthBenefitsModel.GetInstance();
    }

    // 默认页签选中索引
    private defTabIndex: number = 0;
    // 默认创角天数
    private defDay: number = 1;

    private redTweenId: number = 0;

    private tabs: { day: number, red: boolean }[] = [];

    public constructor(parent?: any) {
        super(parent);

        this.base_file = 'growthBenefits';
        this.layout_file = 'GrowthBenefitsView';
        this.layer_value = Enum_UILayer.Activity;


        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };

        // this.Load();

    }

    private LoadSuccess() {
        this.SetDefParam()
        this.RenderTabList();
        this.RenderTaskList();
        this.taskList.scrollBar.changeHandler = new Laya.Handler(this, this.OnChangeHandler);
        this.tabList.scrollBar.on(Laya.Event.CHANGE, this, this.RefreshRed);
        if (this.redImg) {
            this.redTweenId = SYTweenLite.to(this, this.redImg, SYTweenLite.UiAnimationType.SCALE, { x: 0.8, y: 0.8 }, 1, null, SYTweenFunc.PINGPONG, true)
        }
        this.OnChangeHandler(this.taskList.scrollBar.value);
        this.RefreshRed();
    }

    private OnChangeHandler(value: number) {
        this.arrowImg.visible = value < this.taskList.scrollBar.max;
    }


    public InitEvent() {
        // 选择页签回调
        this.BindEvent(this.GrowthBenefitsModel, GrowthBenefitsModelEvent.TAB_SELECT, (data: any, index: number) => {
            this.defTabIndex = index;
            this.defDay = data.day;
            this.loop_mgr1.SetSelectIndex(this.defTabIndex);
            this.RenderTaskList();
        });

        // 任务更新
        this.BindEvent(this.GrowthBenefitsModel, GrowthBenefitsModelEvent.UPDATE_TASK, () => {
            // 判断本页签是否还存在红点
            if (!this.GrowthBenefitsModel.GetDayRedDotState(this.defDay)) {
                this.SetDefParam();
            }
            this.RenderTabList();
            this.RenderTaskList();
            this.RefreshRed();
        });


    }

    private RenderTabList() {
        let tabs: number[] = this.GrowthBenefitsModel.GetTabs();
        let list: { day: number, red: boolean }[] = [];
        for (const iterator of tabs) {
            list.push({ day: iterator, red: this.GrowthBenefitsModel.GetDayRedDotState(iterator) })
        }
        this.tabs = list;
        if (!this.loop_mgr1) {
            this.loop_mgr1 = new LoopScrowViewMgr();
            this.loop_mgr1.SetData(
                this.tabList,
                GrowthBenefitsTabItem,
                list,
                LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr1.replaceAll(list);
        }

        this.loop_mgr1.SetSelectIndex(this.defTabIndex);
        this.tabList.tweenTo(this.defTabIndex);

    }

    private RenderTaskList() {
        // 排序顺序按照 可领取 前往 已领取顺序来
        let order = { 0: 2, 1: 1, 2: 3 };
        let tasks: IConfGrowWelfareInfo[] = this.GrowthBenefitsModel.GetTasksByDay(this.defDay);

        tasks.sort((a: IConfGrowWelfareInfo, b: IConfGrowWelfareInfo) => {
            let aTask: IGrowWelfareTaskParam = this.GrowthBenefitsModel.GetTaskStateMap(a.task_id);
            let bTask: IGrowWelfareTaskParam = this.GrowthBenefitsModel.GetTaskStateMap(b.task_id);

            return order[aTask?.status || 0] - order[bTask?.status || 0];
        });

        let index: number = tasks.findIndex((data: IConfGrowWelfareInfo) => {
            let task: IGrowWelfareTaskParam = this.GrowthBenefitsModel.GetTaskStateMap(data.task_id);
            return task?.status == EnumGrowWelefareTaskState.eAvailable;
        })


        if (!this.loop_mgr2) {
            this.loop_mgr2 = new LoopScrowViewMgr();
            this.loop_mgr2.SetData(
                this.taskList,
                GrowthBenefitTaskItem,
                tasks,
                LoopScrCon.Vertical
            );
        } else {
            this.loop_mgr2.replaceAll(tasks);
        }
        if (index >= 0) {
            this.taskList.tweenTo(index);
        }

    }

    private SetDefParam() {
        let tabs: number[] = this.GrowthBenefitsModel.GetTabs();
        for (let i = 0; i < tabs.length; i++) {
            const day: number = tabs[i];
            if (this.GrowthBenefitsModel.GetDayRedDotState(day)) {
                this.defDay = day;
                this.defTabIndex = i;
                return;
            }
        }

        let curDay: number = RoleManager.GetInstance().GetRoleCreateDay() + 1;
        for (let j = 0; j < tabs.length; j++) {
            const day: number = tabs[j];
            if (day <= curDay && !this.GrowthBenefitsModel.GetTaskDayIsAllReceive(day)) {
                this.defDay = day;
                this.defTabIndex = j;
                return;
            }
        }


    }


    private RefreshRed() {
        if (!this.use_delete_method) {
            let bool = false
            if (this.tabList && this.tabList.scrollBar) {
                let value = this.tabList.scrollBar.value;
                let item_width = 149;
                let length: number = 0;
                for (let index = 0; index < this.tabs.length; index++) {
                    const tab: { day: number, red: boolean } = this.tabs[index];
                    if (tab && tab.red) {
                        length = item_width * (Number(index) + 1) - this.tabList.width - 20 // 20 计算向左的偏移量
                        if (length > value) {
                            bool = true;
                            break;
                        }
                    }
                }
            }
            if (this.redImg)
                this.redImg.visible = bool
        }
    }


    private LocalDeleteMe() {
        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }
        if (this.loop_mgr2) {
            this.loop_mgr2.DeleteMe();
            this.loop_mgr2 = null;
        }
        if (this.tabList) {
            this.tabList.scrollBar.off(Laya.Event.CHANGE, this, this.RefreshRed);
        }
        if (this.redTweenId) {
            SYTweenLite.Stop(this.redTweenId)
        }
        super.DeleteMe();
    }

    public DeleteMe() {
        this.LocalDeleteMe();

    }







    tabList: Laya.List
    taskList: Laya.List
    redImg: Laya.Image
    arrowImg: Laya.Image
    public GetComponents() {
        [
            this.tabList,
            this.taskList,
            this.redImg,
            this.arrowImg,
        ]
            = this.GetChildrenByNames([

                "tabList",
                "taskList",
                "redImg",
                "arrowImg",
            ])
    }
}
window["GrowthBenefitsView"] = GrowthBenefitsView