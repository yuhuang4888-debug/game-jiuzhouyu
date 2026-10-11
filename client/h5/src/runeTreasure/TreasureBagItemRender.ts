import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GoodsModel } from "../commonModel/GoodsModel";

export class TreasureBagItemRender extends BaseItemRenderer {
    public conta
    private item

    public WIDTH=86
    public HEIGT=84
    public constructor() {
        super();
        this.base_file = "runeTreasure"
        this.layout_file = "RuneTreasureAwardItem"
        this.Load()
        // this.skinName = "resource/game/runeTreasure/exml/RuneTreasureAwardItemExml.exml"
        // this.touchChildren = true;
    }

    public load_callback() {
        this.item = new BaseAwardItem(this.conta)
        this.item.Load()
        this.item.SetItemSize(86, 84)
        this.item.ExcuteCallback(() => {
            this.item.select_image.source = "bag_json.select_png"
            this.item.SetClickCallBack(() => {
                if (this.data && this.data.goods_id) {
                    let local_uitipMgr = UIToolTipMgr.GetInstance()
                    let goodVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(this.data.goods_id)
                    if (goodVo) {
                        goodVo.isTreasure = true
                        if (goodVo.type == 10) {
                            local_uitipMgr.AppendEquipTips(goodVo.type_id, null, null, goodVo, null, [10])
                        } else {
                            local_uitipMgr.AppendGoodsTips(goodVo.type_id, null, null, goodVo)
                        }
                    }
                }
            })
        })
    }

    protected dataChanged(): void {
        if (super.dataChanged()) {
            let self = this
            // if (!self.item) {
                if (self.data && self.data.type_id) {
                    self.item.SetData(self.data.type_id, self.data.goods_num)
                } else {
                    self.item.SetData(undefined)
                }
            // }
        }
    }

    public DeleteMe() {
        let self = this
        if (self.item) {
            self.item.DeleteMe()
            self.item = null
        }
        super.DeleteMe()
    }
    
	public GetComponents() {
		[
			this.conta,
		]
			= this.GetChildrenByNames([

				"conta",
			])
	}
}
window["TreasureBagItemRender"] = TreasureBagItemRender