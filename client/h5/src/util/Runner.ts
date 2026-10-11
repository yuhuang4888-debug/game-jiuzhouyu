import { LayerManager } from "../common/LayerManager";
import { GlobalEventSystem, FRAME_TYPE } from "./DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { BaseClass } from "../common/BaseClass";
// TypeScript file
export class RunnerInfo {
    update_frames: number = 1;
    update_elapse_time: number = 0;
    run_obj;
    public constructor(update_frames: number, run_obj: any) {
        this.update_frames = update_frames;
        this.run_obj = run_obj;
    }
}

window["RunnerInfo"] = RunnerInfo;

let local_Laya = Laya
export class Runner extends BaseClass {
    private static _instance: Runner;
    run_obj_dic: {
        [key: number]: RunnerInfo;
    } = {}; //每帧执行的代码
    run_obj_dic1: {
        [key: number]: RunnerInfo;
    } = {}; //奇数帧执行的代码
    run_obj_dic2: {
        [key: number]: RunnerInfo;
    } = {}; //偶数帧这行的代码
    totol_average_framerate = 60;
    total_frame_count: number = 0; //当前总的帧数
    odd_frame_count: number = 0; //当前奇数帧数
    even_frame_count: number = 0; //当前偶数帧数
    last_elapse_time = 0;
    first_start_time = 0;
    curr_frame_time: number;
    last_enter_time;
    _show_timer_id;
    frmaerate = 60; //帧率
    count_times;
    pause_time = 0;
    deactive_time_len = 0;
    real_frameRate = 60//真实的帧率
    mainrole_update_elapse_time = 0.05
    public static GetInstance(): Runner {
        if (this._instance == null) {
            this._instance = new Runner();
        }
        return this._instance;
    }
    public constructor() {
        super();
        this.InitEvent();
    }
    public InitEvent = () => {



        let comeback_flag = false //是否从后台返回

        this.first_start_time = local_Laya.timer.currTimer;
        // this.curr_frame_time = this.first_start_time * 0.001;
        let stage = local_Laya.stage
        // let frame_slow = local_Laya.Stage.FRAME_SLOW
        // let frame_fast = local_Laya.Stage.FRAME_FAST
        let caclulate_framerate = () => {
            this.LogicFrame();

            // if(this.total_frame_count % 600 == 0) //一定时间内重新计算一次帧率
            // {
            //     if(comeback_flag) //刚从后台返回就忽略当次的计算 免得计算帧频过低
            //     {
            //         this.first_start_time = local_Laya.timer.currTimer;
            //         comeback_flag = false
            //         return
            //     }
            //     this.real_frameRate = 600 / (local_Laya.timer.currTimer - this.first_start_time) * 1000
            //     this.first_start_time = local_Laya.timer.currTimer;

            //     animator_update_frame = Math.ceil(74 / this.real_frameRate) - 1
            //     if(local_Laya.Browser.onMobile)
            //     {
            //         animator_update_frame = animator_update_frame + 1
            //     }
            //     animator_update_frame = animator_update_frame <= 0 ? 1 : animator_update_frame

            //     // this.mainrole_update_elapse_time = 1 / this.real_frameRate * (1 + 0.4)
            //     // console.log("----------------this.real_frameRate------------",this.real_frameRate, animator_update_frame)
            // }
            // let time = stage.getTimeFromFrameStart()
            // if(time > 35)
            // {
            //     stage.frameRate = frame_slow
            // }else
            // {
            //     stage.frameRate = frame_fast
            // }
        };
        // if(Util.IsMiniGame() || 1)
        // {
        // local_Laya.stage.on(local_Laya.Event.FRAME, this, caclulate_framerate);
        // }	
        local_Laya.timer.frameLoop(1, this, caclulate_framerate)

        // GlobalEventSystem.Bind(EventName.WINDOW_RESUME, () =>
        // {
        //     comeback_flag = true
        //     this.real_frameRate = 60
        //     animator_update_frame = Math.ceil(74 / this.real_frameRate) - 1
        //     if(local_Laya.Browser.onMobile)
        //     {
        //         animator_update_frame = animator_update_frame + 1
        //     }
        //     animator_update_frame = animator_update_frame <= 0 ? 1 : animator_update_frame

        //     // this.mainrole_update_elapse_time = 1 / this.real_frameRate * (1 + 0.4)
        // })
    };
    private EnterFrameEvent = () => {
        let now_time = local_Laya.timer.currTimer * 0.001, elapse_time, runner_info: RunnerInfo;
        if (!this.curr_frame_time) {
            elapse_time = 0.016;
        }
        else {
            elapse_time = (now_time - this.curr_frame_time);
        }
        for (let key in this.run_obj_dic) {
            runner_info = this.run_obj_dic[key];
            if (runner_info) {
                if (runner_info.update_frames == 1 || this.total_frame_count % runner_info.update_frames == 0) {
                    runner_info.update_elapse_time += elapse_time;
                    runner_info.run_obj.Update(now_time, runner_info.update_elapse_time);
                    runner_info.update_elapse_time = 0;
                }
                else {
                    runner_info.update_elapse_time += elapse_time;
                }
            }
        }
        if (this.total_frame_count % 2 == 1) {
            ++this.odd_frame_count;
            for (let key in this.run_obj_dic1) {
                runner_info = this.run_obj_dic1[key];
                if (runner_info) {
                    if (runner_info.update_frames == 1 || this.odd_frame_count % runner_info.update_frames == 0) {
                        runner_info.update_elapse_time += elapse_time + this.last_elapse_time;
                        runner_info.run_obj.Update(now_time, runner_info.update_elapse_time);
                        runner_info.update_elapse_time = 0;
                    }
                    else {
                        runner_info.update_elapse_time += elapse_time + this.last_elapse_time;
                    }
                }
            }
        }
        else {
            ++this.even_frame_count;
            for (let key in this.run_obj_dic2) {
                runner_info = this.run_obj_dic2[key];
                if (runner_info) {
                    if (runner_info.update_frames == 1 || this.even_frame_count % runner_info.update_frames == 0) {
                        runner_info.update_elapse_time += elapse_time + this.last_elapse_time;
                        runner_info.run_obj.Update(now_time, runner_info.update_elapse_time);
                        runner_info.update_elapse_time = 0;
                    }
                    else {
                        runner_info.update_elapse_time += elapse_time + this.last_elapse_time;
                    }
                }
            }
        }
        this.curr_frame_time = now_time;
        this.last_elapse_time = elapse_time;
    };
    //逻辑帧
    public LogicFrame() {
        ++this.total_frame_count;
        this.EnterFrameEvent();
        // let curr_time = local_Laya.timer.currTimer;
        // if (!this.last_enter_time && !this.count_times) {
        //     this.last_enter_time = curr_time;
        //     this.count_times = 1;
        //     return;
        // }
        // ++this.count_times;
        // let now = curr_time - this.deactive_time_len;
        // if (now - this.last_enter_time > 1000 * 30) {
        //     this.frmaerate = (this.count_times / (now - this.last_enter_time)) * 1000;
        //     this.last_enter_time = undefined;
        //     this.count_times = undefined;
        //     this.deactive_time_len = 0;
        //     GlobalEventSystem.Fire(EventName.CHECK_ALERT_FRAMERATE);
        //     // if(layer_mgr.stage)
        //     // {
        //     //     let frame = this.total_frame_count / ((curr_time - this.first_start_time) * 0.001)
        //     //     console.log("---------------------------------frame ==", frame, this.total_frame_count, curr_time, this.first_start_time)
        //     //     layer_mgr.stage.frameRate = math_max(30, math_min(60, math_floor(frame) + 4))
        //     // }
        // }
    }
    public AddRunObjByHashCode = (hashcode: number, run_obj: any, update_frames: number = 1, run_type: number = FRAME_TYPE.even) => {
        if (hashcode == null)
            return;
        let run_obj_dic = this.run_obj_dic;
        if (run_type == FRAME_TYPE.odd) //奇数帧
         {
            run_obj_dic = this.run_obj_dic1;
        }
        else if (run_type == FRAME_TYPE.even) //偶数帧
         {
            run_obj_dic = this.run_obj_dic2;
        }
        if (run_obj_dic[hashcode])
            return;
        run_obj_dic[hashcode] = new RunnerInfo(update_frames, run_obj);
        return hashcode;
    };
    public AddRunObj = (run_obj: any, update_frames: number = 1, run_type: number = FRAME_TYPE.even) => {

        let hashcode = run_obj.hashCode;
        return this.AddRunObjByHashCode(hashcode, run_obj, update_frames, run_type);
    };
    public RemoveRunObj = (hashCode:number) => {
        if (hashCode) {
            let obj = this.run_obj_dic[hashCode];
            if (obj) {
                delete this.run_obj_dic[hashCode];
            }
            else {
                obj = this.run_obj_dic1[hashCode];
                if (obj) {
                    delete this.run_obj_dic1[hashCode];
                }
                else {
                    delete this.run_obj_dic2[hashCode];
                }
            }
        }
    };
    public HasRunObj(hashCode:number)
    {
        return this.run_obj_dic[hashCode] || this.run_obj_dic1[hashCode] || this.run_obj_dic2[hashCode];
    }
}

window["Runner"] = Runner