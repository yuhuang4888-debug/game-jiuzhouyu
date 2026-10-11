import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GlobalTimerQuest } from "../util/Util";
import { BaseView1 } from "./BaseView1";
import { EquipmentItem } from "./EquipmentItem";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { ResManager } from "./ResManager";

// TypeScript file
export class CongratulationRareView extends BaseView1 {


    public _img_matrix: Laya.Image;
    public _gp_effect: Laya.Box;
    public _img_horn_right: Laya.Image;
    public _img_horn_left: Laya.Image;
    public _img_leaf_right: Laya.Image;
    public _img_leaf_left: Laya.Image;
    public _img_top: Laya.Image;
    public _lb_time: Laya.Label;
    public _gp_item: Laya.Box;
    public _special: Laya.Image;



    private timer
    private reward_item: EquipmentItem
    InitView
    OnTimer
    SetData
    SetSpecialImg
    DestroyCallback
    FlyReward
    constructor() {
        super()

        let res_mgr = ResManager.GetInstance(),
            local_laya = Laya,
            _reward,
            _time_down,
            _count = 0,
            _special_url

        this.base_file = "common"
        this.layout_file = "CongratulationRareView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.is_center = true
        this.load_callback = () => {
        }
        this.open_callback = () => {
            this.InitView()
        }
        this.destroy_callback = () => {
            this.FlyReward()
            this.DestroyCallback()
        }
        this.FlyReward = () => {
            if(_reward[0]!=34)return
            let point = this._gp_item.localToGlobal(new Laya.Point(127/2, 127/2))
			let list = [{ "0": 0, "1":  _reward[0], "2":  _reward[1] }]
			GlobalEventSystem.Fire(EventName.REWARD_FLY, list, point, null, null, 0, 0)
        }
        this.InitView = () => {
            _count = 0
            if (_time_down) {
                if (!this.timer) {
                    this.timer = GlobalTimerQuest.AddPeriodQuest(this.OnTimer, 1)
                }
                this.OnTimer()
            }
            if (this._gp_effect.numChildren == 0){
                let pos= { x: -4.1, y: -0.3 }
                let scale =2.5
                this.AddUIEffect("UI_2106", this._gp_effect, pos,scale, true)
            }

            if (_special_url) {
                res_mgr.SetTexture(this, this._special, _special_url)
                return
            }
            if (!_reward) return
            if (!this.reward_item) {
                this.reward_item = new EquipmentItem(this._gp_item)
                this.reward_item.Load()
            }
            this.reward_item.ExcuteCallback(() => {
                this.reward_item.SetData(_reward[0], _reward[1])
            })
        }

        this.OnTimer = () => {
            _count++
            if (_count == 1) {
                this.click_bg_toClose = true
            }
            if (_count % 2 != 0) return
            this._lb_time.text = `点击任意空白处关闭(${_time_down})`
            _time_down--
            if (_time_down < 0) {
                if(this.timer)
                {
                    GlobalTimerQuest.CancelQuest(this.timer)
                }
                this.timer = null
                this.Close()
            }
        }

        this.SetData = (reward, time_down) => {
            _reward = reward
            _time_down = time_down
        }

        this.SetSpecialImg = (url) => {
            _special_url = url
        }

        this.DestroyCallback = () => {
            this.ClearUIEffect(this._gp_effect)
            GlobalEventSystem.Fire(EventName.CONGRA_RARE_VIEW)
            if(this.timer)
            {
                GlobalTimerQuest.CancelQuest(this.timer)
            }
            this.timer = null
            if (this.reward_item) {
                this.reward_item.DeleteMe()
                this.reward_item = null
            }
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }
    public GetComponents() {
        [
            this._img_matrix,
            this._gp_effect,
            this._img_horn_right,
            this._img_horn_left,
            this._img_leaf_right,
            this._img_leaf_left,
            this._img_top,
            this._lb_time,
            this._gp_item,
            this._special,
        ]
            = this.GetChildrenByNames([

                "_img_matrix",
                "_gp_effect",
                "_img_horn_right",
                "_img_horn_left",
                "_img_leaf_right",
                "_img_leaf_left",
                "_img_top",
                "_lb_time",
                "_gp_item",
                "_special",
            ])
    }
}
window["CongratulationRareView"] = CongratulationRareView