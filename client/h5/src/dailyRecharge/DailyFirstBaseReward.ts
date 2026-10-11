import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { table } from "../common/table"
import { AtlasUrl, SetLocalPosition } from "../util/Util"
export class DailyFirstBaseReward extends BaseItemRenderer {
    _img_bg: Laya.Image
    _lb_name: Laya.Label
    _img_red: Laya.Image
    WIDTH = 95
    HEIGT = 95
    rare = false

    public constructor(parent) {
        super()


        this.base_file = "dailyRecharge"
        this.layout_file = "DailyFirstBaseReward"
        this.load_callback = () => {


        }
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            this.CreateAwardItem(data.type_id,data.good_num,data.lock,data.rare)
        }
    }





    public CreateAwardItem(type_id?, good_num?, lock?, rare?) {
        let item: BaseAwardItem
        if (!item) {
            item = new BaseAwardItem(this.item)
            //item.SetUseMask(true)
            //item.SetCacheSortOrder(cur_sorting_order)
            item.Load()
            item.SetItemSize(95, 95)
            item.SetShowEffect(true)
            this.rare = rare
        }
        item.ExcuteCallback(() => {
            item.SetData(type_id, good_num, lock, null, null, false)
            item.SetVisible(true)
            let img1: Laya.Image = <Laya.Image>item.display_obj.getChildByName("rare_img")
            if (this.rare) {
                if (img1) {
                    img1.visible = true
                } else {
                    let img = new Laya.Image()
                    img.skin = AtlasUrl("dailyRecharge", "uilz_002")
                    img.mouseEnabled = false
                    img.name = "rare_img"
                    item.display_obj.addChild(img)
                    SetLocalPosition(img, 7.5, 7.1, 0)
                    //this.CoverEffect(img,this.layer_value)
                }
            } else if (img1) {
                img1.visible = false
            }
        }
        )
    }


    item: Laya.Box
    public GetComponents() {
        [
            this.item,
        ]
            = this.GetChildrenByNames([

                "item",
            ])
    }
}
window["DailyFirstBaseReward"] = DailyFirstBaseReward