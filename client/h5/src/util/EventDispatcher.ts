import { GameResPath } from './GameResPath';
import { Status } from './Status';
import { BaseClass, HashObject } from '../common/BaseClass';
// TypeScript file
export class EventDispatcher extends BaseClass {
    static ALL_VAR = 'ALL';
    static ALL_CHANGED = 'EventDispatcher.ALL_CHANGED';
    static CHANGE_VAR = 'vo_change_var';
    delay_fire_BindId = 0;
    fire_event_startTime = 0;
    private static all_event_count = 88888888;

    all_event_dic: {
        [key: string]: {
            [key: number]: any;
        };
    } = {};
    bind_id_to_event_id_dic: {
        [key: number]: string;
    } = {};
    calling_event_dic: {
        [key: string]:
            | Boolean
            | {
                  [key: number]: Boolean;
              };
    } = {};
    use_delete_method: Boolean = false;
    /**config_name, call_back, is_client_cfg = false, load_queue: LOAD_QUEUE = LOAD_QUEUE.HIGHT */
    /**config_name, is_client_cfg = false */

    public DeleteMe() {
        if (this.delay_fire_BindId) {
            // GlobalTimerQuest.CancelQuest(this.delay_fire_BindId);
            this.delay_fire_BindId = 0;
        }
        this.fire_event_startTime = 0;
        this.UnBindAll();
    }
    _cfg_hash_obj = new HashObject();
    public constructor() {
        super();
    }

    Bind(event_id: string, call_back: Function) {
        if (event_id == null) {
            console.error('Try to bind to a nil event_id');
            console.trace();
            return;
        }
        if (call_back == null) {
            console.error('Try to bind to a nil event_func');
            console.trace();
            return;
        }
        let event_list = this.all_event_dic[event_id];
        if (event_list == null) {
            event_list = {};
            this.all_event_dic[event_id] = event_list;
        }
        ++local_EventDispatcher.all_event_count;
        this.bind_id_to_event_id_dic[local_EventDispatcher.all_event_count] = event_id;
        event_list[local_EventDispatcher.all_event_count] = call_back;
        return local_EventDispatcher.all_event_count;
    }
    UnBind(bind_id) {
        if (bind_id == null) {
            return;
        }
        let event_id = this.bind_id_to_event_id_dic[bind_id];
        if (event_id) {
            let calling_event = this.calling_event_dic[event_id];
            if (calling_event != null) {
                if (calling_event == false) {
                    calling_event = {};
                    this.calling_event_dic[event_id] = calling_event;
                }
                calling_event[bind_id] = true;
                let event_list = this.all_event_dic[event_id];
                if (event_list) {
                    event_list[bind_id] = false;
                }
                return;
            }
            delete this.bind_id_to_event_id_dic[bind_id];
            let event_list = this.all_event_dic[event_id];
            if (event_list) {
                delete event_list[bind_id];
            }
        }
    }
    UnBindAll() {
        // if (this.update_id > 0)
        // {
        //     Runner.GetInstance().RemoveRunObj(this.update_id)
        //     this.update_id = 0
        // }
        this.all_event_dic = {};
        this.bind_id_to_event_id_dic = {};
        // this.calling_event_dic = {}
        // delete this.need_fire_events
        // delete this.fire_callback_queue
    }
    Fire(event_id, ...other) {
        if (event_id == null) {
            console.error('Try to call EventDispatcher:Fire() with a nil event_id');
            console.trace();
            return;
        }
        let event_list = this.all_event_dic[event_id];
        let n = 0;
        if (event_list) {
            this.calling_event_dic[event_id] = false;
            let vo;
            for (let bind_id in event_list) {
                vo = event_list[bind_id];
                n++;
                if (n > 1000) {
                    let GameError = window['GameError'];
                    GameError.GetInstance().SendErrorToPHP('事件触发过多， event_id = ' + event_id, true);
                }
                if (vo && vo != false) {
                    if (other && other.length > 0) {
                        vo(...other);
                    } else {
                        vo();
                    }
                }
            }
            let calling_event = this.calling_event_dic[event_id];
            delete this.calling_event_dic[event_id];
            if (calling_event && calling_event != false) {
                for (let bind_id in calling_event) {
                    this.UnBind(bind_id);
                }
            }
        }
    }
    ChangeAllVar() {
        for (let pro in this) {
            if (typeof this[pro] != 'function') {
                // console.log("ChangeVar", pro)
                this.Fire(pro, pro, this[pro]);
            }
        }
        this.Fire(local_EventDispatcher.ALL_CHANGED);
    }
    ChangeVar(var_type: string, value?, delay_to_fire: Boolean = false, force_fire: Boolean = false, param: any = null) {
        let old_value = this[var_type];
        if (old_value != value || force_fire) {
            this[var_type] = value;
            if (delay_to_fire) {
                let fire_func = () => {
                    this.fire_event_startTime = Status.NowTime;
                    if (this.delay_fire_BindId) {
                        // GlobalTimerQuest.CancelQuest(this.delay_fire_BindId);
                        this.delay_fire_BindId = 0;
                    }
                    this.Fire(var_type, var_type, value, old_value, param);
                };
                if (!this.fire_event_startTime || Status.NowTime - this.fire_event_startTime >= 0.02) {
                    fire_func();
                } else {
                    if (!this.delay_fire_BindId) {
                        let delayFunc = () => {
                            fire_func();
                        };
                        // this.delay_fire_BindId = GlobalTimerQuest.AddDelayQuest(delayFunc, 20);
                    }
                }
            } else {
                this.Fire(var_type, var_type, value, old_value, param);
            }
        }
    }
    BindOne(var_type, func) {
        let event_name = var_type;
        let eventId = this.Bind(event_name, func);
        return eventId;
    }
    BindAll(func) {
        let eventId = this.Bind(local_EventDispatcher.ALL_CHANGED, func);
        return eventId;
    }
    DelayFire(event_id, ...other) {
        this.Fire(event_id, ...other);
    }
}
var local_EventDispatcher = EventDispatcher
window['EventDispatcher'] = EventDispatcher;
