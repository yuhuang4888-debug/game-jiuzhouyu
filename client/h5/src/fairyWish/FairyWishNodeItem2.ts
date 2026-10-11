import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class FairyWishNodeItem2 extends BaseItemRenderer {
    need_refresh_data
    fairy_model

    WIDTH = 157
    HEIGT = 330
    public static ITEM_WIDTH = 157
    pos_obj
    pos_x
    is_center = false
    is_select = false
    public constructor(parent) {
        super();
        this.base_file = 'fairyWish';
        this.layout_file = 'FairyWishNodeItem2';
        this.need_refresh_data = false
        this.fairy_model = FairyWishModel.GetInstance()
        this.load_callback = () => {
            this.InitEvent();
            this.SetBg(this.is_center, this.is_select)

            this.BindEvent( this.fairy_model, FairyWishEvent.UPDATE_NODE, (node_id?) => {
                if (this.data) { 
                    this.UpdateNode()
                }

            })
            this.BindEvent( this.fairy_model, FairyWishEvent.UPDATE_FAIRY_BUY, () => {
                if (this.data) { 
                    this.UpdateNode()
                }
            })
        }

        this.Load()
    }


    public dataChanged() {
        if (!super.dataChanged()) return


        this.UpdateNode()
        this.UpdateItemPos(this.pos_obj)
    }

    public UpdateNode(){
        if (this.data && this.data["fake"]) {
            this.display_obj.visible = false
            return
        }
        this.display_obj.visible = true

        //更新数据
        let list_ =  this.fairy_model.getNodeInfoByFairyId(this.data.fairy_id)
        for (let i = 0;i<list_.length;i++) {
            if (list_[i].node_id == this.data.node_id) {
                this.data.is_activate = list_[i].is_activate
                this.data.combat = list_[i].combat
                break;
            }
        }


        let res
        let fairy_info = this.fairy_model.getFairyInfoById(this.data.fairy_id) //仙灵信息
        if (fairy_info.is_buy == 1 && this.data.is_activate == 0) {
            res = this.data.type == 1 ? "ui_xlzf_004" : "ui_xlzf_003"
            this._img_red.visible = this.fairy_model.checkNodeIsCanActive(this.data.fairy_id, this.data.node_id)
        } else {
            res = this.data.type == 1 ? "ui_xlzf_002" : "ui_xlzf_005"
            this._img_red.visible = false
        }
        this._img_node.skin = GameResPath.GetIcon("fairyWish", res)

        this._lb_text.text = `${this.index}`
    }


    public UpdateItemPos(pos_obj) {
        if (!pos_obj) return
        this.pos_obj = pos_obj
        if (!this.is_loaded || !this.data) return

        //位置
        let pos_x = this.GetItemPos()
        let pos_value = pos_x - this.pos_obj.center_x
        let abs_v = Math.abs(pos_value) //离中心点的距离
        let scale_percent = 1
        if (pos_value != 0) {
            scale_percent = (1 - abs_v / this.pos_obj.gap_v)
        }

        // //缩放范围限制
        let max_scale = 1
        let min_scale = 0.4
        let real_scale = scale_percent * (max_scale - min_scale) + min_scale

        this._click.scaleX = this._click.scaleY = real_scale
        // this._click.scaleX = this._click.scaleY = 1
        
        let duan_half = 320
        let chang_half = 250

        let center_x = 0
        let center_y = 0

        let angle_scale = 0
        let left_angle = 180 - angle_scale
        let right_angle = 0 + angle_scale


        let center_angle = 90
        let angle = center_angle
       
        let dis_scale = abs_v / this.pos_obj.gap_v 

        angle = dis_scale * center_angle
        if (pos_x < this.pos_obj.center_x){
            angle = -angle
        }

        let [x1, y1] = this.GetPointOnEllipse(
            {"x":center_x,"y":center_y},
            chang_half, //决定水平间距 值越小越收缩
            duan_half,//决定垂直高度 值越小越往上
            this.ToRad(angle),
            this.ToRad(0),
            )
        
        // 76.5锚点偏移
        let local_x = y1 + this.pos_obj.center_x - pos_x + 76.5
        // 20偏移
        let local_y = x1 + (chang_half - this.display_obj.height - 20)

        this._click.x = local_x
        this._click.y = local_y

    }

    /**
     * 
     * @param ptCenter             椭圆中心
     * @param a                    椭圆长轴长度
     * @param b                    椭圆短轴长度
     * @param radian               点于椭圆长轴夹角的弧度
     * @param dChangZhouAngle      长轴弧度
     * @returns 
     */
    private GetPointOnEllipse(ptCenter, a, b, radian, dChangZhouAngle) {
        let dLiXin = Math.atan2(a * Math.sin(radian), b * Math.cos(radian));//离心角
        let x = a * Math.cos(dLiXin) * Math.cos(dChangZhouAngle) - b * Math.sin(dLiXin) * Math.sin(dChangZhouAngle) + ptCenter.x;
        let y = a * Math.cos(dLiXin) * Math.sin(dChangZhouAngle) + b * Math.sin(dLiXin) * Math.cos(dChangZhouAngle) + ptCenter.y;
        return [x, y]
    }

    private ToRad(angle){
        return  (angle * Math.PI) / 180
    }

    public GetItemNodeId() {
        if (!this.data) return 0
        return this.data.node_id
    }


    public SetBg(is_center, is_select?) {
        this.is_center = is_center
        this.is_select = is_select
        if (!this.is_loaded) return
        this._bg2.visible = !is_center
        this._bg.visible = is_center
        if (is_select) {
            this.fairy_model.Fire(FairyWishEvent.SELECT_NODE, this.data)
        }
    }


    private InitEvent() {
        // Util.AddClickEvent(this._click, () => {
        //     if (this.data) {
        //         this.fairy_model.Fire(FairyWishEvent.SELECT_NODE, this.data)
        //     }
        // }, this)
    }

    public setRedVisible() {
        this._img_red.visible = false
        let res = this.data.type == 1 ? "ui_xlzf_004" : "ui_xlzf_003"
        this._img_node.skin = GameResPath.GetIcon("fairyWish", res)
    }

    public GetItemPos() {
        this.pos_x = this.index * this.WIDTH + this.index * this.pos_obj.spaceX
        return this.pos_x;
    }

    public GetItemIndex() {
        return this.index
    }


_click:Laya.Box
_bg2:Laya.Image
_bg:Laya.Image
_img_node:Laya.Image
_img_select:Laya.Image
_img_red:Laya.Image
_lb_text:Laya.Label
public GetComponents() {
[
this._click,
this._bg2,
this._bg,
this._img_node,
this._img_select,
this._img_red,
this._lb_text,
]
 = this.GetChildrenByNames([

"_click",
"_bg2",
"_bg",
"_img_node",
"_img_select",
"_img_red",
"_lb_text",
])
}
}
 window["FairyWishNodeItem2"]= FairyWishNodeItem2