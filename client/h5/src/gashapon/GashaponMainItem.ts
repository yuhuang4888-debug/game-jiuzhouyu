import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ParticleManager } from "../particalEffect/ParticleManager"
import { PlatformManager } from "../PlatformManager"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetSizeDeltaX, Util, GlobalTimerQuest } from "../util/Util"

export class GashaponMainItem extends BaseItem1 {
    item_group: Laya.Box
    _color: Laya.Image
    luck_bg: Laya.Image
    Text: Laya.Label
    _goodsmodel
    _item
    _model
    _status
    click_callback
    cover_trans
    cur_sorting_order
    data
    start_posY
    tween_id

    public constructor(parent) {
        super(parent)

        this._status = 0
        this.base_file = "gashapon"
        this.layout_file = "GashaponMainItem"
        this._model = CustomActivityModel.GetInstance()
        this._goodsmodel = GoodsModel.GetInstance()
        this.load_callback = () => {

            this.InitEvent()

            //this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value, 10)
            this.start_posY = this.display_obj.y
            let delay_time = Math.random() * 2// RandomRange(0, 200) / 100
            this.AddTween(delay_time)
            this.UpdateContent()
            if (PlatformManager.IsEyouEnPlatform()) {
                SetSizeDeltaX(this.Text, 35)
                this.Text.fontSize = 12
                this.Text.valign = "top"
                this.Text.align = "center"
            }
        }
    }

    Color2Img = [
        "hbnd_004",   // 绿色
        "hbnd_007",
        "hbnd_003",
        "hbnd_002",
        "hbnd_005",
        "hbnd_002",   // 新加暗金色
        "hbnd_006",   // 粉色
    ]
    public InitEvent() {

        Util.AddClickEvent(
            this._color, () => {
                if (this._item) {
                    this._item.DefaultCallFun()
                }
            },
            this,
            true
        )
    }

    public SetClickCallback(click_callback?) {

        this.click_callback = click_callback
    }

    public DeleteMe() {

        this.ClearTween()
        if (this._item) {
            this._item.DeleteMe()
            this._item = null
        }
        super.DeleteMe()
    }

    public SetData(data?, cover_trans?, cur_sorting_order?) {

        this.data = data
        this.cover_trans = cover_trans
        this.cur_sorting_order = cur_sorting_order
        this.UpdateContent()
    }

    public CheckLoadItem() {

        if (!this._item) {
            //this._item =  new EquipmentItem(this.item_group, null, this.layer_value)
            this._item = new EquipmentItem(this.item_group, null, this.layer_value)

            let loadsuccess = this._item.LoadSuccess
            // this._item.LoadSuccess = () => {
            //     loadsuccess(this._item)
            //     this._item.click_group.mouseEnabled= false
            //     this._item.item_bg.mouseEnabled= false
            // }
            //this._item.SetUseMask(true)
            this._item.Load()
        }

        if (this.data) {
            let [type_id, lock] = this._goodsmodel.GetMappingTypeId(this.data[0], this.data[1])
            this._item.SetData(type_id, this.data[2])
            this._item.effect_callback = () => {
                if (this.cover_trans) {
                    // this.CoverEffect(this.cover_trans, this.layer_value, this.cur_sorting_order + 30)
                }
            }

            let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            let color = goods_basic.color
            if (color) {
                let sp_name = this.Color2Img[color - 1]
                ResManager.GetInstance().SetImageSprite(this, this._color, "gashapon_asset", sp_name)
            }
            this.luck_bg.visible = this.data.is_nice == 1
            this.Text.visible = this.data.is_nice == 1
        }
    }

    public AddTween(delay_time?) {

        this.ClearTween()
        if (!this.tween_id) {
            this.tween_id = true
            GlobalTimerQuest.AddDelayQuest(() => {
                if (this.use_delete_method) return
                this.tween_id = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POSY, this.start_posY + 5, 2, null, SYTweenFunc.PINGPONG, true)
            }, delay_time)
        }
    }

    public ClearTween() {

        if (this.tween_id) {
            SYTweenLite.Stop(this.tween_id)
            this.tween_id = null
        }
    }

    public UpdateContent() {

        if (!this.is_loaded) {
            return
        }
        if (!this.data) {
            return
        }

        this.CheckLoadItem()
    }



    public GetComponents() {
        [
            this.item_group,
            this._color,
            this.luck_bg,
            this.Text,
        ]
            = this.GetChildrenByNames([

                "item_group",
                "_color",
                "luck_bg",
                "Text",
            ])
    }
}
window["GashaponMainItem"] = GashaponMainItem