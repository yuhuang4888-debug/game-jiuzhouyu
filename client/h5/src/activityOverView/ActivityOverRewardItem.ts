import { EquipmentIcon } from "../bag/EquipmentIcon";
import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";

export class ActivityOverRewardItem extends BaseItem1 {
    _rew: Laya.Box
    _img_gain: Laya.Image

    _type_id
    _param
    need_refresh_data
    _reward_item
    public constructor(parent) {
        super(parent);
        this.base_file = 'activityOverView';
        this.layout_file = 'ActivityOverRewardItem';
        this.need_refresh_data = false
        this.load_callback = () => {
            LoadCallback()
            InitEvent()
        }
        let LoadCallback = () => {
        }
        let InitEvent = () => {
        }
        this.DeleteMe = () => {
            super.DeleteMe();
        };

    }
    public SetData = (id, param) => {
        this._type_id = id
        this._param = param
        if (this.is_loaded) {
            this.UpdateInfo()
        }
        else
            this.need_refresh_data = true
    }
    private UpdateInfo() {
        if (!this._type_id || !this._param) return
        let item: EquipmentItem = this._reward_item
        if (!item) {
            item = new EquipmentItem(this._rew)
            item.Load()
            item.SetItemSize(95, 95)
            this._reward_item = item
        }
        item.ExcuteCallback(() => {
            item.SetData(this._type_id, this._param)
        })

    }
    public SetGainImg(bool?){
        this._img_gain.visible = bool
    }
    public DeleteMe() {
        if (this._reward_item) {
            this._reward_item = null
        }
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._rew,
            this._img_gain,
        ]
            = this.GetChildrenByNames([

                "_rew",
                "_img_gain",
            ])
    }
}
window["ActivityOverRewardItem"] = ActivityOverRewardItem