/*
 * @Descripttion: 
 * @Author: huoyijian
 * @Date: 2022-11-23 10:00:33
 * @LastEditTime: 2022-11-23 18:09:31
 */
import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { GameResPath } from "../util/GameResPath";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { SYTweenLite } from "../util/SYTweenLite";
import { Util } from "../util/Util";

export class EyouThAdultItem extends BaseItem1 {

    tween_list = []
    tween_type = 0
    _anim_type = 1  //默认1
    constructor(parent?) {
        super(parent);
        this.base_file = "mainUI"
        this.layout_file = "EyouThAdultItem"
        this.load_callback = () => {
            this.Init()
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetIconOtherPath("mainUI", "eyou_th_18"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._box_arrow, GameResPath.GetIconOtherPath("mainUI", "eyou_th_bg"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_red, GameResPath.GetIconOtherPath("mainUI", "eyou_th_txt"))


            Util.AddClickEvent(this._img_icon, () => {
                if (this._anim_type == 1) {
                    if (this.tween_type == 0) {
                        this.ScaleBig()
                    } else if (this.tween_type == 1) {
                        this.ScaleSamll()
                    }
                } else {
                    if (this.tween_type == 0) {
                        this.ScaleBigR()
                    } else if (this.tween_type == 1) {
                        this.ScaleSamllR()
                    }
                }

            }, this, false)

            Laya.stage.on(Laya.Event.MOUSE_DOWN, this, this.ClickEvent)

        }



    }

    private ClickEvent(e) {
        if (!e) return
        let target = e.target
        if (!target) return
        if (target.name != "_img_icon") {
            if(this._anim_type==1){
                this.ScaleSamll()
            }else{
                this.ScaleSamllR()
            }
        
        }
    }

    private Init() {
        if (this._anim_type == 1) {
            this._img_icon.scale(0.35, 0.35)
            this._img_icon.anchorX = 0.5
            this._img_icon.x = 40


            this._box_arrow.width = 69
            this._box_arrow.scale(1, 1)
            this._box_arrow.anchorX = 0
            this._box_arrow.right = NaN
            this._box_arrow.centerX = 0

            this._img_red.visible = false
            this._img_red.width = 0
            this._img_red.anchorX = 0
            this._img_red.x = -28
            this._img_red.anchorX = 0
            this._img_red.anchorY = 0

        } else {
            this._img_icon.scale(0.35, 0.35)
            this._img_icon.anchorX = 1
            this._img_icon.x = 70


            this._box_arrow.width = 69
            this._box_arrow.scale(1, 1)
            this._box_arrow.anchorX = 1
            this._box_arrow.centerX = NaN
            this._box_arrow.right = 6


            this._img_red.visible = false
            this._img_red.width = 0
            this._img_red.anchorX = 0
            this._img_red.anchorY = 0
            this._img_red.anchorX = 1
            this._img_red.x = -17



        }
        this.tween_type = 0
    }


    private ScaleSamll() {
        this.tween_type = 0
        this.ClearTween()

        //底图先缩小
        SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.WIDTH, 69, 0.15)

        //位移
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.POSX, 40, 0.15, () => {

                //再次缩小
                table.insert(this.tween_list,
                    SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.SCALE, { x: 1, y: 1 }, 0.2)
                )

                SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.SCALE, { x: 0.35, y: 0.35 }, 0.2)
            })
        )

        //文字消失
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._img_red, SYTweenLite.UiAnimationType.WIDTH, 0, 0.1, () => {
                this._img_red.visible = false
            })
        )

    }


    private ScaleBig() {
        this.tween_type = 1
        this.ClearTween()
        //先放大
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.SCALE, { x: 1.2, y: 1.2 }, 0.2)
        )
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.SCALE, { x: 0.45, y: 0.45 }, 0.2, () => {

                //底图继续放大
                SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.WIDTH, 220, 0.1)

                //位移
                table.insert(this.tween_list,
                    SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.POSX, -48.5, 0.1)
                )

                //文字出现
                this._img_red.visible = true
                table.insert(this.tween_list,
                    SYTweenLite.to(this, this._img_red, SYTweenLite.UiAnimationType.WIDTH, 271, 0.15)
                )


            })
        )
    }


    private ScaleSamllR() {
        this.tween_type = 0
        this.ClearTween()

        //底图先缩小
        SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.WIDTH, 69, 0.15)

        //再次缩小
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.SCALE, { x: 1, y: 1 }, 0.2)
        )

        SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.SCALE, { x: 0.35, y: 0.35 }, 0.2)

        //文字消失
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._img_red, SYTweenLite.UiAnimationType.WIDTH, 0, 0.1, () => {
                this._img_red.visible = false
            })
        )

    }


    private ScaleBigR() {
        this.tween_type = 1
        this.ClearTween()
        //先放大
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.SCALE, { x: 1.2, y: 1.2 }, 0.2)
        )
        table.insert(this.tween_list,
            SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.SCALE, { x: 0.45, y: 0.45 }, 0.2, () => {

                //底图继续放大
                SYTweenLite.to(this, this._box_arrow, SYTweenLite.UiAnimationType.WIDTH, 220, 0.1)


                //文字出现
                this._img_red.visible = true
                table.insert(this.tween_list,
                    SYTweenLite.to(this, this._img_red, SYTweenLite.UiAnimationType.WIDTH, 271, 0.15)
                )


            })
        )
    }

    private ClearTween() {
        for (let i = 0; i < this.tween_list.length; i++) {
            SYTweenLite.Stop(this.tween_list[i])
        }
        this.tween_list = []
    }

    public SetAnimType(anim_type) {
        this._anim_type = anim_type
    }

    DeleteMe() {
        Laya.stage.off(Laya.Event.MOUSE_DOWN, this, this.ClickEvent)
        this.ClearTween()
        super.DeleteMe();
    }


    _img_icon: Laya.Image
    _box_arrow: Laya.Image
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._img_icon,
            this._box_arrow,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_img_icon",
                "_box_arrow",
                "_img_red",
            ])
    }
}
window["EyouThAdultItem"] = EyouThAdultItem