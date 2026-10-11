import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"

export class EyouAttentionItem extends BaseItemRenderer {
    WIDTH = 720
	HEIGT = 285

    item_list
    public constructor() {
        super()
        this.base_file = "eyou"
        this.layout_file = "EyouAttentionItem"
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.Load()
    }

    public LoadSuccess() {
        //resource/game/eyou/texture/ui_img_ptgz_004.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("eyou", "ui_img_ptgz_004"))

        this._html_desc.style.color = "#ffffff"
        this._html_desc.style.fontSize = 20
        this._html_desc.style.wordWrap = true
    }

    public dataChanged() {
		if (!super.dataChanged()) return
        let data = this.data
		if (data) {
            this._lb_title.text = data.follow_name
			this._html_desc.innerHTML = data.desc
            this._html_desc.width = 471

			this._img_icon.skin = GameResPath.GetIcon("eyou", data.icon_name)
            if(!this.item_list){
                this.item_list = []
            }
			let list = data.reward_list
			for (let i in list) {
				let vo = list[i]
				let item: EquipmentItem = this.item_list[i]
				if (!item) {
					item = new EquipmentItem(this._panel_reward)
					item.SetItemSize(85)
					item.Load()
					this.item_list[i] = item
				}
                item.SetPosition(Number(i) * 105, 0)
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (basic) {
					item.SetData(type_id, vo[2])
				}
			}
		}

	}

    public DeleteMe() {
        if (this.item_list) {
			for (let item of this.item_list) {
				item.DeleteMe()
			}
			this.item_list = null
		}
        super.DeleteMe()
    }

    _box_con: Laya.Box
    _img_bg: Laya.Image
    _lb_title: Laya.Label
    _html_desc: Laya.HTMLDivElement
    _img_icon: Laya.Image
    _panel_reward: Laya.Panel
    public GetComponents() {
        [
            this._box_con,
            this._img_bg,
            this._lb_title,
            this._html_desc,
            this._img_icon,
            this._panel_reward,
        ]
            = this.GetChildrenByNames([

                "_box_con",
                "_img_bg",
                "_lb_title",
                "_html_desc",
                "_img_icon",
                "_panel_reward",
            ])
    }
}
window["EyouAttentionItem"] = EyouAttentionItem