
import { UIEffect } from "../common/UIEffect"
import { ResManager } from "../common/ResManager";
import { BaseItem1 } from "../common/BaseItem1";
import { GameResPath } from "../util/GameResPath";
export class ProgressBar2 extends BaseItem1 {

    public static POOL = []
    bg_width
    bg_height

    curr_value
    max_value

    ab_name
    bg_img_name
    front_img_name

    font_size
    rect_off

    bar_width

    need_refresh_front_img

    public constructor(parent, max_value?, curr_value?, width?, height?, ab_name?, bg_img_name?, front_img_name?, rect_off?, font_size?) {
        super(parent);
        this.base_file = "uiComponent"
        this.layout_file = "ProgressBar2"
        this.load_callback = () => {
            this.InitData(max_value, curr_value, width, height, ab_name, bg_img_name, front_img_name, rect_off, font_size)
            this.LoadSuccess()
        }
    }

    public InitData(max_value?, curr_value?, width?, height?, ab_name?, bg_img_name?, front_img_name?, rect_off?, font_size?) {

        this.max_value = max_value || 100 //最大值
        this.curr_value = curr_value || 1 //当前值
        this.bg_width = width || 66 //背景图片宽度
        this.bg_height = height || 8 //背景图片高度

        this.ab_name = ab_name || "uiComponent_asset"
        this.bg_img_name = bg_img_name //背景图片名字  统一放在uicomponent里
        this.front_img_name = front_img_name //前景图片名字

        this.rect_off = rect_off || { x: 1, y: 1 }//前景与背景的偏移量
        this.font_size = font_size //字体大小 默认不显示
    }

    public LoadSuccess() {

        if (this.font_size) {
            this._lb_content.visible = true
            this._lb_content.style.fontSize = this.font_size
            // this._lb_content.size
        }

        if (this.bg_img_name) {
            ResManager.GetInstance().SetImageSprite(this, this._img_bg, this.ab_name, this.bg_img_name)
            ResManager.GetInstance().SetImageSprite(this, this._img_front, this.ab_name, this.front_img_name)
        }

        this._img_bg.width = this.display_obj.width = this.bg_width
        this._img_bg.height = this.display_obj.height = this.bg_height

        this._img_front.width = this.display_obj.width - 2 * this.rect_off.x
        this._img_front.height = this.display_obj.height - this.rect_off.y * 2

        this._img_front.x = this.rect_off.x
        this._img_front.y = this.rect_off.y

        this.bar_width = this._img_front.width

        this.display_obj.anchorX = 0.5

        this.display_obj.x = 3


        this.SetValue()
        if (this.need_refresh_front_img) {
            this.SetFrontImageStyle(this.front_img_name)
            this.need_refresh_front_img = false
        }

    }

    public SetValue(value?, max_value?) {
        
        if(value == undefined){
            value = this.curr_value || 0
        }
        this.curr_value = value

        this.max_value = max_value || this.max_value || 100
        this.curr_value = Math.min(this.curr_value, this.max_value)
        if (this.is_loaded) {
            if (this.font_size) {
                this._lb_content.innerHTML = this.curr_value + "/" + this.max_value
            }
            let rate = this.curr_value / this.max_value
            this._img_front.width = rate * this.bar_width
        }
    }

    public SetFrontImageStyle(front_img_name?) {

        this.front_img_name = front_img_name
        if (this.is_loaded)
            ResManager.GetInstance().SetImageSprite(this, this._img_front, this.ab_name, this.front_img_name)
        else
            this.need_refresh_front_img = true
    }

    //回收进缓存池
    public Recover()
    {
        if(this.display_obj && this.display_obj.parent)
        {
            this.display_obj.removeSelf()
            ProgressBar2.POOL.push(this)
        }
    }

    public static create(parent, max_value?, curr_value?, width?, height?, ab_name?, bg_img_name?, front_img_name?, rect_off?, font_size?) {
        let cache:ProgressBar2 = ProgressBar2.POOL.shift()
        if(cache)
        {
            if(cache.display_obj)
            {
                parent.addChild(cache.display_obj)
                cache.InitData(max_value, curr_value, width, height, ab_name, bg_img_name, front_img_name, rect_off, font_size)
                cache.LoadSuccess()
            }else
            {
                cache.load_callback = () => {
                    cache.InitData(max_value, curr_value, width, height, ab_name, bg_img_name, front_img_name, rect_off, font_size)
                    cache.LoadSuccess()
                }
            }
            return cache
        }else
        {
            return new ProgressBar2(parent, max_value, curr_value, width, height, ab_name, bg_img_name, front_img_name, rect_off, font_size)
        }
    }

    _img_bg: Laya.Image
    _img_front: Laya.Image
    _lb_content: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._img_bg,
            this._img_front,
            this._lb_content,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_front",
                "_lb_content",
            ])
    }
}
window["ProgressBar2"] = ProgressBar2