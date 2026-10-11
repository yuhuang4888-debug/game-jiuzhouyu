import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Util } from "../util/Util";

export class FtvInvestRewardView extends BaseItem1 {
    _rew_box: Laya.Box
    _img_get: Laya.Image
    _img_red: Laya.Image
    _lab_day: Laya.Label

    data
    model
    need_refresh_data
    reward_item
    reward_type
    public constructor(parent?) {
        super(parent);
        this.base_file = 'ftvInvest';
        this.layout_file = 'FtvInvestRewardView';
        this.need_refresh_data = false
        this.model = CustomActivityModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        }
    }

    private InitEvent = () => {
        Util.AddClickEvent(this._rew_box, () => {
            if (!this.data) return
            if (this.data.status == 1) {
                this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.data.b, this.data.s, this.data.grade)
            } else if (this.reward_type) {
                UIToolTipMgr.GetInstance().DefaultAppendTips(this.reward_type, 0)
            }
        }, this, true)
    }
    private LoadSuccess = () => {
        if (this.need_refresh_data) {
            this.UpdateInfo()
            this.need_refresh_data = false
        }
    }
    public SetData(data) {
        this.data = data
        if (this.is_loaded) {
            this.UpdateInfo()
        }
        else
            this.need_refresh_data = true
    }

    private UpdateInfo() {
        if (this.data) {
            this._lab_day.text = this.data.desc
            let reward = this.model.GetActReward(this.data.b, this.data.s, this.data.form_type, this.data.reward)
            if (reward) {
                if (!this.reward_item) {
                    this.reward_item = new EquipmentItem(this._rew_box)
                    this.reward_item.Load()
                    this.reward_item.SetItemSize(77, 77)
                    this.reward_item.SetShowTips(false)
                }
                this.reward_item.ExcuteCallback(() => {
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
                    this.reward_type = type_id
                    this.reward_item.SetData(type_id, reward[0][2], lock)
                })
            }
            this._img_red.visible = this.data.status == 1 ? true : false
            this._img_get.visible = this.data.status == 2 ? true : false
        }
    }

    public DeleteMe() {
        if (this.reward_item)
            this.reward_item.DeleteMe()
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._rew_box,
            this._img_get,
            this._img_red,
            this._lab_day,
        ]
            = this.GetChildrenByNames([

                "_rew_box",
                "_img_get",
                "_img_red",
                "_lab_day",
            ])
    }
}
window["FtvInvestRewardView"] = FtvInvestRewardView