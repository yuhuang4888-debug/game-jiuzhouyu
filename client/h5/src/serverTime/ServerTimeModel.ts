import { TimeUtil } from "../util/TimeUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { LoginManager } from "../login/LoginManager";
import { EventName } from "../common/EventName";
export class ServerTimeModel {
    static DAY_CHANGE: string = "ServerTimeModel.DAY_CHANGE";
    static FOUR_CLICK_STATE: string = "ServerTimeModel.FOUR_CLICK_STATE";
    static REFRESH_SERVER_TIME: string = "ServerTimeModel.REFRESH_SERVER_TIME";
    static HOUR_REFRESH: string = "ServerTimeModel.HOUR_REFRESH";
    refresh_hour_list = [4];
    open_time; //开服0时间
    merge_time; //合服时间
    merge_start_time; //合服0点时间
    merge_count; //登录天数
    login_day;
    lastDay;
    lastHour;
    four_event_state;
    static Instance: ServerTimeModel;
    public constructor() {
        this.open_time = 0; //合服时间
        this.merge_time = 0; //合服时间
        this.merge_start_time = 0; ///合服0点时间
        this.merge_count = 0; //登录天数
        this.login_day = 0;
    }
    public static GetInstance() {
        if (!ServerTimeModel.Instance) {
            ServerTimeModel.Instance = new ServerTimeModel();
        }
        return ServerTimeModel.Instance;
    }
    public InitServerTime = (vo) => {
        this.open_time = vo.open_time;
        this.merge_time = vo.merge_time;
        this.merge_start_time = vo.merge_start_time;
        this.merge_count = vo.merge_count;
        TimeUtil.notifyServerTime(vo.server_time);
        this.TryFireEvent();
        GlobalEventSystem.Fire(ServerTimeModel.REFRESH_SERVER_TIME);
        LoginManager.GetInstance().SetGameStartReceiveFlag("10201", true)
    };
    public ResetData = () => {
        this.lastDay = null;
        this.lastHour = null;
    };
    public TryFireEvent = () => {
        let curDay = this.GetOpenServerDay();
        if (this.lastDay && this.lastDay != curDay) {
            GlobalEventSystem.Fire(ServerTimeModel.DAY_CHANGE);
        }
        this.lastDay = curDay;
        let time = TimeUtil.getServerTime();
        let data = new Date(time * 1000);
        let now_hour = data.getHours();
        if (this.lastHour == now_hour)
            return;
        for (let hour of this.refresh_hour_list) {
            if (this.lastHour && this.lastHour != hour && now_hour == hour) {
                GlobalEventSystem.Fire(ServerTimeModel.HOUR_REFRESH, hour);
                break;
            }
        }
        this.lastHour = now_hour;
    };
    public GetOpenServerTime() {
        return this.open_time;
    };
    public GetMergeServerTime() {
        return this.merge_start_time;
    };
    public GetOpenServerDay() {
        let gap = TimeUtil.getServerTime() - this.open_time;
        let day = gap / 3600 / 24;
        return Math.ceil(day);
    };
    public GetMergeServerDay() {
        let gap = TimeUtil.getServerTime() - this.merge_start_time;
        if (this.merge_start_time == 0) {
            gap = 0;
        }
        let day = gap / 3600 / 24;
        return Math.ceil(day);
    };
    //登录累积天数
    public GetLoginDay = () => {
        return this.login_day;
    };
}

window["ServerTimeModel"] = ServerTimeModel