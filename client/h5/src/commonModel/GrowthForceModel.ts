import { EventDispatcher } from '../util/EventDispatcher';
import { GrowthBenefitsModel, GrowthBenefitsModelEvent } from './GrowthBenefitsModel';
import { RoleManager } from './RoleManager';
import { Config } from '../common/Config';


export enum EnumGrowthForceViewType {
    /**成长福利 */
    eGrowingUp,
    /**战力福利 */
    eCombatPower
}

/**
 * 成长战力事件类型类
 */
export class GrowthForceModelEvent {
    static _cname = 'GrowthForceModelEvent';
    /**选中页签 */
    public static TAB_SELECT: string =
        GrowthForceModelEvent._cname + '_' + 'TAB_SELECT';
    /**打开界面 */
    public static OPEN_VIEW: string =
        GrowthForceModelEvent._cname + '_' + 'OPEN_VIEW'
    /**关闭界面 */
    public static CLOSE_VIEW: string =
        GrowthForceModelEvent._cname + '_' + 'CLOSE_VIEW'
}

export let GrowthForceEvent = {
	WELFARE_REQUEST_PROTO: "WELFARE_REQUEST_PROTO",
    UPDATE_FIGHT_WELFARE: "UPDATE_FIGHT_WELFARE",//战斗福利 
	CLOSE_FIGHT_WELFARE: "CLOSE_FIGHT_WELFARE" //通知关闭战斗福利
}

window["EnumGrowthForceViewType"]=EnumGrowthForceViewType
window["GrowthForceModelEvent"]=GrowthForceModelEvent
window["GrowthForceEvent"]=GrowthForceEvent

export class GrowthForceModel extends EventDispatcher {
    private static _instance: GrowthForceModel;
    
	 //战力福利
	 fight_welfare_round
	 fight_welfare_time
	 fight_welfare_list
	 fight_welfare_combat
	 fight_welfare_next_combat
	 fight_welfare_login_red
	 is_login_changed
	 fw_max_round  //最大轮数
	 max_item_num  //布局有多少个奖励
	 MaxRound
	 is_skip_animation //是否跳过动画
    public constructor() {
		super()
    
        this.fight_welfare_round=0
		this.fight_welfare_time=0
		this.fight_welfare_list={}
		this.fight_welfare_login_red=true
		this.fight_welfare_combat=0
		this.fight_welfare_next_combat=0
		this.is_login_changed=false
		this.fw_max_round=0
		this.MaxRound = 0
		this.max_item_num = 12
		this.is_skip_animation=false
    }


   
	public CheckFightWelfareOpen() {
		let open_level = Config.PRELOAD_SERVER_CONFIG["config_welfare_cfg"]["6"].val
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		let creat_role_day = Config.PRELOAD_SERVER_CONFIG["config_welfare_cfg"]["9"].val
		let curRoleDay: number = RoleManager.GetInstance().GetRoleCreateDay() + 1;
		return level >= Number(open_level)&&curRoleDay>=Number(creat_role_day)
	}

	/**上线发送协议 */
	public FightWelfareSend() {
		GrowthBenefitsModel.GetInstance().Fire(GrowthBenefitsModelEvent.REQUEST_PROTO, 41723)
	}


	/**摇奖*/
	public FightWelfareRoll() {
		GrowthBenefitsModel.GetInstance().Fire(GrowthBenefitsModelEvent.REQUEST_PROTO, 41724)
	}

	/**红点检查 return bool*/
	public CheckFightWelfareRed(){
		if(!this.CheckFightWelfareOpen())return false
		if(this.IsFightWelfareGotAll())return false
		if(this.fight_welfare_login_red)return true
		return this.fight_welfare_time>0
	}

	//查找最大轮
	public CheckMaxRound(){
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_combat_welfare_reward
		this.MaxRound = 0
		if (!cfg) return

		//大概100轮 应该够用了
		for (let i = 1; i < 100; i++) {
			let key = `${i}@${12}`
			if (cfg[key]) {
				this.MaxRound = i;
			} else {
				break;
			}
		}
	}

	//战斗福利是否领取完奖励  true全部领完了  false没领完
	public IsFightWelfareGotAll(){
		if(this.fight_welfare_round>=this.MaxRound){
			let count=0
			for(let key in this.fight_welfare_list){
				count++
			}
			return count>=this.max_item_num
		}
		
		return false
	}

    public static GetInstance() {
        if (!GrowthForceModel._instance) {
            GrowthForceModel._instance = new GrowthForceModel();
        }
        return GrowthForceModel._instance;
    }


}

window['GrowthForceModel'] = GrowthForceModel;
