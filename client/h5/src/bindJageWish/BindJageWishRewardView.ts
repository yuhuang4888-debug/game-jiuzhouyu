import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { Util } from "../util/Util";
import { BindJageRewardItem } from "./BindJageRewardItem";

export class BindJageWishRewardView extends BaseView1 {
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image4: Laya.Image
    _rew_list: Laya.List
    _btn_close: Laya.Image
    public constructor() {
        super();
        this.base_file = "bindJageWish";
        this.layout_file = "BindJageWishRewardView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.is_center = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        let _reward_list,
            _arrayCollection_: LoopScrowViewMgr
        this.load_callback = () => {
            if (!_reward_list) return
            LoadCallback()
        }
        this.Open = (parms?) => {
            if (parms) {
                _reward_list = parms;
            }
            super.Open();
        }
        let LoadCallback = () => {
            let dataList = []
            for(let key in _reward_list){
                dataList.push(_reward_list[key])
            }
            if (!_arrayCollection_) {
                _arrayCollection_ = new LoopScrowViewMgr();
                _arrayCollection_.SetData(this._rew_list, BindJageRewardItem, dataList, LoopScrCon.Vertical, 1)
            } else {
                _arrayCollection_.replaceAll(dataList);
            }
            Util.AddClickEvent(this._btn_close, () => { this.Close() }, this, true);
        }
        this.DeleteMe = () => {
            _reward_list = null
            super.DeleteMe()
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Image4,
            this._rew_list,
            this._btn_close,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Image4",
                "_rew_list",
                "_btn_close",
            ])
    }
}
window["BindJageWishRewardView"] = BindJageWishRewardView