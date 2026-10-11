import { BaseItem1 } from "../common/BaseItem1";
import { SysGoodsMgr } from "./SysGoodsMgr";
import { StateMachineManager } from "../util/StateMachineManager";
import { MessageItemState } from "./MessageItem";
import { ColorUtil } from "../util/ColorUtil";
import { BaseState } from "../login/loginstate/ConnectGameState";
import { TimeUtil } from "../util/TimeUtil";
import { EquipmentItem } from "../common/EquipmentItem";
import { Util } from "../util/Util";

export class GoodsItem extends BaseItem1 {
    private _gp_reward: Laya.Box;
    private _lb_name: Laya.Label;
    private _reward: EquipmentItem;
    state_machine;
    goods_setting;
    state_list;
    goodsVo;
    re_enter_state
    public constructor(parent) {
        super(parent);
        this.is_delay_callback = false;
        this.goods_setting = SysGoodsMgr.MessageSetting;
        this.base_file = "sysInfo";
        this.layout_file = "GoodsItem";
        this.state_machine = new StateMachineManager(this, "ChangeStateEnter", "ChangeStateLeave");
        if (!this.state_list){
            this.state_list = {};
        }
        this.state_list[MessageItemState.born] = new GoodsBornState(this);
        this.state_machine.RegisterState(MessageItemState.born, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[MessageItemState.alive] = new GoodsAliveState(this);
        this.state_machine.RegisterState(MessageItemState.alive, "EnterState", "UpdateState", "QuitState", true);
        this.state_list[MessageItemState.death] = new GoodsDeathState(this);
        this.state_machine.RegisterState(MessageItemState.death, "EnterState", "UpdateState", "QuitState", true);
        this.load_callback = function () {
            this.display_obj.anchorX = 0.5;
            this.display_obj.anchorY = 1;
            this.display_obj.alpha = 0;
            this.display_obj.visible = false;
            this.display_obj.scaleX = this.display_obj.scaleY = this.goods_setting.default_scale;
			this.display_obj.centerX = 0
            if (this.re_enter_state != null){
                this.EnterState(this.re_enter_state)
                this.re_enter_state = null
            }
        };
    }
    public Update(now_time, elapse_time) {
        this.state_machine.Update(now_time, elapse_time);
    }
    private EnterState(state) {
        if (this.display_obj){
            this.state_list[state].OnStateEnter();
        }else{
            this.re_enter_state = state
        }
    }
    private UpdateState(now_time, elapse_time) {
        let state = this.state_machine.GetCurrState();
        this.state_list[state].OnStateUpdate(now_time, elapse_time);
    }
    private QuitState(state) {
        this.state_list[state].OnStateQuit();
    }
    private _move_state = false;
    private _tagret_y;
    private _tagret_x;
    get MoveState() {
        return this._move_state;
    }
    set MoveState(value) {
        let state = this.state_machine.GetCurrState();
        if (state != MessageItemState.alive)
            return;
        if (value) {
            this._tagret_y = this.display_obj.y - this.goods_setting.once_move_dis;
        }
        this._move_state = value;
    }
    public DeleteMe() {
        this.state_machine = undefined;
        super.DeleteMe();
    }
    public ResetObj() {
        this.ChangeState(MessageItemState.death);
    }
    private ChangeStateEnter(state: number) { }
    private ChangeStateLeave(state: number) { }
    public ChangeState(state) {
        this.state_machine.ChangeState(state);
    }
    public SetGoods(goodsVo) {
        this.goodsVo = goodsVo;
        if (!this._reward) {
			this._reward = new EquipmentItem(this._gp_reward);
			this._reward.Load();
		}
		if (goodsVo) {
			let num = goodsVo.drop_num == 1 ? undefined : goodsVo.drop_num;
			this._reward.SetData(goodsVo.type_id, num);
            var color=ColorUtil.GetColorDark(goodsVo.color, false).toString()
            // color="#"+color
            this._lb_name.color = color
            this._lb_name.text = goodsVo.goods_name;
		}
        this._reward.SetScale(0.6)
    }
    public ReleaseObj() {
        this._move_state = false;
        this.display_obj.y = 0;
        //this.display_obj.x = 0;
		this.display_obj.centerX = 0
        this.display_obj.alpha = 0;
        this.display_obj.visible = false;
        this.display_obj.scaleX = this.display_obj.scaleY = this.goods_setting.default_scale;
        this._tagret_y = null;
        this._tagret_x = null;
        if (this._reward) {
			this._reward.DeleteMe();
			this._reward = undefined;
		}
    }
    public GetState() {
        return this.state_machine.GetCurrState();
    }

    public GetComponents() {
        [
        this._gp_reward,
        this._lb_name,
        ]
         = this.GetChildrenByNames([
        
        "_gp_reward",
        "_lb_name",
        ])
        }
}
export class GoodsBornState implements BaseState {
    state_finish = false;
    self;
    goods_setting;
    dic_alpha;
    dic_scale;
    public constructor(self) {
        this.self = self;
        this.goods_setting = self.goods_setting;
    }
    public OnStateEnter = () => {
        if(this.self.display_obj){
            this.self.display_obj.visible = true;
        }
    };
    public OnStateUpdate = (now_time, elapse_time) => {
        let self = this;
        if (!self.self.display_obj){
            return
        }
        let dic_alpha = elapse_time / self.goods_setting.once_move_time;
        let dic_scale = (1 - self.goods_setting.default_scale) * elapse_time / self.goods_setting.once_move_time;
        let alpha = self.self.display_obj.alpha + dic_alpha;
        if (alpha > 1)
            alpha = 1;
        self.self.display_obj.alpha = alpha;
        let scale = self.self.display_obj.scaleX + dic_scale;
        if (scale > 1)
            scale = 1;
        self.self.display_obj.scaleX = self.self.display_obj.scaleY = scale;
        // let dic_y = self.goods_setting.once_move_y_dis * elapse_time / self.goods_setting.once_move_y_time
        // self.self.y -= dic_y
        if (scale == 1 && alpha == 1)
            self.state_finish = true;
        if (self.state_finish) {
            self.state_finish = false;
            self.self.ChangeState(MessageItemState.alive);
        }
    };
    public OnStateQuit = () => {
    };
}
export class GoodsAliveState implements BaseState {
    state_finish = false;
    self;
    dic_y;
    alive_time;
    goods_setting;
    goodsVo;
    public constructor(self) {
        this.self = self;
        this.goodsVo = self.goodsVo;
        this.goods_setting = self.goods_setting;
    }
    public OnStateEnter = () => {
        SysGoodsMgr.GetInstance().TryShowMiniGoods(this.goodsVo);
        this.alive_time = TimeUtil.getClientTime() + this.goods_setting.life_cycle;
    };
    public OnStateUpdate = (now_time, elapse_time) => {
        // console.log(`==================${elapse_time}===========`)
        let self = this;
        if (self.self.MoveState) {
            let dic_y = self.goods_setting.once_move_dis * elapse_time / self.goods_setting.once_move_time;
            self.self.display_obj.y -= dic_y;
            if (self.self.display_obj.y <= self.self._tagret_y) {
                self.self.display_obj.y = self.self._tagret_y;
                self.self.MoveState = false;
            }
        }
        if (self.alive_time && TimeUtil.getClientTime() >= self.alive_time) {
            self.state_finish = true;
        }
        if (self.state_finish) {
            self.state_finish = false;
            self.self.ChangeState(MessageItemState.death);
        }
    };
    public OnStateQuit = () => {
        this.alive_time = undefined;
    };
}
export class GoodsDeathState implements BaseState {
    state_finish = false;
    self;
    goods_setting;
    stay_time;
    goodsVo;
    not_need_show_y_animation;
    public constructor(self) {
        this.self = self;
        this.goodsVo = self.goodsVo;
        this.goods_setting = self.goods_setting;
    }
    public OnStateEnter = () => {
        let self = this;
        // this.stay_time = TimeUtil.getClientTime() + this.goods_setting.stay_time
        // this.not_need_show_y_animation = Math.abs(self.self.y) > (this.goods_setting.max_show_count - 1) * this.goods_setting.once_move_dis
        // if (this.not_need_show_y_animation) {
        this.self.display_obj.visible = false;
        SysGoodsMgr.GetInstance().DeleteGoods(this.self.hashCode);
        // }
    };
    public OnStateUpdate = (now_time, elapse_time) => {
        // let self = this
        // if (!this.not_need_show_y_animation) {
        // 	if (self.stay_time && TimeUtil.getClientTime() < self.stay_time) {
        // 		return
        // 	}
        // 	let dic_y = self.goods_setting.once_move_y_dis * elapse_time / self.goods_setting.once_move_y_time
        // 	self.self.display_obj.y -= dic_y
        // 	let dic_alpha = 0.2 * elapse_time / self.goods_setting.once_move_y_time
        // 	self.self.display_obj.alpha -= dic_alpha
        // 	if (self.self.display_obj.alpha <= 0) {
        // 		self.self.display_obj.alpha = 0
        // 	}
        // 	if (self.self.display_obj.y > self.self._tagret_y) {
        // 		self.self.display_obj.y = self.self._tagret_y
        // 		this.self.display_obj.visible = false
        // 		SysGoodsMgr.GetInstance().DeleteGoods(this.self.hashCode)
        // 		this.state_finish = true
        // 	}
        // }
        // if (this.state_finish) {
        // 	this.state_finish = false
        // }
    };
    public OnStateQuit = () => {
    };
}
window["GoodsItem"] = GoodsItem