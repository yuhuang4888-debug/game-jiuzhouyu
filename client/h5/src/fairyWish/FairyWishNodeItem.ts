import { BaseItem1 } from "../common/BaseItem1";
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class FairyWishNodeItem extends BaseItem1 {
    need_refresh_data
    node
    fairy_model
    radius = 300 //圆半径
    cricleX = 330
    cricleY = 22
    private _angle
    public pos
    public curr_list_index = 2
    public constructor(parent) {
        super(parent);
        this.base_file = 'fairyWish';
        this.layout_file = 'FairyWishNodeItem';
        this.need_refresh_data = false
        this.fairy_model = FairyWishModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
            this.SetBg();

        }
    }


    private SetBg(){
        this._bg2.visible = this._angle != 90
        this._bg.visible = this._angle == 90
    }

    
    private InitEvent = () => {
        Util.AddClickEvent(this._click, () => {
            this.fairy_model.Fire(FairyWishEvent.SELECT_NODE, this)
        }, this)
    }
    private LoadSuccess = () => {
        if (this.need_refresh_data) {
            this.UpdateView()
            this.need_refresh_data = false
        }
    }
    public SetData(node, curr_list_index) {
        this.node = node
        this.curr_list_index = curr_list_index
        if (this.is_loaded) {
            this.UpdateView()
        }
        else
            this.need_refresh_data = true
    }

    public set angle(value: number) {
        this._angle = value
        let radian = value * Math.PI / 180
        let x = Math.cos(radian) * this.radius + this.cricleX
        let y = Math.sin(radian) * this.radius + this.cricleY
        this.SetPosition(x, y)
        if (value < 0 || value > 180) {
            this.SetScale(0.4)
        } else {
            this.SetScale(0.6 * Math.abs(Math.sin(radian)) + 0.4)
        }

        if (this.is_loaded) {
            this.SetBg();
        }

    }

    public get angle(): number {
        return this._angle
    }

    private UpdateView() {
        if (this.node) {
            let res
            let fairy_info = this.fairy_model.getFairyInfoById(this.node.fairy_id) //仙灵信息
            if (fairy_info.is_buy == 1 && this.node.is_activate == 0) {
                res = this.node.type == 1 ? "ui_xlzf_004" : "ui_xlzf_003"
                this._img_red.visible = this.fairy_model.checkNodeIsCanActive(this.node.fairy_id, this.node.node_id)
            } else {
                res = this.node.type == 1 ? "ui_xlzf_002" : "ui_xlzf_005"
                this._img_red.visible = false
            }
            this._img_node.skin = GameResPath.GetIcon("fairyWish", res)
        }
    }

    public setRedVisible() {
        this._img_red.visible = false
        let res = this.node.type == 1 ? "ui_xlzf_004" : "ui_xlzf_003"
        this._img_node.skin = GameResPath.GetIcon("fairyWish", res)
    }

    _click: Laya.Box
    _bg2: Laya.Image
    _bg: Laya.Image
    _img_node: Laya.Image
    _img_select: Laya.Image
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._click,
            this._bg2,
            this._bg,
            this._img_node,
            this._img_select,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_click",
                "_bg2",
                "_bg",
                "_img_node",
                "_img_select",
                "_img_red",
            ])
    }
}
window["FairyWishNodeItem"] = FairyWishNodeItem