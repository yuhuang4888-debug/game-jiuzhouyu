import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { table } from "../common/table";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { ErlangParser } from "../util/ErlangParser";

export class BindJageRewardItem extends BaseItemRenderer {
    WIDTH = 474
    HEIGT = 136

    _lab_desc: Laya.Label
    _gp_rew: Laya.HBox
    item_list
    public constructor() {
        super();
        this.base_file = "bindJageWish";
        this.layout_file = "BindJageRewardItem";
        this.item_list = []
        this.Load()
    }
    public createChildren() {
        super.createChildren()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data) {
                this._lab_desc.text = this.data[0].desc
                table.sort(this.data, (a, b) => {
                    return a.grade > b.grade
                })
                for (let i = 0, l = this.data.length; i < l; i++) {
                    let cond = ErlangParser.GetInstance().Parse(this.data[i].condition)
                    let multiple = 1
                    if (cond) {
                        for (let item of cond) {
                            if (item[0] == "times") {
                                multiple = Number(item[1])
                                break
                            }
                        }
                    }
                    let rew = ErlangParser.GetInstance().Parse(this.data[i].reward)
                    let item = this.item_list[i]
                    if (!item) {
                        item = new EquipmentItem(this._gp_rew)
                        this.item_list[i] = item
                        item.Load()
                        item.SetItemSize(75, 75)
                    }
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rew[0][0], rew[0][1])
                    item.SetData(type_id, rew[0][2] * multiple)
                }
            }
        }
    }

    public DeleteMe() {
        if (this.item_list) {
            for (let item of this.item_list) {
                item.DeleteMe()
            }
            this.item_list = []
        }
        super.DeleteMe()
    }
    public GetComponents() {
        [
            this._lab_desc,
            this._gp_rew,
        ]
            = this.GetChildrenByNames([

                "_lab_desc",
                "_gp_rew",
            ])
    }
}
window["BindJageRewardItem"] = BindJageRewardItem