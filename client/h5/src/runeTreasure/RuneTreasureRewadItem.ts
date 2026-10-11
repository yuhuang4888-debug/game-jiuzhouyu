import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"

export class RuneTreasureRewadItem extends BaseItem1 {
    private gp_effect
    private gp_award
    gp_item: Laya.Box
    public award_item: BaseAwardItem
    private needRefresh
    private type_id
    private goods_num
    private lock
    constructor(parent) {
        super(parent)
        this.base_file = "runeTreasure"
        this.layout_file = "RuneTreasureRewadItem"
        this.is_delay_callback = false
        this.load_callback = function () {
            this.award_item = new EquipmentItem(this.gp_award)
            this.award_item.Load()
            if (this.needRefresh) {
                this.SetData(this.type_id, this.goods_num, this.lock)
                this.needRefresh = false
            }
        }
    }

    public SetData(type_id, goods_num, lock) {
        let self = this
        self.type_id = type_id
        self.goods_num = goods_num
        self.lock = lock
        if (self.is_loaded) {
            self.award_item.SetData(type_id, goods_num, lock)
        } else {
            self.needRefresh = true
        }
    }

    // public PlayAnimation(scale, time_add) {
    //     egret.Tween.get(self.gp_award).to({ scaleX: scale, scaleY: scale }, 0).wait(time_add / 3).to({ scaleX: 1, scaleY: 1 }, time_add / 2).call(() => {/* egret.Tween.removeTweens(self.gp_award) */ })
    //     egret.Tween.get(self.gp_award).to({ alpha: 0 }, 0).wait(time_add / 3).to({ alpha: 1 }, time_add / 2).call(() => {/* egret.Tween.removeTweens(self.gp_award)*/ })
    // }

    public AddEffect(scale) {
        let self = this
        self.AddUIEffect("ui_exposure_glow", self.gp_effect, null, scale, false)
    }

    public DeleteMe() {
        let self = this
        // egret.Tween.removeTweens(self.gp_award)
        self.ClearUIEffect(self.gp_effect)
        if (self.award_item) {
            self.award_item.DeleteMe()
        }
        self.award_item = null
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this.gp_item,
            this.gp_award,
            this.gp_effect,
        ]
            = this.GetChildrenByNames([

                "gp_item",
                "gp_award",
                "gp_effect",
            ])
    }
}

window["RuneTreasureRewadItem"] = RuneTreasureRewadItem