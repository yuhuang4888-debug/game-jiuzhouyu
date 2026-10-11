import { EventName } from '../common/EventName';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventDispatcher } from '../util/EventDispatcher';
import { KaifuActivityModel } from './KaifuActivityModel';

export class WeekCardModel extends EventDispatcher {
    private static _instance: WeekCardModel;
    public static UPDATE_VIEW = "UPDATE_VIEW"
    public static REQUEST_PROTO = "REQUEST_PROTO"
    public static UPDATE_ICON = "UPDATE_ICON"
    private act_data
    private week_card_lv = 0
    private have_reward = false
    private reward_data
    public spacial_red = false
    public constructor() {
        super();
    }


    public SetWeekCardData(data) {
        this.act_data = data
        this.week_card_lv = data.lv
        if(data.is_activity == 1 && this.spacial_red){
            this.spacial_red = false
        }
        GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 452, this.CanReceive() || this.spacial_red)
        KaifuActivityModel.GetInstance().upateInvestRedDot("WeekCardMainView")
    }

    public GetWeekCardData() {
        return this.act_data
    }
    public GetWeeklyCardLv() {
        return this.week_card_lv
    }

    public CanReceive() {
        return (this.act_data && this.act_data.is_activity && this.act_data.can_receive_gift > 0) ? true : false
    }

    public SetHaveReward(bool){
        this.have_reward = bool
    }

    public GetHaveReward(){
        return this.have_reward
    }
    public SetReward(data){
        this.reward_data = data
    }

    public GetReward(){
        return this.reward_data
    }

    public static GetInstance() {
        if (!WeekCardModel._instance) {
            WeekCardModel._instance = new WeekCardModel();
        }
        return WeekCardModel._instance;
    }

}

window['WeekCardModel'] = WeekCardModel;
