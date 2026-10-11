// TypeScript file
export enum PoseState {
    NONE = 0,
    STAND,
    MOVE,
    HITED,
    ATTACK,
    DEAD,
    NULL,
    WAITSTAND,
    JUMP,
    TASK_JUMP,
    DIZZY,
    RUSH,
    COLLECT,
    FLY_SHOE_EFFECT
}
export class StateMachineInfo {
    public state_enter_func: string;
    public state_update_func: string;
    public state_quit_func: string;
    public is_reenter: Boolean = false;
    public constructor(enter: string, update: string, quit: string, is_reenter: Boolean = false) {
        this.state_enter_func = enter;
        this.state_update_func = update;
        this.state_quit_func = quit;
        this.is_reenter = is_reenter;
    }
}
window["PoseState"] = PoseState;
window["StateMachineInfo"] = StateMachineInfo;
export class StateMachineManager {
    private _state_machine_info_dic: {
        [key: number]: StateMachineInfo;
    } = {};
    private _curr_state: number = PoseState.NONE;
    private _state_target;
    private _change_state_enter_func: string;
    private _change_state_leave_func: string;
    public constructor(state_target, change_state_enter_func, change_state_leave_func) {
        this._state_target = state_target;
        this._change_state_enter_func = change_state_enter_func;
        this._change_state_leave_func = change_state_leave_func;
    }
    public RegisterState(state: number, enter: string, update: string, quit: string, is_reenter: Boolean = false) {
        if (!this._state_machine_info_dic[state]) {
            let state_info = new StateMachineInfo(enter, update, quit, is_reenter);
            this._state_machine_info_dic[state] = state_info;
        }
    }
    public GetCurrState() {
        return this._curr_state;
    }
    public ChangeState(state: number) {
        if (state != undefined) {
            let self = this;
            let last_state = self._curr_state;
            self._curr_state = state;
            let state_info = self._state_machine_info_dic[last_state];
            if (state_info) {
                if (!state_info.is_reenter && last_state == state) {
                    return;
                }
                self._state_target[state_info.state_quit_func](last_state);
                self._state_target[self._change_state_leave_func](last_state);
                //state_info.state_quit_func(last_state)
            }
            state_info = self._state_machine_info_dic[self._curr_state];
            if (state_info) {
                self._state_target[state_info.state_enter_func](self._curr_state);
                self._state_target[self._change_state_enter_func](self._curr_state);
                // state_info.state_enter_func(self._curr_state)
            }
        }
    }
    public Update(now_time: number, elapse_time: number) {
        let self = this;
        let state_info = self._state_machine_info_dic[self._curr_state];
        if (state_info) {
            self._state_target[state_info.state_update_func](now_time, elapse_time);
            // state_info.state_update_func(now_time, elapse_time)
        }
    }
}

window["StateMachineManager"] = StateMachineManager