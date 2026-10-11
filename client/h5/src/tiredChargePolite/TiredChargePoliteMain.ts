import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { IS2CTiredChargePoliteTasksParam, TiredChargePoliteModel, TiredChargePoliteModelEvent, TiredChargePoliteTaskState } from "../commonModel/TiredChargePoliteModel";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest } from "../util/Util";
import { TiredChargePoliteTaskItem } from "./TiredChargePoliteTaskItem";

export class TiredChargePoliteMain extends BaseItem1 {

    private actInfo: any;

    private loop_mgr: LoopScrowViewMgr;
    private timeId: number;

    private get tiredChargePoliteModel() {
        return TiredChargePoliteModel.GetInstance();
    }

    public constructor(parent?) {
        super(parent)
        this.base_file = "tiredChargePolite"
        this.layout_file = "TiredChargePoliteMain"
        this.layer_value = Enum_UILayer.UI

        this.load_callback = () => {
            let custom_event = CustomActivityDefine.EVENT;
            let model: CustomActivityModel = CustomActivityModel.GetInstance()
            model.Fire(custom_event.SCMD_REQUEST, 33259, this.actInfo.base_type, this.actInfo.sub_type);
            this.InitEvents();
            this.LoadSuccess();
        }

    }

    public CustomMehod(index: number, info: any) {
        if (!info) return
        this.actInfo = info;
    }

    public SetActInfo(info: any, parm: any) {
        if (!info) return
        this.actInfo = info;
    }


    private LoadSuccess() {
        let res_mgr: ResManager = ResManager.GetInstance();
        res_mgr.SetTexture(this, this.bgImg, GameResPath.GetIconJpgOtherPath("tiredChargePolite", "ui_activity_bg8"));
        this.StartTimer();
        this.RenderTask();
    }

    private InitEvents() {
        // 领取奖励回调
        // this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
        //     let args = new_args;
        //     if (this.actInfo.base_type == args[0] && this.actInfo.sub_type == args[1]) {
        //         if (args[3]?.length > 0) {
        //             let view = new CongratulationObtainView(args[3], 10)
        //             view.Open();
        //         }
        //         this.actInfo = CustomActivityModel.GetInstance().GetActInfo(args[0], args[1]);
        //     }
        // });

        // 界面更新
        this.BindEvent(
            this.tiredChargePoliteModel,
            TiredChargePoliteModelEvent.UP_VIEW, () => {
                this.RenderTask();
            }
        )
    }

    private RenderTask() {
        this.descHtml.innerHTML = this.actInfo.desc;
        let task: IS2CTiredChargePoliteTasksParam[] = this.tiredChargePoliteModel.GetTasks();

        task.sort((a: IS2CTiredChargePoliteTasksParam, b: IS2CTiredChargePoliteTasksParam) => {
            let stateA: TiredChargePoliteTaskState = this.tiredChargePoliteModel.GetGearStateByGrade(a.grade);
            let stateB: TiredChargePoliteTaskState = this.tiredChargePoliteModel.GetGearStateByGrade(b.grade);

            let sortA: number = stateA == TiredChargePoliteTaskState.eHaveGet ? Number.MAX_VALUE : Number.MIN_VALUE; 
            let sortB: number = stateB == TiredChargePoliteTaskState.eHaveGet ? Number.MAX_VALUE : Number.MIN_VALUE;

            return sortA - sortB;
        });



        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.taskList,
                TiredChargePoliteTaskItem,
                task,
                LoopScrCon.Vertical,
            );
        } else {
            this.loop_mgr.replaceAll(task);
        }
    }

    /**
     * 倒计时
     */
    public StartTimer() {
        let info = this.actInfo;
        this.StopTimer();
        let loop_func = () => {
            let left_time = info.etime - TimeUtil.getServerTime();
            if (left_time <= 0) {
                this.StopTimer();
                this.timeLab.text = '已结束';
                this.timeLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED);
            } else {
                let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
                this.timeLab.text = time;
            }
        }

        this.timeId = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
        loop_func();
    }

    public StopTimer() {
        if (this.timeId) {
            GlobalTimerQuest.CancelQuest(this.timeId)
            this.timeId = null
        }
    }



    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        this.StopTimer();
        super.DeleteMe()
    }

    bgImg: Laya.Image
    timeLab: Laya.Label
    descHtml: Laya.HTMLDivElement
    taskList: Laya.List
    public GetComponents() {
        [
            this.bgImg,
            this.timeLab,
            this.descHtml,
            this.taskList,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "timeLab",
                "descHtml",
                "taskList",
            ])
        this.descHtml.style.fontSize = 20;
        this.descHtml.style.color = '#FFFFFF';
        this.descHtml.style.height = 24;
        this.descHtml.style.width = 706;
    }
}
window["TiredChargePoliteMain"] = TiredChargePoliteMain