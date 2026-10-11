import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { TeamHallItem } from "../team/TeamHallItem"


export class VipAwardItem extends BaseItem1 {

    data
    height
    needRefresh
    AwardItem
    need_update
    type_id
    goods_num
    is_lock
    color
    need_unpdate_color
    is_clear
    public static Height = 60;
    public constructor(parent?, prefab_asset?, layer_value?, show_tips?, save_by_batch?) {
        super(parent)

        this.base_file = "vip"
        this.layout_file = "VipAwardItem"
        this.load_callback = () => {
            this.AwardItem = new BaseAwardItem(this._item_box, prefab_asset, layer_value, show_tips, save_by_batch)
            this.AwardItem.Load()
            this.AwardItem.SetScale(0.7)
            if(this.need_update){
                this.AwardItem.SetData(this.type_id,this.goods_num,this.is_lock)
            }
            if(this.need_unpdate_color){
                this.AwardItem.SetBoxEffect(this.color)
            }
            if(this.is_clear){
                this.AwardItem.ClearBoxEffect()
            }
        }
    }

    public SetData(type_id?, goods_num?, is_lock?, select?, show_getIcon?, not_show_effect?, rating?, equip_extra_attr?, goods_id?, lv?, god_lv?, effect_callback?) {
        this.type_id=type_id
        this.goods_num=goods_num
        this.is_lock=is_lock
        if(this.AwardItem){
            this.AwardItem.SetData(type_id, goods_num, is_lock, select, show_getIcon, not_show_effect, rating, equip_extra_attr, goods_id, lv, god_lv, effect_callback)
        }else{
            this.need_update=true
        }
    }

    public SetBoxEffect(color?) {
        this.color=color
        if(this.AwardItem){
            this.AwardItem.SetBoxEffect(this.color)
        }else{
            this.need_unpdate_color=true
        }

    }

    public ClearBoxEffect() {
        if(this.AwardItem){
            this.AwardItem.ClearBoxEffect()
        }else{
            this.is_clear=true
        }
    }


    _item_box: Laya.Box
    public GetComponents() {
        [
            this._item_box,
        ]
            = this.GetChildrenByNames([

                "_item_box",
            ])
    }
}
window["VipAwardItem"]=VipAwardItem