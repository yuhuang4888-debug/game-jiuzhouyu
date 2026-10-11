import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Util } from "../util/Util";

export class RPRShowView extends BaseView1 {
    _img_bg: Laya.Image
    _img_tips: Laya.Image
    _btn_go: Laya.Image
    _lb_wave: Laya.Label
    _img_rpr: Laya.Image
    _img_over: Laya.Image
    _gp_item: Laya.Box
    img_wave: Laya.Image
    private _model: CustomActivityModel;
    private _item: EquipmentItem;
    private _status = 1;
    private _subtype;
    private _wave = 1;

    RPROpen
    Clear
    InitEvent
    UpdateView
    UpdateItem

    public constructor() {
        super();
        this.base_file = "redPacketRain"
        this.layout_file = "RPRShowView"
        this.layer_value = Enum_UILayer.Top
        this.destroy_imm = true
        this.use_background = true
        this.is_center = true
        this._model = CustomActivityModel.GetInstance()
        this.load_callback = function () {
            this.InitEvent()
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        this.open_callback = function () {
            this.UpdateView()
        }


        this.RPROpen = (...parms) => {
            //1开启 2.领取 3.抢完
            let data = CustomActivityModel.GetInstance().GetPRPCurData()
            if (!data) {
                this.Close()
            } else {
                // [this._subtype, this._wave] = parms
                this._subtype = data.sub_type
                this._wave = data.wave
                super.Open()
            }
        }

        this.Clear = () => {
            if (this._item) {
                this._item.DeleteMe()
                this._item = undefined
            }
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_go, () => {
                if (this._status == 1) {
                    this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33157, this._subtype)
                } else if (this._status == 2 || this._status == 3) {
                    this.Close()
                }
            }, this, true)

            this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_RED_PACKET, (scmd) => {
                if (scmd.errcode == 1) {//领取成功
                    this._status = 2
                    this.UpdateView(scmd)
                } else if (scmd.errcode == 3310071) { //抢完
                    this._status = 3
                    this.UpdateView(scmd)
                } else {
                    this.Close()
                }
            })
        }

        this.UpdateView = (scmd?) => {
            let pic = this._status == 1 ? "017" : "019"
            ResManager.GetInstance().SetImageSprite(this, this._img_bg, "redPacketRain", `uihby_${pic}`)
            if (this._status == 1) {
                ResManager.GetInstance().SetImageSprite(this, this._img_rpr, "redPacketRain", `rpr_0${this._wave}`)
                // this._img_rpr.source = `redPacketRain_json.rpr_0${scmd.wave}_png`
                ResManager.GetInstance().SetImageSprite(this, this._btn_go, "redPacketRain", `uihby_018`)
                this._lb_wave.text = `第${this._wave}波红包`
            } else if (this._status == 2) {
                ResManager.GetInstance().SetImageSprite(this, this._btn_go, "redPacketRain", `uihby_023`)
                ResManager.GetInstance().SetImageSprite(this, this._img_tips, "redPacketRain", `uihby_021`)
                this.UpdateItem(scmd && scmd.goods_list[0])
            } else if (this._status == 3) {
                ResManager.GetInstance().SetImageSprite(this, this._btn_go, "redPacketRain", `uihby_023`)
                ResManager.GetInstance().SetImageSprite(this, this._img_tips, "redPacketRain", `uihby_024`)
            }
            this._lb_wave.visible = this._status == 1
            this.img_wave.visible = this._status == 1
            this._img_tips.visible = this._status != 1
            this._gp_item.visible = this._status == 2
            this._img_over.visible = this._status == 3
            this._img_rpr.visible = this._status == 1
        }

        this.UpdateItem = (vo) => {
            if (!vo) return
            if (!this._item) {
                this._item = new EquipmentItem(this._gp_item)
                this._item.Load()
                this._item.SetItemSize(86, 86)
            }
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
            this._item.SetData(type_id, vo.count, lock)
        }
    }

    public Open(...parms) {
        this.RPROpen(parms)
    }

    public GetComponents() {
        [
            this._img_bg,
            this._img_tips,
            this._btn_go,
            this._lb_wave,
            this._img_rpr,
            this._img_over,
            this._gp_item,
            this.img_wave
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_tips",
                "_btn_go",
                "_lb_wave",
                "_img_rpr",
                "_img_over",
                "_gp_item",
                "img_wave"
            ])
    }
}
window["RPRShowView"] = RPRShowView