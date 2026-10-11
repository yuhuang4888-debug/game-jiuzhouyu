import { BaseItem1 } from "../common/BaseItem1";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { ChatModel } from "../commonModel/ChatModel";
// import { StoryAnimationModel } from "../storyAnimation/StoryAnimationModel";
import { LoginModel } from "../login/LoginModel";
import { Util } from "../util/Util";
import { SysInfoChuanwenMgr } from "./SysInfoChuanwenMgr";
export class ChuanwenItem extends BaseItem1 {
    private _lb_content: Laya.Label;
    private _lb_content_html: Laya.HTMLDivElement;
    private _img_bg: Laya.Image
    // private has_text = false
    private total_time = 0.3 * 1000;
    private item_width = 700;
    private item_height = 30;
    private need_refresh=false
    private msg=null
    private wait_time=2000
    public constructor(parent) {
        super(parent);
        this.base_file = "sysInfo";
        this.layout_file = "ChuanwenItem";
        this.is_delay_callback = false;
        this.load_callback = function () {
            this.display_obj.visible = false;
            this.display_obj.y = 220;
            this.display_obj.centerX=0
            if(this.need_refresh){
                this.AppendMessage(this.msg)
            }
        };
    }
    public AppendMessage(content) {
        if(this.is_loaded){
            this.RunMessage(content);
            this.need_refresh=false
        }else{
            this.msg=content
            this.need_refresh=true
        }
    }
    private RunMessage(content) {
        if (!content)
            return;
        this._lb_content_html.style.color = "#FFFFFF";
        this._lb_content_html.style.fontSize = 22;
        this._lb_content_html.style.leading=4
        this._lb_content.text = ""
        let label = this._lb_content_html
        content = content.replace(/\n/g, "");
        content=ChatModel.GetInstance().disposeChtaFace(content,null,null,22)
        this._lb_content_html.innerHTML = content
        this._lb_content_html.width = 500
        this._lb_content_html.x = 350 - (this._lb_content_html.contextWidth / 2)
        this.display_obj.height=this._lb_content_html.contextHeight+14
        this._lb_content_html.y = 8
        SysInfoChuanwenMgr.GetInstance().has_text = true;
        this.display_obj.visible = true;
        this.ItemOpenAction(label);
    }

    private ItemOpenAction(label: Laya.HTMLDivElement) {
        this.display_obj.scaleY = 0;
        this.display_obj.scaleX = 0;
        
        Laya.Tween.clearTween(this.display_obj)
        Laya.timer.clear(this, this.TimerCall)
        Laya.Tween.to(this.display_obj, { scaleX: 1, scaleY: 1 }, this.total_time, Laya.Ease.circOut, Laya.Handler.create(this, () => {
            Laya.timer.once(this.wait_time, this, this.TimerCall)
        }))
    }


    private TimerCall (){
        if (this.use_delete_method) return
        SysInfoChuanwenMgr.GetInstance().has_text = false;
        this.display_obj.visible = false;
        this._lb_content_html.innerHTML = "";
        SysInfoChuanwenMgr.GetInstance().ShowNextMsg();
    }

    public GetComponents() {
        [
            this._img_bg,
            this._lb_content,
            this._lb_content_html
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_content",
                "_lb_content_html"
            ])
    }
}
window["ChuanwenItem"] = ChuanwenItem