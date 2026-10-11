
import { BaseClass } from "../common/BaseClass";
import { StateMachineManager } from "../util/StateMachineManager";
import { RegisterState } from "./loginstate/RegisterState";
import { LoginState } from "./loginstate/LoginState";
import { SimplifyServerState } from "./loginstate/SimplifyServerState";
import { ServerListState } from "./loginstate/ServerListState";
import { ServerWinState } from "./loginstate/ServerWinState";
import { ConnectGameState } from "./loginstate/ConnectGameState";
import { LoginManager } from "./LoginManager";
import { LoginStateEvent } from "../common/EventName";
import { Runner } from "../util/Runner";
export enum Enum_LoginState {
    Register = 0,
    Login,
    SimplifyServer,
    ServerList,
    ServerWin,
    ConnectGame
}
window["Enum_LoginState"] = Enum_LoginState;
export class LoginStateManager extends BaseClass {
    login_state_change_event_id;
    state_machine: StateMachineManager;
    register_state;
    login_state;
    simplify_server;
    state_list;
    public constructor() {
        super();
        this.state_machine = new StateMachineManager(this, "ChangeStateEnter", "ChangeStateLeave");
        if (!this.state_list)
            this.state_list = {};
        this.state_list[Enum_LoginState.Register] = new RegisterState();
        this.state_machine.RegisterState(Enum_LoginState.Register, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[Enum_LoginState.Login] = new LoginState();
        this.state_machine.RegisterState(Enum_LoginState.Login, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[Enum_LoginState.SimplifyServer] = new SimplifyServerState();
        this.state_machine.RegisterState(Enum_LoginState.SimplifyServer, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[Enum_LoginState.ServerList] = new ServerListState();
        this.state_machine.RegisterState(Enum_LoginState.ServerList, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[Enum_LoginState.ServerWin] = new ServerWinState();
        this.state_machine.RegisterState(Enum_LoginState.ServerWin, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[Enum_LoginState.ConnectGame] = new ConnectGameState();
        this.state_machine.RegisterState(Enum_LoginState.ConnectGame, "EnterState", "UpdateState", "QuitState", true);
        let change_state = (state) => {
            this.state_machine.ChangeState(state);
        };
        this.login_state_change_event_id = LoginManager.GetInstance().Bind(LoginStateEvent.LOGIN_STATE_CHANGE, change_state);
        Runner.GetInstance().AddRunObj(this);
    }
    public Update(now_time, elapse_time) {
        this.state_machine.Update(now_time, elapse_time);
    }
    public Remove() {
        if (this.login_state_change_event_id) {
            LoginManager.GetInstance().UnBind(this.login_state_change_event_id);
            this.login_state_change_event_id = null;
        }
        Runner.GetInstance().RemoveRunObj(this.hashCode);
    }
    private EnterState(state) {
        this.state_list[state].OnStateEnter();
    }
    private UpdateState() {
        let state = this.state_machine.GetCurrState();
        this.state_list[state].OnStateUpdate();
    }
    private QuitState(state) {
        this.state_list[state].OnStateQuit();
    }
    private ChangeStateEnter(state: number) { }
    private ChangeStateLeave(state: number) { }
}

window["LoginStateManager"] = LoginStateManager