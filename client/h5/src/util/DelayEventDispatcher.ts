import { HashEventDispatcher } from "../common/HashEventDispatcher";
import { Runner } from "./Runner";
// TypeScript file
export class DelayEventDispatcher extends HashEventDispatcher {
    update_id: number = 0;
    fire_callback_queue: Array<Function> = [];
    DelayFire;
    Update;
    public constructor() {
        super();
        let runner = Runner.GetInstance();
        let local_Math = Math;
        this.DelayFire = (event_id, ...other) => {
            if (event_id == null) {
                console.log("Try to call EventSystem:Fire() with a nil event_id");
                return;
            }
            let event_list = this.all_event_dic[event_id];
            if (event_list) {
                if (this.update_id == 0) {
                    this.update_id = runner.AddRunObj(this);
                }
                for (let bind_id in event_list) {
                    let bind_obj = event_list[bind_id];
                    let callbackfunc = () => {
                        if (bind_obj) {
                            if (other && other.length > 0) {
                                bind_obj(...other);
                            }
                            else {
                                bind_obj();
                            }
                        }
                    };
                    this.fire_callback_queue.push(callbackfunc);
                }
            }
        };
        this.Update = (now_time, elapse_time) => {
            if (this.fire_callback_queue) {
                let size = this.fire_callback_queue.length;
                let call_back;
                if (size <= 10) {
                    call_back = this.fire_callback_queue.shift();
                    if (call_back) {
                        call_back();
                    }
                }
                else {
                    size = local_Math.ceil(size * 0.2);
                    for (let i = 0; i < size; i++) {
                        call_back = this.fire_callback_queue.shift();
                        if (call_back) {
                            call_back();
                        }
                    }
                }
            }
            if (this.fire_callback_queue.length == 0 && this.update_id > 0) {
                runner.RemoveRunObj(this.update_id);
                this.update_id = 0;
            }
        };
    }
}

window["DelayEventDispatcher"] = DelayEventDispatcher