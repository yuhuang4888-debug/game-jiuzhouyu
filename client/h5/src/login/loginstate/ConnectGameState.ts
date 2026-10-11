import { LoginManager } from "../LoginManager";
import { LoginStateEvent } from "../../common/EventName";
export interface BaseState {
    state_finish: boolean;
    OnStateEnter(state: number): void;
    OnStateUpdate(now_time?, elapse_time?): void;
    OnStateQuit(state: number): void;
}
export class ConnectGameState implements BaseState {
    state_finish = false;
    OnStateEnter;
    OnStateUpdate;
    OnStateQuit;
    public constructor() {
        this.OnStateEnter = () => {
            LoginManager.GetInstance().Fire(LoginStateEvent.START_GAME_CONNECT);
        };
        this.OnStateUpdate = () => {
        };
        this.OnStateQuit = () => {
        };
    }
}

window["ConnectGameState"] = ConnectGameState