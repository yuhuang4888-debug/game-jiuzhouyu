import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { ActivityState, ActivityType, DailyModel } from "../commonModel/DailyModel";
import { PrayModel } from "../commonModel/PrayModel";
import { RoleManager } from "../commonModel/RoleManager";
import { TaskModel, TaskType } from "../commonModel/TaskModel";
import { DailyEvent } from "../daily/DailyEvent";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";
import { TaskUpAlertItem } from "./TaskUpAlertItem";

export class TaskUpAlertView extends BaseView1 {

    InitEvent
    InitConfig
    LoadSuccess
    InitView
    GetDailyData

    public constructor() {
        super()

        let cfg_ = []
        let item_list_ = []
        this.base_file = "task"
        this.layout_file = "TaskUpAlertView"
        this.is_center = true
        this.use_background = true
        this.destroy_imm = true
        this.show_open_movie = true
        this.click_bg_toClose = true
        this.layer_value = Enum_UILayer.Activity
        let up_alert_cfg
        let local_Util = Util
        let daily_model = DailyModel.GetInstance()
        let model = TaskModel.GetInstance()
        this.preload_client_config = {
            "ClientTaskUpAlertConfig": false,
        }

        let res_mgr = ResManager.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.open_callback = () => {
            DailyModel.GetInstance().Fire(DailyEvent.DAILY_REQUEST_PROTO, 15701, "c", ActivityType.UnLimit)
            DailyModel.GetInstance().Fire(DailyEvent.DAILY_REQUEST_PROTO, 15701, "c", ActivityType.Limit)
            this.InitConfig()
        }

        this.destroy_callback = () => {
            this.Destroy()
        }

        this.LoadSuccess = () => {
            this._scr_item.vScrollBar.visible = false
            up_alert_cfg = res_mgr.GetGameConfigFromCache(this, "ClientTaskUpAlertConfig", true)
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/task/texture/uixrw_018.png", true)
            this.InitEvent()
            this.InitView()
        }

        this.InitConfig = () => {
            let daily_list = []
            let limit_list = []
            let daily_data = null
            let _open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
            daily_data =  daily_model.daily_data
            daily_list = daily_data[ActivityType.UnLimit].ac_list
            limit_list = daily_data[ActivityType.Limit].ac_list
            for (let key in limit_list) {
                let vo = limit_list[key]
                table.insert(daily_list, vo)
            }

            cfg_ = []
            if (up_alert_cfg) {
                for (let k in up_alert_cfg) {
                    let vo = up_alert_cfg[k]
                    // let obj = Util.DeepCopy(v)
                    vo.is_finish = false
                    if ((vo.func_id == 0) && (vo.sub_func_id == 0) && (vo.activity_sub_id == 0)) {  //野外挂机或者是这三个字段为0的活动
                        if(vo.is_pray){
                            let data = PrayModel.GetInstance().pray_info_list
                            if(data){
                                for (let v of data) { //type为1是金币祈愿，2为经验祈愿
                                    if(v.type == 2){
                                        if(v.remain_times == 0){
                                            vo.is_finish = true
                                            vo.priority_id = -1
                                        }
                                    }
                                }
                            }
                        }
                        table.insert(cfg_, vo)
                    } else {
                        let key = `${vo.func_id}@${vo.sub_func_id}@${vo.activity_sub_id}`
                        let config_ac = model.GetConfigAc(key)
                        if (config_ac) {
                            let min_open_day = null
                            let max_open_day = null
                            let open_day = JSON.parse(config_ac.open_day)
                            let week_time = JSON.parse(config_ac.week)
                            let start_lv = config_ac.start_lv
                            config_ac.priority_id = null
                            config_ac.priority_id = vo.priority_id
                            config_ac.star = vo.star
                            config_ac.output = vo.output
                            config_ac.is_finish = false
                            config_ac.week_limit = null
                            config_ac.time_limit = null
                            config_ac.is_limit_activity = false
                            config_ac.desc = vo.desc
                            config_ac.jump_id = vo.jump_id
                            if (open_day.length > 0) { //那些任务开启了
                                min_open_day = open_day[0][0]
                                max_open_day = open_day[0][1]
                                if ((_open_day > max_open_day) || (_open_day < min_open_day) || role_lv < start_lv) {
                                    continue
                                } else {

                                }
                            }
                            this.GetDailyData(daily_list, config_ac, key)
                        }
                        table.insert(cfg_, config_ac)
                    }
                }

                let sort_fun = (a?, b?) => {
                    return a.priority_id > b.priority_id
                }
                table.sort(cfg_, sort_fun)
            }
        }

        this.GetDailyData = (daily_list?, cfg_vo?, config_key?) => {
            for (let idx in daily_list) {
                let data = daily_list[idx]
                let key = `${data.module}@${data.module_sub}@${data.ac_sub}`
                if (key == config_key) {
                    // let [start_second, start_lv, state, end_second, now_second, isToday] = daily_model.GetActivityStartSecAndStartLv(data, TimeUtil.GetZoneTime())
                    // if (isToday) {   //活动今天是不是开启了
                        if (data.state == ActivityState.Opening) {  //活动开放
                            if (data.num < data.max_num) {
                                cfg_vo.is_finish = false
                            } else {
                                cfg_vo.is_finish = true
                                cfg_vo.priority_id = -1
                            }
                        } else {
                            let [str_arr, limit_state] = daily_model.GetTimeStr(cfg_vo.time_region)
                          
                            let curTime = TimeUtil.getServerTime()
                            let week = new Date(curTime)
                            let week_time = JSON.parse(cfg_vo.week)
                            if (week_time.length > 0) {
                                let in_week = false
                                let str = ""
                                for (let key in week_time) {
                                    let vo = Number(week_time[key])
                                    if (week_time.length > 2) {
                                        str += `周${TimeUtil.WeekNumToFont(vo)} `
                                    } else {
                                        str += `周${TimeUtil.WeekNumToFont(vo)}`
                                    }
                                    if ((week.getDay() + 1) == vo) {
                                        in_week = true
                                    }
                                }
                                //当前的星期不在活动开放的星期时间点
                                if(!in_week){
                                    cfg_vo.week_limit = str
                                }
                            }
                            cfg_vo.time_limit = `${str_arr[0]} - ${str_arr[1]}`

                            if((limit_state == ActivityState.Opening) && (data.state == ActivityState.Opening)){
                                cfg_vo.is_limit_activity = false
                            }else {
                                cfg_vo.is_limit_activity = true
                                cfg_vo.priority_id = 0
                            }
                        }
                    // } else {
                    // }
                    break
                }
            }
        }

        this.InitEvent = () => {
            let close_func = () => {
                this.Close()
            }

            local_Util.AddClickEvent(this._img_close, close_func, this, true, null, null, null, null)
            local_Util.AddClickEvent(this._btn_sure, close_func, this, true)
            this.BindEvent(TaskModel.GetInstance(), TaskModel.CLOSE_UPALERT_VIEW, () => {
                this.Close()
            })

            this.BindEvent(TaskModel.GetInstance(), TaskModel.UPDATE_TASK_ALERT_VIEW, ()=>{
                this.InitConfig()
                this.InitView()
            })
            local_Util.AddClickEvent(this.banner, () => {
                this.Close()
                OpenFun.OpenFunHandler(23)
            }, this, true)
        }

        this.InitView = () => {
            let len = local_Util.TableSize(cfg_)
            if (len == 0) {
                return
            }
            if (item_list_.length > 0) {
                for (let _tmpi in item_list_) {
                    var item = item_list_[_tmpi]
                    item.SetVisible(false)
                }
            }
            let count = 0
            for (let k in cfg_) {
                var v = cfg_[k]
                let item = item_list_[count]
                if (!item) {
                    item = new TaskUpAlertItem(this.Content)
                    item.Load()
                    item_list_.push(item)
                }
                item.SetVisible(true)
                item.SetData(v, Number(k))
                count = count + 1
            }
            let role = RoleManager.GetInstance().GetMainRoleVo()
            if (role && role.vip_flag < 4) {
                this.banner.visible = true
            } else {
                this.banner.visible = false
            }
            this.banner.visible = false
        }

        this.Destroy = () => {
            if (item_list_.length > 0) {
                for (let _tmpi in item_list_) {
                    var item = item_list_[_tmpi]
                    item.DeleteMe()
                }
                item_list_ = []
            }
        }
    }
    _img_bg: Laya.Image
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Label1: Laya.Label
    _scr_item: Laya.Panel
    Content: Laya.VBox
    _btn_sure: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _img_close: Laya.Image
    banner: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._Image1,
            this._Image2,
            this._Image3,
            this._Label1,
            this._scr_item,
            this.Content,
            this._btn_sure,
            this._Image11,
            this.labelDisplay,
            this._img_close,
            this.banner
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Image1",
                "_Image2",
                "_Image3",
                "_Label1",
                "_scr_item",
                "Content",
                "_btn_sure",
                "_Image11",
                "labelDisplay",
                "_img_close",
                "banner"
            ])
    }
}
window["TaskUpAlertView"] = TaskUpAlertView