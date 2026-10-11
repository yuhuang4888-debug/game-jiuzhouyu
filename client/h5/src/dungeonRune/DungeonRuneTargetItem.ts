import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DungeonRuneTargetItem extends BaseItemRenderer {
    WIDTH = 606
	HEIGT = 122

    model:BaseDungeonModel
    item_list = []
    public constructor() {
        super()
        this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneTargetItem"
		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
    }

    public InitEvent = () => {
        Util.AddClickEvent(this._box_get, () => {
            if(this.data)
                this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61112, [{ dun_id: this.data.dun_id, reward_type: this.data.reward_type }])
        }, this, true)

        //this:BindEvent(this.model,BaseDungeonModel.GET_RUNE_DUN_REWARD,(dun_id?) => {
        //if (this.data &&  dun_id == this.data.dun_id ) {
        //this:changeFun()
        //}
        //})
    }

    public LoadSuccess = () => {
        this._img_bg.skin = GameResPath.GetIcon("dungeonRune", "ui_activity_02")
        // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonRune", "ui_activity_02"))
        this._panel_item.hScrollBarSkin = ""

        this._html_desc.style.fontSize = 22
		this._html_desc.style.color = "#663915"
		this._html_desc.style.leading = 5
        this._html_desc.style.align = "center"

        this.InitEvent()
    }

    public dataChanged = () => {
        if (super.dataChanged()) {
            let reward_list = ErlangParser.GetInstance().Parse(this.data.reward)[0][1][1], reward
            for (let i in reward_list) {
                reward = reward_list[i]
                let item = this.item_list[i]
                if (!item) {
                    item = new BaseAwardItem(this._panel_item)
                    item.SetScale(0.72)
                    item.Load()
                    this.item_list[i] = item
                    // table.insert(this.item_list, item)
                }
                
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
                let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (vo) {
                    item.SetData(type_id, reward[2])
                }
                item.SetVisible(true)
                item.SetPosition(Number(i) * 98, 0)
            }

            let j = this.item_list.length
            if (j > reward_list.length) {
                do {
                    let item = this.item_list[j - 1]
                    item.SetVisible(false)
                    j = j - 1
                } while ((j > reward_list.length)
                )
            }

            if (PlatformManager.IsEyouIdnPlatform()) {
                this._html_desc.innerHTML = this.data.desc
            } else {
                this._html_desc.innerHTML = this.data.desc
            }
            this.CallLater(()=>{
                this._html_desc.width =  88
                this._html_desc.height = 300
            })
            this.changeFun()
        }
    }

    public changeFun = () => { 
        let data = this.model.GetRuneRewardData(this.data.dun_id)
        this._img_get_red.visible = data && data.reward_status == 0
        this._img_received.visible = data && data.reward_status == 1
        this._box_get.visible = !this._img_received.visible
        if (this._box_get.visible) {
            let can_get = data && data.reward_status == 0
            Util.SetImageGray(this._box_get, !can_get)
            this._lb_get.text = can_get && "领取" || "未达成"
            this._box_get.mouseEnabled = can_get
        }
    }

    public DeleteMe() {
        for (let i in this.item_list) {
            var item = this.item_list[i]
            item.DeleteMe()
        }
        this.item_list = []
        super.DeleteMe()
    }

    _img_bg: Laya.Image
    _html_desc: Laya.HTMLDivElement
    _panel_item: Laya.Panel
    _img_received: Laya.Image
    _box_get: Laya.Box
    _img_get: Laya.Image
    _lb_get: Laya.Label
    _img_get_red: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._html_desc,
            this._panel_item,
            this._img_received,
            this._box_get,
            this._img_get,
            this._lb_get,
            this._img_get_red,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_html_desc",
                "_panel_item",
                "_img_received",
                "_box_get",
                "_img_get",
                "_lb_get",
                "_img_get_red",
            ])
    }
}

window["DungeonRuneTargetItem"] = DungeonRuneTargetItem