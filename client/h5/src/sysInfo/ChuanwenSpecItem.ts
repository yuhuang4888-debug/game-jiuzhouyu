import { BaseItem1 } from "../common/BaseItem1";
import { PlatformManager } from "../PlatformManager";
import { ResManager } from "../common/ResManager";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
// import { StoryAnimationModel } from "../storyAnimation/StoryAnimationModel";
import { SysInfoChuanwenMgr } from "./SysInfoChuanwenMgr";
import { ChatModel } from "../commonModel/ChatModel";
export class ChuanwenSpecItem extends BaseItem1 {
    private _lb_content: Laya.Label;
    private _gp_fire1: Laya.Box;
    private _gp_fire2: Laya.Box;
    private _gp_fire3: Laya.Box;
    private _gp_glow: Laya.Box;
    private _img_bg: Laya.Image;
    private _lb_content_html:Laya.HTMLDivElement
    private _img_1: Laya.Image
    private has_eff = false;
    // private has_text = false
    private total_time = 0.3 * 1000;
    private item_width = 918;
    private item_height = 90;
    private wait_time = 3000;//15000
    need_refresh
    msg
    public _parent

    public constructor(parent) {
        super(parent);
        this.base_file = "sysInfo";
        this.layout_file = "ChuanwenSpecItem";
        this.is_delay_callback = false;
        this._parent=parent
        this.load_callback = function () {
            // [this._lb_content,this._gp_fire1,this._gp_fire2,this._gp_fire3,this._gp_glow,this._img_bg,this._lb_content_html]=
            // this.GetChildrenByNames(["_lb_content","_gp_fire1","_gp_fire2","_gp_fire3","_gp_glow","_img_bg","_lb_content_html"])
            if (PlatformManager.IsEyouEnPlatform()){
                // this._lb_content.size = 18;
                // this._lb_content_html.style.fontSize=18
            }
            ResManager.GetInstance().SetTexture(this, this._img_bg, "resource/game/sysInfo/texture/uity_087.png");
            this.display_obj.visible = false;
            // this.touchChildren = false;
            // this.touchEnabled = false;
            this.display_obj.y = 330;
            this.display_obj.centerX=0
            // this.horizontalCenter = 0;
            // this.anchorOffsetX = this.item_width * 0.5;
            // this.anchorOffsetY = this.item_height * 0.5;
            if(this.need_refresh){
                this.AppendMessage(this.msg)
            }
        };
    }

    public AppendMessage(content) {
        let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top);
        // if (!StoryAnimationModel.GetInstance().story_animaion_view_is_show
        //     && !LoginModel.GetInstance().is_show_loading_view) {
        //     layer.setChildIndex(this, layer.numChildren - 1);
        // }
        if(this.is_loaded){
            this.RunMessage(content);
            this.need_refresh=false
        }else{
            this.msg=content
            this.need_refresh=true
        }
    }
    private RunMessage(content) {
        if (!content){
            return;
        }
        this._lb_content_html.style.color = "#FFFFFF";
        this._lb_content_html.style.fontSize = 22;
        this._lb_content_html.style.leading=5
        this._lb_content_html.width=520
        this._lb_content_html.style.height=30
        this._lb_content.text = "";
        let label = this._lb_content_html;
        content = content.replace(/\n/g, "");
        content=ChatModel.GetInstance().disposeChtaFace(content,null,null,22)
        label.innerHTML = content;
        ///用box包裹富文本 让文本在容器中居中
        this._lb_content_html.style.width=520
        // label.validateNow();
        SysInfoChuanwenMgr.GetInstance().has_text = true;
        this.display_obj.visible = true;
        this.display_obj.height=this._lb_content_html.contextHeight+44
        this._img_bg.height=this._lb_content_html.contextHeight+44
        this._lb_content_html.x=309-(this._lb_content_html.contextWidth/2)
        this._lb_content_html.y=this.display_obj.height/2-(this._lb_content_html.contextHeight/2)
        this.ItemOpenAction(label);
        // this.AddEff();
    }
    private Finish() {
        SysInfoChuanwenMgr.GetInstance().has_text = false;
        this.display_obj.visible = false;
        this._lb_content.text = "";
        let type = SysInfoChuanwenMgr.GetInstance().ShowNextMsg();
        if (type != 4) {
            this.DelEff();
        }
    }
    private ItemOpenAction(label: Laya.HTMLDivElement) {
        this.display_obj.scaleY = 0;
        this.display_obj.scaleX = 0;
        Laya.Tween.clearTween(this.display_obj)
        Laya.timer.clear(this, this.TimerCall)

        Laya.Tween.to(this.display_obj,{ scaleX: 1, scaleY: 1 },this.total_time,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
            Laya.timer.once(this.wait_time, this, this.TimerCall)
        }))
    }

    private TimerCall = () =>{
        if (this.use_delete_method) return
        SysInfoChuanwenMgr.GetInstance().has_text = false;
        this.display_obj.visible = false;
        this._lb_content_html.innerHTML = "";
        SysInfoChuanwenMgr.GetInstance().ShowNextMsg();
    }

    private AddEff() {
        if (this.has_eff)
            return;
        this.has_eff = true;
        this.AddUIEffect("ui_hearsay_fireworks1", this._gp_fire1, null, null, true, null, null, null, null, null, 2);
        this.AddUIEffect("ui_hearsay_fireworks2", this._gp_fire2, null, null, true, null, null, null, null, null, 2);
        this.AddUIEffect("ui_hearsay_fireworks3", this._gp_fire3, null, null, true);
        this.AddUIEffect("ui_hearsay_glow1", this._gp_glow, null, null, true);
    }
    private DelEff() {
        this.has_eff = false;
        this.ClearUIEffect(this._gp_fire1);
        this.ClearUIEffect(this._gp_fire2);
        this.ClearUIEffect(this._gp_fire3);
        this.ClearUIEffect(this._gp_glow);
    }

    public GetComponents() {
        [
            this._img_bg,
            this._lb_content,
            this._gp_fire1,
            this._gp_fire2,
            this._gp_fire3,
            this._gp_glow,
            this._lb_content_html,
            this._img_1
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_content",
                "_gp_fire1",
                "_gp_fire2",
                "_gp_fire3",
                "_gp_glow",
                "_lb_content_html",
                "_img_1"
            ])
    }
}
window["ChuanwenSpecItem"] = ChuanwenSpecItem