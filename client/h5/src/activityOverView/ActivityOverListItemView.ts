import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ItemInfoItem } from "../common/ItemInfoItem";
import { ActivityOverItem } from "./ActivityOverItem";

export class ActivityOverListItemView extends BaseItemRenderer {
    WIDTH = 570
    HEIGT = 330
    item_box: Laya.HBox

    _reward_item_list
    public constructor() {
        super();
        this.base_file = 'activityOverView';
        this.layout_file = 'ActivityOverListItemView';
        this._reward_item_list = []
        this.Load()
    }
    public createChildren() {
        super.createChildren()
    }
    public dataChanged() {
        if (!super.dataChanged()) return
        for (let i = 0; i < 3; i++) {
            let item: ActivityOverItem = this._reward_item_list[i]
            if (!item) {
                item = new ActivityOverItem(this.item_box)
                item.Load()
                this._reward_item_list.push(item)
            }
            item.SetData(this.data[i])
        }
    }
    public DeleteMe() {
        if (this._reward_item_list) {
            for (let item of this._reward_item_list) {
                item.DeleteMe()
            }
            this._reward_item_list = []
        }
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this.item_box,
        ]
            = this.GetChildrenByNames([

                "item_box",
            ])
    }
}
window["ActivityOverListItemView"] = ActivityOverListItemView